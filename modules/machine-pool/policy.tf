data "aws_iam_policy_document" "scaling_policy" {
  statement {
    sid    = "PerformAutoscaling"
    effect = "Allow"
    actions = [
      "autoscaling:CreateOrUpdateTags",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "autoscaling:UpdateAutoScalingGroup",
    ]
    resources = [aws_autoscaling_group.pool.arn]
  }
  statement {
    sid    = "InspectASGs"
    effect = "Allow"
    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeScalingActivities",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "scaling_policy" {
  count = var.create_scaling_policy ? 1 : 0

  name   = "ResinStackASG-${var.pool_name}"
  policy = data.aws_iam_policy_document.scaling_policy.json
}
