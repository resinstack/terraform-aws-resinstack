output "vault_key_id" {
  value       = aws_kms_key.vault_key.id
  description = "ID of the Vault KMS key"
}

output "nomad_gossip_key_name" {
  value = aws_secretsmanager_secret.nomad_gossip_key.name
}

output "nomad_server_consul_token_name" {
  value = aws_secretsmanager_secret.nomad_server_consul_token.name
}

output "nomad_vault_token_name_name" {
  value = aws_secretsmanager_secret.nomad_vault_token.name
}

output "machine_role" {
  value       = { for name, role in aws_iam_role.resinstack_machine_role : name => role.name }
  description = "Map of name to role name for machine roles"
}

output "machine_profile" {
  value       = { for name, profile in aws_iam_instance_profile.machine_profile : name => profile.name }
  description = "Map of name to role ARN for machine profiles"
}
