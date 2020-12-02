output "vault_key_id" {
  value       = aws_kms_key.vault_key.id
  description = "ID of the Vault KMS key"
}

output "aio_instance_profile" {
  value = aws_iam_instance_profile.aio_server_profile.name
}

output "client_instance_profile" {
  value = aws_iam_instance_profile.client_profile.name
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

output "aio_server_role_name" {
  value       = aws_iam_role.resinstack_aio_server.name
  description = "Name of the AIO Server role"
}

output "client_role_name" {
  value       = aws_iam_role.resinstack_client.name
  description = "Name of the Client role"
}
