resource "aws_kms_key" "vault_key" {
  description         = "resinstack:vault:seal:${var.cluster_tag}"
  enable_key_rotation = var.enable_key_rotation

  tags = {
    "resinstack:cluster" = var.cluster_tag
  }
}

data "aws_iam_policy_document" "vault_kms_unseal" {
  statement {
    sid       = "VaultKMSUnseal"
    effect    = "Allow"
    resources = [aws_kms_key.vault_key.arn]

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:DescribeKey",
    ]
  }
}

resource "aws_iam_policy" "vault_kms_unseal" {
  name        = "ResinStackKMSUnseal-${var.cluster_tag}"
  description = "Allow unsealing a vault with a KMS key"

  policy = data.aws_iam_policy_document.vault_kms_unseal.json
}
