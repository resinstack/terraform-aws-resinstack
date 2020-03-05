resource "aws_security_group" "nomad_server" {
  name        = "nomad-server"
  description = "Nomad Server traffic"
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "nomad_internal_rpc" {
  description       = "Accept server-server RPC traffic"
  type              = "ingress"
  from_port         = 4647
  to_port           = 4647
  protocol          = "tcp"
  security_group_id = aws_security_group.nomad_server.id
  self              = true
}

resource "aws_security_group_rule" "nomad_internal_rpc_egress" {
  description              = "Permit server-server RPC traffic"
  type                     = "egress"
  from_port                = 4647
  to_port                  = 4647
  protocol                 = "tcp"
  security_group_id        = aws_security_group.nomad_server.id
  source_security_group_id = aws_security_group.nomad_server.id
}

resource "aws_security_group_rule" "nomad_serf_tcp" {
  description       = "Accept server-server gossip traffic"
  type              = "ingress"
  from_port         = 4648
  to_port           = 4648
  protocol          = "tcp"
  security_group_id = aws_security_group.nomad_server.id
  self              = true
}

resource "aws_security_group_rule" "nomad_serf_tcp_egress" {
  description              = "Permit server-server gossip traffic"
  type                     = "egress"
  from_port                = 4648
  to_port                  = 4648
  protocol                 = "tcp"
  security_group_id        = aws_security_group.nomad_server.id
  source_security_group_id = aws_security_group.nomad_server.id
}

resource "aws_security_group_rule" "nomad_serf_udp" {
  description       = "Accept server-server gossip traffic"
  type              = "ingress"
  from_port         = 4648
  to_port           = 4648
  protocol          = "udp"
  security_group_id = aws_security_group.nomad_server.id
  self              = true
}

resource "aws_security_group_rule" "nomad_serf_udp_egress" {
  description              = "Permit server-server gossip traffic"
  type                     = "egress"
  from_port                = 4648
  to_port                  = 4648
  protocol                 = "udp"
  security_group_id        = aws_security_group.nomad_server.id
  source_security_group_id = aws_security_group.nomad_server.id
}
