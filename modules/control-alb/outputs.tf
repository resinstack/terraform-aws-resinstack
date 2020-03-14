output "nomad_target_group" {
  value       = aws_lb_target_group.nomad.arn
  description = "ARN of the Nomad target group"
}

output "consul_target_group" {
  value       = aws_lb_target_group.consul.arn
  description = "ARN of the Consul target group"
}

output "vault_target_group" {
  value       = aws_lb_target_group.vault.arn
  description = "ARN of the Vault target group"
}

output "dns_name" {
  value       = aws_lb.alb.dns_name
  description = "DNS name of the ALB"
}

output "zone_id" {
  value       = aws_lb.alb.zone_id
  description = "Zone ID of the ALB"
}

output "alb_sg" {
  value       = aws_security_group.alb.id
  description = "ID of the ALB's security group"
}
