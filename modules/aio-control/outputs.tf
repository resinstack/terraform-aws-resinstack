output "alb_dns_name" {
  value       = aws_lb.alb.dns_name
  description = "DNS Name for the control ALB"
}

output "alb_zone_id" {
  value       = aws_lb.alb.zone_id
  description = "Canonical hosted zone ID of the ALB"
}

output "alb_sg" {
  value       = aws_security_group.aio_alb_internal.id
  description = "Security group that accepts traffic to the ALB"
}
