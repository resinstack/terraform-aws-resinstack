data "aws_iam_policy_document" "autojoin_instance_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "consul_autojoin" {
  name               = "ResinStackConsulAutojoin"
  assume_role_policy = data.aws_iam_policy_document.autojoin_instance_role.json
}

data "aws_iam_policy_document" "cloud_autojoin" {
  statement {
    actions   = ["ec2:DescribeInstances"]
    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_policy" "cloud_autojoin" {
  name   = "ResinStackCloudAutoJoin"
  policy = data.aws_iam_policy_document.cloud_autojoin.json
}

resource "aws_iam_role_policy_attachment" "cloud_autojoin" {
  role       = aws_iam_role.consul_autojoin.name
  policy_arn = aws_iam_policy.cloud_autojoin.arn
}

resource "aws_iam_instance_profile" "cloud_autojoin" {
  name = "resinstack-cloud-autojoin"
  role = aws_iam_role.consul_autojoin.name
}
