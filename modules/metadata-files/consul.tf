resource "local_file" "consul_server_retry_join" {
  content = "retry_join = [\"provider=aws tag_key=resinstack:consul:autojoin tag_value=${var.cluster_tag}\"]\n"

  filename             = "${var.base_path}/consul/90-gen-retry-join.hcl"
  file_permission      = "0644"
  directory_permission = "0755"
}

resource "local_file" "emissary_consul_server" {
  count = var.consul_server ? 1 : 0

  content = templatefile("${path.module}/tpl/consul_server.tpl", {
    consul_gossip_key_name = "resinstack-consul-gossip-key-${var.cluster_tag}"
  })

  filename             = "${var.base_path}/emissary/90-gen-consul.tpl"
  file_permission      = "0644"
  directory_permission = "0755"
}

resource "local_file" "emissary_consul_agent" {
  count = var.consul_agent ? 1 : 0

  content = templatefile("${path.module}/tpl/consul_agent.tpl", {
    consul_gossip_key_name  = "resinstack-consul-gossip-key-${var.cluster_tag}"
    consul_agent_token_name = "resinstack-consul-agent-token-${var.cluster_tag}"
  })

  filename             = "${var.base_path}/emissary/90-gen-consul.tpl"
  file_permission      = "0644"
  directory_permission = "0755"
}
