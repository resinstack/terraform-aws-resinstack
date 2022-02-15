resource "local_file" "emissary_nomad_server" {
  count = var.nomad_server ? 1 : 0

  content = templatefile("${path.module}/tpl/nomad_server.tpl", {
    nomad_gossip_key_name   = "resinstack-consul-gossip-key-${var.cluster_tag}"
    nomad_consul_token_name = "resinstack-nomad-server-consul-token-${var.cluster_tag}"
    nomad_vault_token_name  = "resinstack-nomad-vault-token-${var.cluster_tag}"
  })

  filename             = "${var.base_path}/emissary/90-gen-nomad.tpl"
  file_permission      = "0644"
  directory_permission = "0755"
}

resource "local_file" "emissary_nomad_client" {
  count = var.nomad_client ? 1 : 0

  content = templatefile("${path.module}/tpl/nomad_client.tpl", {
    nomad_client_consul_token_name = "resinstack-nomad-client-consul-token-${var.cluster_tag}"
  })

  filename             = "${var.base_path}/emissary/90-gen-nomad.tpl"
  file_permission      = "0644"
  directory_permission = "0755"
}
