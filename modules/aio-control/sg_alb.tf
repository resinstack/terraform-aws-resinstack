resource "aws_security_group" "aio_alb_internal" {
  name        = "resinstack-aio-alb-internal"
  description = "Traffic between the ALB and the control plane."
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "nomad_from_direct" {
  description              = "Accept Nomad from direct access group."
  type                     = "ingress"
  from_port                = 4646
  to_port                  = 4646
  protocol                 = "tcp"
  security_group_id        = aws_security_group.aio_alb_internal.id
  source_security_group_id = var.direct_access_security_group
}

resource "aws_security_group_rule" "consul_from_direct" {
  description              = "Accept Consul from direct access group."
  type                     = "ingress"
  from_port                = 8500
  to_port                  = 8500
  protocol                 = "tcp"
  security_group_id        = aws_security_group.aio_alb_internal.id
  source_security_group_id = var.direct_access_security_group
}

resource "aws_security_group_rule" "vault_from_direct" {
  description              = "Accept Vault from direct access group."
  type                     = "ingress"
  from_port                = 8200
  to_port                  = 8200
  protocol                 = "tcp"
  security_group_id        = aws_security_group.aio_alb_internal.id
  source_security_group_id = var.direct_access_security_group
}

resource "aws_security_group_rule" "nomad_to_control" {
  description              = "Permit Nomad to the control group."
  type                     = "egress"
  from_port                = 4646
  to_port                  = 4646
  protocol                 = "tcp"
  security_group_id        = aws_security_group.aio_alb_internal.id
  source_security_group_id = aws_security_group.aio_internal.id
}

resource "aws_security_group_rule" "consul_to_control" {
  description              = "Permit Consul to the control group."
  type                     = "egress"
  from_port                = 8500
  to_port                  = 8500
  protocol                 = "tcp"
  security_group_id        = aws_security_group.aio_alb_internal.id
  source_security_group_id = aws_security_group.aio_internal.id
}

resource "aws_security_group_rule" "vault_to_control" {
  description              = "Permit Vault to the control group."
  type                     = "egress"
  from_port                = 8200
  to_port                  = 8200
  protocol                 = "tcp"
  security_group_id        = aws_security_group.aio_alb_internal.id
  source_security_group_id = aws_security_group.aio_internal.id
}
