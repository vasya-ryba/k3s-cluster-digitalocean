locals {
    kubeconfig = <<EOF
apiVersion: v1
clusters:
- cluster:
    server: https://${digitalocean_droplet.server[0].ipv4_address}:6443
    certificate-authority-data: ${data.external.kubeconfig.result.server_cert}
  name: default
contexts:
- context:
    cluster: default
    user: default
  name: default
current-context: default
kind: Config
preferences: {}
users:
- name: default
  user:
    client-certificate-data: ${data.external.kubeconfig.result.client_cert}
    client-key-data: ${data.external.kubeconfig.result.client_key}
EOF
}

resource "local_file" "kubeconfig" {
  filename        = "${path.root}/output/kubeconfig.yaml"
  content         = local.kubeconfig
  file_permission = "600"
}