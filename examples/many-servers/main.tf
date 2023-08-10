## Create multi server HA K3s cluster with ETCD datastore on CentOS 7 nodes
module "k3s-cluster" {
  source = "../.."
  pvt_key = var.pvt_key
  pvt_key_name = var.pvt_key_name
  node_image = "centos-7-x64"
  server_node_count = 3
  server_node_size = "s-1vcpu-1gb"
  agent_node_count = 0
  jumpbox_ip = var.jumpbox_ip
}
