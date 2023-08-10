variable "pvt_key" {
  description = "Path to SSH private key"
  type = string
}

variable "pvt_key_name" {
  description = "Name of private key at DigitalOcean"
  type = string
}

variable "node_image" {
  description = "OS image for nodes. Check available images here: https://slugs.do-api.dev/"
  default = "centos-7-x64"
  type = string
}

variable "region" {
  description = "Region for nodes. Check available regions here: https://slugs.do-api.dev/"
  default = "fra1"
  type = string
}

variable "server_node_count" {
  description = "Number of server nodes"
  default = 1
  type = number
}

variable "server_node_size" {
  description = "Size of server droplet. Check available sizes here: https://slugs.do-api.dev/"
  default = "s-1vcpu-1gb"
  type = string
}

variable "agent_node_count" {
  description = "Number of agent nodes"
  default = 3
  type = number
}

variable "agent_node_size" {
  description = "Size of agent droplet. Check available sizes here: https://slugs.do-api.dev/"
  default = "s-1vcpu-512mb-10gb"
  type = string
}

variable jumpbox_ip {
  description = "IP address(-es) of host which will be used to connect to the cluster. Example: 4.3.2.1/24"
  type = string
  default = "127.0.0.1"
}