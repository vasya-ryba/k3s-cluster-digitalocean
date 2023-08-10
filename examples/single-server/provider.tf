terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "~> 2.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}

provider "kubernetes" {
  config_path    = "${path.root}/output/kubeconfig.yaml"
  config_context = "default"
}