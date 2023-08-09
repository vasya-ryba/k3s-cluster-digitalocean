# DigitalOcean token
variable "do_token" {}

# Path to SSH private key
variable "pvt_key" {}

# Name of private key at DigitalOcean
variable "pvt_key_name" {}

# IP address(-es) of host which will be used to connect to the cluster
# Example: 4.3.2.1/24
variable jumpbox_ip {}