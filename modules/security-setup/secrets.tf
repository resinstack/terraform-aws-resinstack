resource "aws_secretsmanager_secret" "hashistack_minimal" {
  for_each = toset([
    "consul-agent-token",
    "consul-gossip-key",
    "nomad-client-consul-token",
    "nomad-gossip-key",
    "nomad-server-consul-token",
    "nomad-vault-token",
    "vault-consul-token",
  ])

  name = "resinstack-${each.value}-${var.cluster_tag}"

  tags = {
    "resinstack:cluster" = var.cluster_tag
  }

}

data "aws_iam_policy_document" "client_keys" {
  statement {
    actions = ["secretsmanager:GetSecretValue"]
    effect  = "Allow"
    resources = [
      aws_secretsmanager_secret.hashistack_minimal["consul-agent-token"].arn,
      aws_secretsmanager_secret.hashistack_minimal["consul-gossip-key"].arn,
      aws_secretsmanager_secret.hashistack_minimal["nomad-client-consul-token"].arn,
    ]
  }
}

resource "aws_iam_policy" "client_key_access" {
  name        = "ResinStackClientKeyAccess-${var.cluster_tag}"
  description = "Allow access to secret keys related to clients"

  policy = data.aws_iam_policy_document.client_keys.json
}

data "aws_iam_policy_document" "nomad_server_keys" {
  statement {
    actions = ["secretsmanager:GetSecretValue"]
    effect  = "Allow"
    resources = [
      aws_secretsmanager_secret.hashistack_minimal["consul-agent-token"].arn,
      aws_secretsmanager_secret.hashistack_minimal["consul-gossip-key"].arn,
      aws_secretsmanager_secret.hashistack_minimal["nomad-gossip-key"].arn,
      aws_secretsmanager_secret.hashistack_minimal["nomad-server-consul-token"].arn,
      aws_secretsmanager_secret.hashistack_minimal["nomad-vault-token"].arn,
    ]
  }
}

resource "aws_iam_policy" "nomad_server_key_access" {
  name        = "ResinStackNomadServerKeyAccess-${var.cluster_tag}"
  description = "Allow access to secret keys related to Nomad servers"

  policy = data.aws_iam_policy_document.nomad_server_keys.json
}

data "aws_iam_policy_document" "consul_server_keys" {
  statement {
    actions = ["secretsmanager:GetSecretValue"]
    effect  = "Allow"
    resources = [
      aws_secretsmanager_secret.hashistack_minimal["consul-gossip-key"].arn,
    ]
  }
}

resource "aws_iam_policy" "consul_server_key_access" {
  name        = "ResinStackConsulServerKeyAccess-${var.cluster_tag}"
  description = "Allow access to secret keys related to Consul servers"

  policy = data.aws_iam_policy_document.consul_server_keys.json
}

data "aws_iam_policy_document" "vault_server_keys" {
  statement {
    actions = ["secretsmanager:GetSecretValue"]
    effect  = "Allow"
    resources = [
      aws_secretsmanager_secret.hashistack_minimal["consul-gossip-key"].arn,
      aws_secretsmanager_secret.hashistack_minimal["vault-consul-token"].arn,
    ]
  }
}

resource "aws_iam_policy" "vault_server_key_access" {
  name        = "ResinStackVaultServerKeyAccess-${var.cluster_tag}"
  description = "Allow access to secret keys related to Vault servers"

  policy = data.aws_iam_policy_document.vault_server_keys.json
}
