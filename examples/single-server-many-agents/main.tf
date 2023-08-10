## Create single server K3s cluster with SQLite datastore and 3 agents
module "k3s-cluster" {
  source = "../.."
  pvt_key = var.pvt_key
  pvt_key_name = var.pvt_key_name
  server_node_count = 1
  server_node_size = "s-1vcpu-1gb"
  agent_node_count = 3
  jumpbox_ip = var.jumpbox_ip
}
