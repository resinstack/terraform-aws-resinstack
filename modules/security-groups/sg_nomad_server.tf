resource "aws_security_group" "nomad_server" {
  name        = "resinstack-nomad-server"
  description = "Nomad Server traffic"
  vpc_id      = var.vpc_id

  tags = {
    "resinstack:cluster" = var.cluster_tag
  }
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

resource "aws_security_group_rule" "nomad_api_client" {
  for_each = toset(var.nomad_api_client_sgs)

  description              = "Accept API traffic from additional sources"
  type                     = "ingress"
  from_port                = 4646
  to_port                  = 4646
  protocol                 = "tcp"
  security_group_id        = aws_security_group.nomad_server.id
  source_security_group_id = each.value
}

resource "aws_security_group_rule" "nomad_from_cluster_worker" {
  description              = "Accept API traffic from cluster workers"
  type                     = "ingress"
  from_port                = 4647
  to_port                  = 4647
  protocol                 = "tcp"
  security_group_id        = aws_security_group.nomad_server.id
  source_security_group_id = aws_security_group.cluster_worker.id
}

resource "aws_security_group_rule" "nomad_api_vault" {
  # This one is needed for the vault to be able to connect to nomad
  # and issue nomad tokens to vault clients.

  description              = "Accept API traffic from Vault Servers"
  type                     = "ingress"
  from_port                = 4646
  to_port                  = 4646
  protocol                 = "tcp"
  security_group_id        = aws_security_group.nomad_server.id
  source_security_group_id = aws_security_group.vault_server.id
}

resource "aws_security_group_rule" "nomad_to_vault" {
  # This one is needed to allow Nomad to connect to vault and renew
  # its own tokens and maintain the integrationf for allowing tasks to
  # use vault secrets.

  description              = "Permit API traffic to vault"
  type                     = "egress"
  from_port                = 8200
  to_port                  = 8200
  protocol                 = "tcp"
  security_group_id        = aws_security_group.nomad_server.id
  source_security_group_id = aws_security_group.vault_server.id
}
