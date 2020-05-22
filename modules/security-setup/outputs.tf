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

output "nomad_vault_token_name" {
  value = aws_secretsmanager_secret.nomad_vault_token.name
}
