---
dest: /run/config/vault/85-gen-secret.hcl
mode: 0400
onrender: /usr/bin/service restart vault
---
storage "consul" {
  token        = "{{poll "awssm" "${vault_consul_token_name}"}}"
  service_tags = "proxy.enable=true"
}
