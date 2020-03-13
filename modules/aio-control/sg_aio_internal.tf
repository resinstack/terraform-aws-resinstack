resource "aws_security_group" "aio_internal" {
  name        = "resinstack-aio-internal"
  description = "Internal traffic for AIO resinstack controllers."
  vpc_id      = var.vpc_id
}

resource "aws_security_group_rule" "nomad_from_alb" {
  description              = "Accept Nomad traffic from the ALB"
  type                     = "ingress"
  from_port                = 4646
  to_port                  = 4646
  protocol                 = "tcp"
  security_group_id        = aws_security_group.aio_internal.id
  source_security_group_id = aws_security_group.aio_alb_internal.id
}

resource "aws_security_group_rule" "consul_from_alb" {
  description              = "Accept Consul traffic from the ALB"
  type                     = "ingress"
  from_port                = 8500
  to_port                  = 8500
  protocol                 = "tcp"
  security_group_id        = aws_security_group.aio_internal.id
  source_security_group_id = aws_security_group.aio_alb_internal.id
}

resource "aws_security_group_rule" "vault_from_alb" {
  description              = "Accept Vault traffic from the ALB"
  type                     = "ingress"
  from_port                = 8200
  to_port                  = 8200
  protocol                 = "tcp"
  security_group_id        = aws_security_group.aio_internal.id
  source_security_group_id = aws_security_group.aio_alb_internal.id
}
