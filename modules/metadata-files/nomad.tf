data "template_file" "emissary_nomad_server" {
  count = var.nomad_server ? 1 : 0

  template = file("${path.module}/tpl/nomad_server.tpl")
  vars = {
    nomad_gossip_key_name   = "resinstack-consul-gossip-key-${var.cluster_tag}"
    nomad_consul_token_name = "resinstack-nomad-server-consul-token-${var.cluster_tag}"
    nomad_vault_token_name  = "resinstack-nomad-vault-token-${var.cluster_tag}"
  }
}

resource "local_file" "emissary_nomad_server" {
  count = var.nomad_server ? 1 : 0

  content = data.template_file.emissary_nomad_server[0].rendered

  filename             = "${var.base_path}/emissary/90-gen-nomad.tpl"
  file_permission      = "0644"
  directory_permission = "0755"
}

data "template_file" "emissary_nomad_client" {
  count = var.nomad_client ? 1 : 0

  template = file("${path.module}/tpl/nomad_client.tpl")
  vars = {
    nomad_client_consul_token_name = "resinstack-nomad-client-consul-token-${var.cluster_tag}"
  }
}

resource "local_file" "emissary_nomad_client" {
  count = var.nomad_client ? 1 : 0

  content = data.template_file.emissary_nomad_client[0].rendered

  filename             = "${var.base_path}/emissary/90-gen-nomad.tpl"
  file_permission      = "0644"
  directory_permission = "0755"
}
