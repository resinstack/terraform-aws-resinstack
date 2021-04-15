resource "aws_security_group" "consul_gossip" {
  name        = "resinstack-consul-gossip"
  description = "Permit consul gossip traffic."
  vpc_id      = var.vpc_id

  tags = {
    "resinstack:cluster" = var.cluster_tag
  }
}

resource "aws_security_group_rule" "consul_gossip_tcp" {
  description       = "Permit consul gossip (tcp)"
  type              = "ingress"
  from_port         = 8301
  to_port           = 8301
  protocol          = "tcp"
  security_group_id = aws_security_group.consul_gossip.id
  self              = true
}

resource "aws_security_group_rule" "consul_gossip_tcp_egress" {
  description              = "Permit consul gossip (tcp)"
  type                     = "egress"
  from_port                = 8301
  to_port                  = 8301
  protocol                 = "tcp"
  security_group_id        = aws_security_group.consul_gossip.id
  source_security_group_id = aws_security_group.consul_gossip.id
}

resource "aws_security_group_rule" "consul_gossip_udp" {
  description       = "Permit consul gossip (udp)"
  type              = "ingress"
  from_port         = 8301
  to_port           = 8301
  protocol          = "udp"
  security_group_id = aws_security_group.consul_gossip.id
  self              = true
}

resource "aws_security_group_rule" "consul_gossip_udp_egress" {
  description              = "Permit consul gossip (udp)"
  type                     = "egress"
  from_port                = 8301
  to_port                  = 8301
  protocol                 = "udp"
  security_group_id        = aws_security_group.consul_gossip.id
  source_security_group_id = aws_security_group.consul_gossip.id
}

resource "aws_security_group_rule" "consul_rcp_access" {
  description              = "Permit RPC to servers"
  type                     = "egress"
  from_port                = 8300
  to_port                  = 8300
  protocol                 = "tcp"
  security_group_id        = aws_security_group.consul_gossip.id
  source_security_group_id = aws_security_group.consul_server.id
}
