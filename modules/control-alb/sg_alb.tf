resource "aws_security_group" "alb" {
  name        = "resinstack-control-alb"
  description = "Traffic between the ALB and the control plane."
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "nomad_from_direct" {
  description              = "Accept Nomad from direct access group."
  type                     = "ingress"
  from_port                = 4646
  to_port                  = 4646
  protocol                 = "tcp"
  security_group_id        = aws_security_group.alb.id
  source_security_group_id = var.direct_access_security_group
}

resource "aws_security_group_rule" "consul_from_direct" {
  description              = "Accept Consul from direct access group."
  type                     = "ingress"
  from_port                = 8500
  to_port                  = 8500
  protocol                 = "tcp"
  security_group_id        = aws_security_group.alb.id
  source_security_group_id = var.direct_access_security_group
}

resource "aws_security_group_rule" "vault_from_direct" {
  description              = "Accept Vault from direct access group."
  type                     = "ingress"
  from_port                = 8200
  to_port                  = 8200
  protocol                 = "tcp"
  security_group_id        = aws_security_group.alb.id
  source_security_group_id = var.direct_access_security_group
}

resource "aws_security_group_rule" "nomad_target" {
  for_each = toset(var.nomad_target_sgs)

  description              = "Permit traffic to nomad targets"
  type                     = "egress"
  from_port                = 4646
  to_port                  = 4646
  protocol                 = "tcp"
  security_group_id        = aws_security_group.alb.id
  source_security_group_id = each.value
}

resource "aws_security_group_rule" "consul_target" {
  for_each = toset(var.consul_target_sgs)

  description              = "Permit traffic to consul targets"
  type                     = "egress"
  from_port                = 8500
  to_port                  = 8500
  protocol                 = "tcp"
  security_group_id        = aws_security_group.alb.id
  source_security_group_id = each.value
}

resource "aws_security_group_rule" "vault_target" {
  for_each = toset(var.vault_target_sgs)

  description              = "Permit traffic to vault targets"
  type                     = "egress"
  from_port                = 8200
  to_port                  = 8200
  protocol                 = "tcp"
  security_group_id        = aws_security_group.alb.id
  source_security_group_id = each.value
}
