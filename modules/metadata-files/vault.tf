resource "local_file" "vault_kms_id" {
  count = var.vault_server ? 1 : 0

  content = "seal \"awskms\" {\n  kms_key_id = \"${var.vault_key_id}\"\n}\n"

  filename             = "${var.base_path}/vault/90-gen-seal.hcl"
  file_permission      = "0644"
  directory_permission = "0755"
}

data "template_file" "emissary_vault" {
  count = var.vault_server ? 1 : 0

  template = file("${path.module}/tpl/vault.tpl")
  vars = {
    vault_consul_token_name = "resinstack-vault-consul-token-${var.cluster_tag}"
  }
}

resource "local_file" "emissary_vault" {
  count = var.vault_server ? 1 : 0

  content = data.template_file.emissary_vault[0].rendered

  filename             = "${var.base_path}/emissary/90-gen-vault.tpl"
  file_permission      = "0644"
  directory_permission = "0755"
}

resource "local_file" "vault_placeholder" {
  count = var.vault_server ? 1 : 0

  content = <<EOT
# This file exists purely as a placeholder so that Vault can see a
# configured backend when it starts up.  After emissary runs this file
# is replaced with one containing a consul token.
storage "consul" {
  service_tags = "proxy.enable=true"
}
EOT

  filename             = "${var.base_path}/vault/85-gen-secret.hcl"
  file_permission      = "0644"
  directory_permission = "0755"
}
