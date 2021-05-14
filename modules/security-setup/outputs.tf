output "vault_key_id" {
  value       = aws_kms_key.vault_key.id
  description = "ID of the Vault KMS key"
}

output "secretmanager_names" {
  value       = { for key, value in aws_secretsmanager_secret.hashistack_minimal : key => value.name }
  description = "AWS-SM secret names for key resinstack secrets"
}

output "machine_role" {
  value       = { for name, role in aws_iam_role.resinstack_machine_role : name => role.name }
  description = "Map of name to role name for machine roles"
}

output "machine_profile" {
  value       = { for name, profile in aws_iam_instance_profile.machine_profile : name => profile.name }
  description = "Map of name to role ARN for machine profiles"
}
