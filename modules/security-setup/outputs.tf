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
