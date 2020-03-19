resource "aws_security_group" "cluster_worker" {
  name        = "resinstack-cluster-workers"
  description = "General cluster member group with access to control plane."
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "cluster_worker_to_vault" {
  description              = "Permit API requests to Vault"
  type                     = "egress"
  from_port                = 8200
  to_port                  = 8200
  protocol                 = "tcp"
  security_group_id        = aws_security_group.cluster_worker.id
  source_security_group_id = aws_security_group.vault_server.id
}

resource "aws_security_group_rule" "cluster_worker_to_nomad" {
  description              = "Permit API requests to Nomad servers"
  type                     = "egress"
  from_port                = 4647
  to_port                  = 4647
  protocol                 = "tcp"
  security_group_id        = aws_security_group.cluster_worker.id
  source_security_group_id = aws_security_group.nomad_server.id
}

resource "aws_security_group_rule" "cluster_worker_to_consul" {
  description              = "Permit API requests to Consul servers"
  type                     = "egress"
  from_port                = 8300
  to_port                  = 8300
  protocol                 = "tcp"
  security_group_id        = aws_security_group.cluster_worker.id
  source_security_group_id = aws_security_group.consul_server.id
}
