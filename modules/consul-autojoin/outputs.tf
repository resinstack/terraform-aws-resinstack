output "role_arn" {
  value       = aws_iam_role.consul_autojoin.arn
  description = "ARN of the role which can perform autojoin introspection."
}

output "profile_name" {
  value       = aws_iam_instance_profile.cloud_autojoin.name
  description = "Name of the created instance profile."
}
