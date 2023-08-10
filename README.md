# k3s-cluster-digitalocean
Terraform  module which creates small and cheap K3s cluster in DigitalOcean

## Usage
````hcl
module "k3s-cluster" {
  source = "/path/to/k3s-cluster-digitalocean"
  pvt_key = var.pvt_key //path to private ssh key to access DO hosts
  pvt_key_name = var.pvt_key_name //name of ssh key at DO
  node_image = "centos-7-x64"
  region = "fra1"
  server_node_count = 3
  server_node_size = "s-1vcpu-1gb"
  agent_node_count = 0
  jumpbox_ip = var.jumpbox_ip //optional
}
````
This creates a high availability **k3s** cluster with 3 controlplanes of given size, using etcd datastore. 
There are different architectures available, check https://docs.k3s.io/architecture and [examples](https://github.com/vasya-ryba/k3s-cluster-digitalocean/tree/main/examples).

Module generates `output/kubeconfig.yaml` in project root. If you chose your localhost IP as a jumpbox, you can easily
````bash
export KUBECONFIG=${PROJECT_ROOT}/output/kubeconfig.yaml
````
and use kubectl
````
$ kubectl get nodes
NAME       STATUS   ROLES                       AGE     VERSION
server-0   Ready    control-plane,etcd,master   3m47s   v1.27.4+k3s1
server-1   Ready    control-plane,etcd,master   77s     v1.27.4+k3s1
server-2   Ready    control-plane,etcd,master   49s     v1.27.4+k3s1
````

[This example](https://github.com/vasya-ryba/k3s-cluster-digitalocean/blob/main/examples/single-server/main.tf) shows usage together with kubernetes provider.

## Purpose
For small pet projects, for education, for development. K3s clusters are _relatively_ cheap: [3 servers](https://github.com/vasya-ryba/k3s-cluster-digitalocean/tree/main/examples/many-servers) or [1 server with 3 agents](https://github.com/vasya-ryba/k3s-cluster-digitalocean/tree/main/examples/single-server-many-agents) setup costs **$18**/month.  


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_digitalocean"></a> [digitalocean](#requirement\_digitalocean) | ~> 2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_digitalocean"></a> [digitalocean](#provider\_digitalocean) | ~> 2.0 |
| <a name="provider_external"></a> [external](#provider\_external) | n/a |
| <a name="provider_http"></a> [http](#provider\_http) | n/a |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |


## Resources

| Name | Type |
|------|------|
| [digitalocean_droplet.agent](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/droplet) | resource |
| [digitalocean_droplet.server](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/droplet) | resource |
| [digitalocean_firewall.k3s](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/resources/firewall) | resource |
| [local_file.kubeconfig](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [random_password.k3s_cluster_secret](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [digitalocean_ssh_key.terraform](https://registry.terraform.io/providers/digitalocean/digitalocean/latest/docs/data-sources/ssh_key) | data source |
| [external_external.kubeconfig](https://registry.terraform.io/providers/hashicorp/external/latest/docs/data-sources/external) | data source |
| [http_http.k3s_installer](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agent_node_count"></a> [agent\_node\_count](#input\_agent\_node\_count) | Number of agent nodes | `number` | `3` | no |
| <a name="input_agent_node_size"></a> [agent\_node\_size](#input\_agent\_node\_size) | Size of agent droplet. Check available sizes here: https://slugs.do-api.dev/ | `string` | `"s-1vcpu-512mb-10gb"` | no |
| <a name="input_jumpbox_ip"></a> [jumpbox\_ip](#input\_jumpbox\_ip) | IP address(-es) of host which will be used to connect to the cluster. Example: 4.3.2.1/24 | `string` | `"127.0.0.1"` | no |
| <a name="input_node_image"></a> [node\_image](#input\_node\_image) | OS image for nodes. Check available images here: https://slugs.do-api.dev/ | `string` | `"debian-12-x64"` | no |
| <a name="input_pvt_key"></a> [pvt\_key](#input\_pvt\_key) | Path to SSH private key | `string` | n/a | yes |
| <a name="input_pvt_key_name"></a> [pvt\_key\_name](#input\_pvt\_key\_name) | Name of private key at DigitalOcean | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region for nodes. Check available regions here: https://slugs.do-api.dev/ | `string` | `"fra1"` | no |
| <a name="input_server_node_count"></a> [server\_node\_count](#input\_server\_node\_count) | Number of server nodes | `number` | `1` | no |
| <a name="input_server_node_size"></a> [server\_node\_size](#input\_server\_node\_size) | Size of server droplet. Check available sizes here: https://slugs.do-api.dev/ | `string` | `"s-1vcpu-1gb"` | no |

