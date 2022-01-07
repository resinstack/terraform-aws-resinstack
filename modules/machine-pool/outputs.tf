output "asg_arn" {
  description = "ARN of the underlying ASG"
  value       = aws_autoscaling_group.pool.arn
}

output "scale_policy_arn" {
  description = "ARN of the IAM scaling policy"
  value       = var.create_scaling_policy ? aws_iam_policy.scaling_policy[0].arn : ""
}
