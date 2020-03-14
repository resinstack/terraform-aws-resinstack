resource "aws_lb" "alb" {
  name               = "aio-control"
  internal           = true
  load_balancer_type = "application"

  security_groups = [aws_security_group.alb.id]
  subnets         = var.vpc_subnets
}

resource "aws_lb_listener" "nomad" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 4646
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nomad.arn
  }
}

resource "aws_lb_target_group" "nomad" {
  name     = "resinstack-nomad"
  port     = 4646
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    interval            = 5
    path                = "/v1/status/leader"
    timeout             = 2
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "consul" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 8500
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.consul.arn
  }
}

resource "aws_lb_target_group" "consul" {
  name     = "resinstack-consul"
  port     = 8500
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    interval            = 5
    path                = "/v1/status/leader"
    timeout             = 2
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "vault" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 8200
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.vault.arn
  }
}

resource "aws_lb_target_group" "vault" {
  name     = "resinstack-vault"
  port     = 8200
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    interval            = 5
    path                = "/v1/sys/health"
    timeout             = 2
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200,429"
  }
}
