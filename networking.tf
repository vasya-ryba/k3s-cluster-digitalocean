resource "digitalocean_firewall" "k3s" {
  name = "cloud-firewall"

  droplet_ids = digitalocean_droplet.controlplane[*].id

  # Allow SSH login through jumpbox
  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = [var.jumpbox_ip]
  }
  # Allow kubectl through jumpbox
  inbound_rule {
    protocol = "tcp"
    port_range = "6443"
    source_addresses = [var.jumpbox_ip]
  }

  # Firewall rules according to
  # https://docs.k3s.io/installation/requirements#inbound-rules-for-k3s-server-nodes
  inbound_rule {
    protocol = "tcp"
    port_range = "2379-2380"
    source_droplet_ids = digitalocean_droplet.controlplane[*].id
  }

  inbound_rule {
    protocol = "tcp"
    port_range = "6443"
    source_droplet_ids = digitalocean_droplet.controlplane[*].id
  }

  inbound_rule {
    protocol = "udp"
    port_range = "8472"
    source_droplet_ids = digitalocean_droplet.controlplane[*].id
  }

  inbound_rule {
    protocol = "tcp"
    port_range = "10250"
    source_droplet_ids = digitalocean_droplet.controlplane[*].id
  }

  inbound_rule {
    protocol = "udp"
    port_range = "51820-51821"
    source_droplet_ids = digitalocean_droplet.controlplane[*].id
  }

  // Allow all outbound traffic
  outbound_rule {
    protocol = "tcp"
    port_range = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol = "udp"
    port_range = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

}