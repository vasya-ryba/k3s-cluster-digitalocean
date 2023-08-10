locals {
  installc = nonsensitive("K3S_TOKEN=${random_password.k3s_cluster_secret.result} sh /tmp/k3s-installer")
}

data "digitalocean_ssh_key" "terraform" {
  name = var.pvt_key_name
}

# Fetch k3s installation script
data "http" "k3s_installer" {
  url = "https://get.k3s.io/"
}

# Generate k3s token used by all nodes to join the cluster
resource "random_password" "k3s_cluster_secret" {
  length  = 48
  special = false
}

resource "digitalocean_droplet" "server" {
  count = var.server_node_count
  image  = var.node_image
  name   = "server-${count.index}"
  region = var.region
  size   = var.server_node_size
  ssh_keys = [
    data.digitalocean_ssh_key.terraform.id
  ]
  tags = ["k3s-servers"]

  connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = file(var.pvt_key)
    timeout = "2m"
  }

  provisioner "file" {
    content = data.http.k3s_installer.response_body
    destination = "/tmp/k3s-installer"
  }

  provisioner "remote-exec" {

    inline = concat(
    // Add 1GB of swap
    [
      "dd if=/dev/zero of=/swapfile bs=1024 count=1048576",
      "chmod 600 /swapfile",
      "mkswap /swapfile",
      "swapon /swapfile",
      "echo \"/swapfile swap swap defaults 0 0\" >> /etc/fstab"
    ],

    // Run K3s install script for servers.
    // If single server node, use SQLite, else create HA etcd cluster.
    var.server_node_count > 1 ? (count.index == 0 ? [
      "INSTALL_K3S_EXEC=\"server\" ${local.installc} --cluster-init"
    ]:[
      "INSTALL_K3S_EXEC=\"server\" K3S_URL=\"https://${digitalocean_droplet.server[0].ipv4_address}:6443\" ${local.installc}"
    ]):[
      "INSTALL_K3S_EXEC=\"server\" ${local.installc}"
    ])
  }
  depends_on = [digitalocean_firewall.k3s]
}

resource "digitalocean_droplet" "agent" {
  count = var.agent_node_count
  image  = var.node_image
  name   = "agent-${count.index}"
  region = var.region
  size   = var.agent_node_size
  ssh_keys = [
    data.digitalocean_ssh_key.terraform.id
  ]
  tags = ["k3s-agents"]

  connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = file(var.pvt_key)
    timeout = "2m"
  }

  provisioner "file" {
    content = data.http.k3s_installer.response_body
    destination = "/tmp/k3s-installer"
  }

  provisioner "remote-exec" {

    inline = [
      // Add 1GB of swap
      "dd if=/dev/zero of=/swapfile bs=1024 count=1048576",
      "chmod 600 /swapfile",
      "mkswap /swapfile",
      "swapon /swapfile",
      "echo \"/swapfile swap swap defaults 0 0\" >> /etc/fstab",
      // Join cluster
      "INSTALL_K3S_EXEC=\"agent\" K3S_URL=\"https://${digitalocean_droplet.server[0].ipv4_address}:6443\" ${local.installc}"
    ]
  }
  depends_on = [digitalocean_droplet.server]
}

data "external" "kubeconfig" {
  program = sensitive(["/bin/sh", "${path.module}/certs.sh", var.pvt_key, digitalocean_droplet.server[0].ipv4_address, path.root])
  depends_on = [digitalocean_droplet.server[0]]
}
