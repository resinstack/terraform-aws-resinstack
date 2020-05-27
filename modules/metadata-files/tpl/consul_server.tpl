---
mode: 0400
dest: /run/config/consul/85-gen-secret.hcl
onrender: /usr/bin/service restart consul
---
encrypt = "{{poll "awssm" "${consul_gossip_key_name}"}}"
