resource "aws_security_group" "vault_server" {
  name        = "resinstack-vault-server"
  description = "Vault server group"
  vpc_id      = var.vpc_id

  tags = {
    "resinstack:cluster" = var.cluster_tag
  }
}

resource "aws_security_group_rule" "vault_api_client" {
  for_each = toset(var.vault_api_client_sgs)

  description              = "Accept API traffic from additional sources"
  type                     = "ingress"
  from_port                = 8200
  to_port                  = 8200
  protocol                 = "tcp"
  security_group_id        = aws_security_group.vault_server.id
  source_security_group_id = each.value
}

resource "aws_security_group_rule" "vault_server_sync" {
  description       = "Accept server-to-server sync traffic"
  type              = "ingress"
  from_port         = 8201
  to_port           = 8201
  protocol          = "tcp"
  security_group_id = aws_security_group.vault_server.id
  self              = true
}

resource "aws_security_group_rule" "vault_server_sync_egress" {
  description       = "Permit server-to-server sync traffic"
  type              = "egress"
  from_port         = 8201
  to_port           = 8201
  protocol          = "tcp"
  security_group_id = aws_security_group.vault_server.id
  self              = true
}

resource "aws_security_group_rule" "vault_server_from_cluster_worker" {
  description              = "Accept API traffic from cluster workers"
  type                     = "ingress"
  from_port                = 8200
  to_port                  = 8200
  protocol                 = "tcp"
  security_group_id        = aws_security_group.vault_server.id
  source_security_group_id = aws_security_group.cluster_worker.id
}

resource "aws_security_group_rule" "vault_server_from_nomad_server" {
  description              = "Accept API traffic from Nomad servers"
  type                     = "ingress"
  from_port                = 8200
  to_port                  = 8200
  protocol                 = "tcp"
  security_group_id        = aws_security_group.vault_server.id
  source_security_group_id = aws_security_group.nomad_server.id
}

resource "aws_security_group_rule" "vault_to_consul" {
  description              = "Permit HTTP API to Consul"
  type                     = "egress"
  from_port                = 8500
  to_port                  = 8500
  protocol                 = "tcp"
  security_group_id        = aws_security_group.vault_server.id
  source_security_group_id = aws_security_group.consul_server.id
}

resource "aws_security_group_rule" "vault_to_nomad" {
  description              = "Permit HTTP API to Nomad"
  type                     = "egress"
  from_port                = 4646
  to_port                  = 4646
  protocol                 = "tcp"
  security_group_id        = aws_security_group.vault_server.id
  source_security_group_id = aws_security_group.nomad_server.id
}
