resource "aws_security_group" "consul_server" {
  name        = "resinstack-consul-server"
  description = "Server RPC Group"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "consul_server_rpc" {
  description       = "Accept Server RPC from servers"
  type              = "ingress"
  from_port         = 8300
  to_port           = 8300
  protocol          = "tcp"
  security_group_id = aws_security_group.consul_server.id
  self              = true
}

resource "aws_security_group_rule" "consul_server_rpc_egress" {
  description              = "Accept Server RPC from servers"
  type                     = "egress"
  from_port                = 8300
  to_port                  = 8300
  protocol                 = "tcp"
  security_group_id        = aws_security_group.consul_server.id
  source_security_group_id = aws_security_group.consul_server.id
}

resource "aws_security_group_rule" "consul_api_client" {
  for_each = toset(var.consul_api_client_sgs)

  description              = "Accept API traffic from additional sources"
  type                     = "ingress"
  from_port                = 8500
  to_port                  = 8500
  protocol                 = "tcp"
  security_group_id        = aws_security_group.consul_server.id
  source_security_group_id = each.value
}
