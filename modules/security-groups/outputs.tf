output "consul_gossip_id" {
  value       = aws_security_group.consul_gossip.id
  description = "Group for consul gossip members"
}

output "consul_server_id" {
  value       = aws_security_group.consul_server.id
  description = "Group for consul server members"
}

output "nomad_server_id" {
  value       = aws_security_group.nomad_server.id
  description = "Group for nomad server members"
}
