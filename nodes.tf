locals {
  node_image = "centos-7-x64"
  region = "fra1"
  controlplane_node_count = 1
  controlplane_node_size = "s-1vcpu-1gb"
}

# Fetch the k3s installation script
data "http" "k3s_installer" {
  url = "https://get.k3s.io/"
}

// Generate the k3s token used by all nodes to join the cluster
resource "random_password" "k3s_cluster_secret" {
  length  = 48
  special = false
}

resource "digitalocean_droplet" "controlplane" {
  count = local.controlplane_node_count
  image  = local.node_image
  name   = "controlplane-${count.index}"
  region = local.region
  size   = local.controlplane_node_size
  ssh_keys = [
    data.digitalocean_ssh_key.terraform.id
  ]

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
      "sh /tmp/k3s-installer --token ${random_password.k3s_cluster_secret.result}"
    ]
  }
}

data "external" "kubeconfig" {
  program = ["/bin/sh", "certs.sh", var.pvt_key, digitalocean_droplet.controlplane[0].ipv4_address]
  depends_on = [digitalocean_droplet.controlplane]
}
