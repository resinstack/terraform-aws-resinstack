---
dest: /run/config/nomad/85-gen-secret.hcl
mode: 0400
onrender: /usr/bin/service restart nomad
---
consul {
  token = "{{poll "awssm" "${nomad_client_consul_token_name}"}}"
}
