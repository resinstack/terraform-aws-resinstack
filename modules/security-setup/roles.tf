data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "resinstack_machine_role" {
  for_each = var.machine_roles

  name                 = "resinstack-${each.key}-${var.cluster_tag}"
  assume_role_policy   = data.aws_iam_policy_document.ec2_assume_role.json
  max_session_duration = 3600 * 12

  tags = {
    "resinstack:cluster" = var.cluster_tag
  }
}

resource "aws_iam_role_policy_attachment" "read_tags" {
  for_each = { for i, p in var.machine_roles : i => p if contains(p, "read-tags") }

  role       = aws_iam_role.resinstack_machine_role[each.key].name
  policy_arn = aws_iam_policy.read_tags.arn
}

resource "aws_iam_role_policy_attachment" "vault_kms_access" {
  for_each = { for i, p in var.machine_roles : i => p if contains(p, "vault-kms") }

  role       = aws_iam_role.resinstack_machine_role[each.key].name
  policy_arn = aws_iam_policy.vault_kms_unseal.arn
}

resource "aws_iam_role_policy_attachment" "nomad_key_access" {
  for_each = { for i, p in var.machine_roles : i => p if contains(p, "nomad-keys") }

  role       = aws_iam_role.resinstack_machine_role[each.key].name
  policy_arn = aws_iam_policy.nomad_server_key_access[0].arn
}

resource "aws_iam_role_policy_attachment" "consul_key_access" {
  for_each = { for i, p in var.machine_roles : i => p if contains(p, "consul-keys") }

  role       = aws_iam_role.resinstack_machine_role[each.key].name
  policy_arn = aws_iam_policy.consul_server_key_access[0].arn
}

resource "aws_iam_role_policy_attachment" "vault_key_access" {
  for_each = { for i, p in var.machine_roles : i => p if contains(p, "vault-keys") }

  role       = aws_iam_role.resinstack_machine_role[each.key].name
  policy_arn = aws_iam_policy.vault_server_key_access[0].arn
}

resource "aws_iam_role_policy_attachment" "client_key_access" {
  for_each = { for i, p in var.machine_roles : i => p if contains(p, "client-keys") }

  role       = aws_iam_role.resinstack_machine_role[each.key].name
  policy_arn = aws_iam_policy.client_key_access[0].arn
}

resource "aws_iam_instance_profile" "machine_profile" {
  for_each = var.machine_roles

  name = "resinstack-${each.key}-${var.cluster_tag}"
  role = aws_iam_role.resinstack_machine_role[each.key].name
}
