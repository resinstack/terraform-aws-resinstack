resource "aws_secretsmanager_secret" "consul_gossip_key" {
  name = "resinstack-consul-gossip-key-${var.cluster_tag}"

  tags = {
    "resinstack:cluster" = var.cluster_tag
  }
}

resource "aws_secretsmanager_secret" "consul_agent_token" {
  name = "resinstack-consul-agent-token-${var.cluster_tag}"

  tags = {
    "resinstack:cluster" = var.cluster_tag
  }
}

resource "aws_secretsmanager_secret" "nomad_gossip_key" {
  name = "resinstack-nomad-gossip-key-${var.cluster_tag}"

  tags = {
    "resinstack:cluster" = var.cluster_tag
  }
}

resource "aws_secretsmanager_secret" "nomad_server_consul_token" {
  name = "resinstack-nomad-server-consul-token-${var.cluster_tag}"

  tags = {
    "resinstack:cluster" = var.cluster_tag
  }
}

resource "aws_secretsmanager_secret" "nomad_client_consul_token" {
  name = "resinstack-nomad-client-consul-token-${var.cluster_tag}"

  tags = {
    "resinstack:cluster" = var.cluster_tag
  }
}

resource "aws_secretsmanager_secret" "vault_consul_token" {
  name = "resinstack-vault-consul-token-${var.cluster_tag}"

  tags = {
    "resinstack:cluster" = var.cluster_tag
  }
}

resource "aws_secretsmanager_secret" "nomad_vault_token" {
  name = "resinstack-nomad-vault-token-${var.cluster_tag}"

  tags = {
    "resinstack:cluster" = var.cluster_tag
  }
}

data "aws_iam_policy_document" "client_keys" {
  statement {
    actions = ["secretsmanager:GetSecretValue"]
    effect  = "Allow"
    resources = [
      aws_secretsmanager_secret.consul_agent_token.arn,
      aws_secretsmanager_secret.consul_gossip_key.arn,
      aws_secretsmanager_secret.nomad_client_consul_token.arn,
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
      aws_secretsmanager_secret.consul_agent_token.arn,
      aws_secretsmanager_secret.consul_gossip_key.arn,
      aws_secretsmanager_secret.nomad_gossip_key.arn,
      aws_secretsmanager_secret.nomad_server_consul_token.arn,
      aws_secretsmanager_secret.nomad_vault_token.arn,
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
      aws_secretsmanager_secret.consul_gossip_key.arn,
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
      aws_secretsmanager_secret.consul_gossip_key.arn,
      aws_secretsmanager_secret.vault_consul_token.arn,
    ]
  }
}

resource "aws_iam_policy" "vault_server_key_access" {
  name        = "ResinStackVaultServerKeyAccess-${var.cluster_tag}"
  description = "Allow access to secret keys related to Vault servers"

  policy = data.aws_iam_policy_document.vault_server_keys.json
}
