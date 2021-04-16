resource "aws_security_group" "consul_server" {
  name        = "resinstack-consul-server"
  description = "Server RPC Group"
  vpc_id      = var.vpc_id

  tags = {
    "resinstack:cluster" = var.cluster_tag
  }
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

resource "aws_security_group_rule" "consul_server_rpc_agents" {
  description              = "Accept RPC from agents"
  type                     = "ingress"
  from_port                = 8300
  to_port                  = 8300
  protocol                 = "tcp"
  security_group_id        = aws_security_group.consul_server.id
  source_security_group_id = aws_security_group.consul_gossip.id
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

resource "aws_security_group_rule" "consul_from_cluster_worker" {
  description              = "Accept RPC from cluster workers"
  type                     = "ingress"
  from_port                = 8300
  to_port                  = 8300
  protocol                 = "tcp"
  security_group_id        = aws_security_group.consul_server.id
  source_security_group_id = aws_security_group.cluster_worker.id
}

resource "aws_security_group_rule" "consul_api_vault" {
  description              = "Accept API traffic from Vault Servers"
  type                     = "ingress"
  from_port                = 8500
  to_port                  = 8500
  protocol                 = "tcp"
  security_group_id        = aws_security_group.consul_server.id
  source_security_group_id = aws_security_group.vault_server.id
}
