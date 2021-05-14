resource "aws_security_group" "lb" {
  name        = "resinstack-demo-lb-sg-${random_pet.cluster_tag.id}"
  description = "Security group for the LB"
  vpc_id      = aws_vpc.vpc.id
}

resource "aws_security_group_rule" "lb_accept_ports" {
  for_each = { "http" : 80, "nomad" : 4646, "vault" : 8200, "consul" : 8500 }

  security_group_id = aws_security_group.lb.id

  type        = "ingress"
  from_port   = each.value
  to_port     = each.value
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "lb_to_nomad" {
  security_group_id = aws_security_group.lb.id

  type      = "egress"
  from_port = 4646
  to_port   = 4646
  protocol  = "tcp"

  source_security_group_id = module.resinstack_security_groups.nomad_server_id
}

resource "aws_security_group_rule" "lb_to_vault" {
  security_group_id = aws_security_group.lb.id

  type      = "egress"
  from_port = 8200
  to_port   = 8200
  protocol  = "tcp"

  source_security_group_id = module.resinstack_security_groups.vault_server_id
}

resource "aws_security_group_rule" "lb_to_consul" {
  security_group_id = aws_security_group.lb.id

  type      = "egress"
  from_port = 8500
  to_port   = 8500
  protocol  = "tcp"

  source_security_group_id = module.resinstack_security_groups.consul_server_id
}


resource "aws_lb" "lb" {
  depends_on = [aws_internet_gateway.gw]

  name               = "resinstack-${random_pet.cluster_tag.id}"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]
  subnets            = [aws_subnet.main.id, aws_subnet.secondary.id]
}

resource "aws_lb_target_group" "lb_nomad" {
  name     = "nomad"
  port     = 4646
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    interval            = 5
    path                = "/v1/status/leader"
    timeout             = 2
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  deregistration_delay = 30
}

resource "aws_lb_target_group" "lb_consul" {
  name     = "consul"
  port     = 8500
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    interval            = 5
    path                = "/v1/status/leader"
    timeout             = 2
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  deregistration_delay = 30
}

resource "aws_lb_target_group" "lb_vault" {
  name     = "vault"
  port     = 8200
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    interval            = 5
    path                = "/v1/sys/health"
    timeout             = 2
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200,429"
  }

  deregistration_delay = 30
}

resource "aws_lb_target_group" "lb_default" {
  name     = "default"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    enabled = true
    path    = "/ping"
    port    = 8080
  }

  deregistration_delay = 30
}

resource "aws_lb_listener" "lb_http" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_default.arn
  }
}

resource "aws_lb_listener" "lb_nomad" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 4646
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_nomad.arn
  }
}

resource "aws_lb_listener" "lb_vault" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 8200
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_vault.arn
  }
}

resource "aws_lb_listener" "lb_consul" {
  load_balancer_arn = aws_lb.lb.arn
  port              = 8500
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_consul.arn
  }
}

