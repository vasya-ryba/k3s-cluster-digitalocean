## Create single server K3s cluster with SQLite datastore
module "k3s-cluster" {
  source = "../.."
  pvt_key = var.pvt_key
  pvt_key_name = var.pvt_key_name
  server_node_count = 1
  server_node_size = "s-1vcpu-2gb"
  agent_node_count = 0
  jumpbox_ip = var.jumpbox_ip
}

## Run nginx
resource "kubernetes_pod" "test" {
  metadata {
    name = "nginx-example"
  }

  spec {
    container {
      image = "nginx:1.21.6"
      name  = "example"

      port {
        container_port = 80
      }

      liveness_probe {
        http_get {
          path = "/"
          port = 80
        }

        initial_delay_seconds = 3
        period_seconds        = 3
      }
    }
  }
}