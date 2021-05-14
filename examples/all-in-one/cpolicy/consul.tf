module "consul_base" {
  source  = "resinstack/base/consul"
  version = "0.3.0"

  anonymous_node_read    = true
  anonymous_service_read = true
  anonymous_agent_read   = true
}
