data "aws_iam_policy_document" "read_tags" {
  statement {
    actions   = ["ec2:DescribeInstances"]
    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_policy" "read_tags" {
  name   = "ResinStackReadTags"
  policy = data.aws_iam_policy_document.read_tags.json
}
