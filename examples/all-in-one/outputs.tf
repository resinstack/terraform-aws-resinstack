output "api_addresses" {
  value = {
    nomad  = "http://${aws_lb.lb.dns_name}:4646"
    vault  = "http://${aws_lb.lb.dns_name}:8200"
    consul = "http://${aws_lb.lb.dns_name}:8500"
  }
  description = "API addresses of the running cluster"
}

resource "local_file" "bootstrap_vars" {
  filename = "${path.module}/cpolicy/vars.sh"
  content = templatefile("${path.module}/vars.sh.tpl",
    {
      alb_addr = aws_lb.lb.dns_name,

      sm-consul-agent-token        = module.resinstack_security_setup.secretmanager_names["consul-agent-token"]
      sm-consul-gossip-key         = module.resinstack_security_setup.secretmanager_names["consul-gossip-key"]
      sm-nomad-gossip-key          = module.resinstack_security_setup.secretmanager_names["nomad-gossip-key"]
      sm-nomad-client-consul-token = module.resinstack_security_setup.secretmanager_names["nomad-client-consul-token"]
      sm-nomad-server-consul-token = module.resinstack_security_setup.secretmanager_names["nomad-server-consul-token"]
      sm-nomad-server-vault-token  = module.resinstack_security_setup.secretmanager_names["nomad-vault-token"]
      sm-vault-consul-token        = module.resinstack_security_setup.secretmanager_names["vault-consul-token"]
  })
}
