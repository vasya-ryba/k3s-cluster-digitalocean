variable "do_token" {
  description = "DigitalOcean token"
  type = string
}

variable "pvt_key" {
  description = "Path to SSH private key"
  type = string
}

variable "pvt_key_name" {
  description = "Name of private key at DigitalOcean"
  type = string
}

variable jumpbox_ip {
  description = "IP address(-es) of host which will be used to connect to the cluster. Example: 4.3.2.1/24"
  type = string
}
