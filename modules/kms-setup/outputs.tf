output "key_id" {
  value       = aws_kms_key.key.key_id
  description = "ID of the key for vault to use."
}

output "policy_arn" {
  value       = aws_iam_policy.vault_kms_unseal.arn
  description = "ARN of the KMS unseal policy."
}

output "profile_name" {
  value       = aws_iam_instance_profile.vault_kms_unseal.name
  description = "Name of the created instance profile."
}
