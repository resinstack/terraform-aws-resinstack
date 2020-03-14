resource "aws_kms_key" "key" {
  description         = "Vault Seal Wrapping Key"
  enable_key_rotation = var.enable_key_rotation
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "vault_kms_unseal" {
  statement {
    sid       = "VaultKMSUnseal"
    effect    = "Allow"
    resources = [aws_kms_key.key.arn]

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:DescribeKey",
    ]
  }
}

resource "aws_iam_policy" "vault_kms_unseal" {
  name        = "ResinStackKMSUnseal"
  description = "Allow unsealing a vault with a KMS key"

  policy = data.aws_iam_policy_document.vault_kms_unseal.json
}

resource "aws_iam_role" "vault_kms_unseal" {
  name               = "ResinStackKMSUnseal"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "additional_attachments" {
  for_each = toset(var.additional_policies)

  role       = aws_iam_role.vault_kms_unseal.name
  policy_arn = each.value
}

resource "aws_iam_role_policy_attachment" "vault_kms_unseal" {
  role       = aws_iam_role.vault_kms_unseal.name
  policy_arn = aws_iam_policy.vault_kms_unseal.arn
}

resource "aws_iam_instance_profile" "vault_kms_unseal" {
  name = "resinstack-vault-kms-unseal"
  role = aws_iam_role.vault_kms_unseal.name
}
