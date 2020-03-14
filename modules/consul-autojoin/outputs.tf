output "policy_arn" {
  value       = aws_iam_policy.cloud_autojoin.arn
  description = "ARN of the policy permitting cloud autojoin"
}

output "profile_name" {
  value       = aws_iam_instance_profile.cloud_autojoin.name
  description = "Name of the created instance profile."
}
