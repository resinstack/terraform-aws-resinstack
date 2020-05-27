---
dest: /run/config/nomad/85-gen-secret.hcl
mode: 0400
onrender: /usr/bin/service restart nomad
---

server {
  encrypt = "{{poll "awssm" "${nomad_gossip_key_name}"}}"
}

consul {
  token = "{{poll "awssm" "${nomad_consul_token_name}"}}"
}

vault {
    enabled = true
    address = "http://active.vault.service.consul:8200"
    create_from_role = "resin-nomad-server"
    token = "{{poll "awssm" "${nomad_vault_token_name}"}}"
}
