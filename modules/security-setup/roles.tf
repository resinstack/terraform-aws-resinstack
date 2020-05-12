###############
# Common Data #
###############
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

################
# Server Roles #
################
resource "aws_iam_role" "resinstack_aio_server" {
  name               = "resinstack-aio-server"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

resource "aws_iam_role_policy_attachment" "aio_read_tags" {
  role       = aws_iam_role.resinstack_aio_server.name
  policy_arn = aws_iam_policy.read_tags.arn
}

resource "aws_iam_role_policy_attachment" "aio_vault_kms_access" {
  role       = aws_iam_role.resinstack_aio_server.name
  policy_arn = aws_iam_policy.vault_kms_unseal.arn
}

resource "aws_iam_role_policy_attachment" "aio_nomad_key_access" {
  role       = aws_iam_role.resinstack_aio_server.name
  policy_arn = aws_iam_policy.nomad_server_key_access.arn
}

resource "aws_iam_role_policy_attachment" "aio_consul_key_access" {
  role       = aws_iam_role.resinstack_aio_server.name
  policy_arn = aws_iam_policy.consul_server_key_access.arn
}

resource "aws_iam_role_policy_attachment" "aio_vault_key_access" {
  role       = aws_iam_role.resinstack_aio_server.name
  policy_arn = aws_iam_policy.vault_server_key_access.arn
}

resource "aws_iam_instance_profile" "aio_server_profile" {
  name = "resinstack-aio-server"
  role = aws_iam_role.resinstack_aio_server.name
}


###############
# Client Role #
###############
resource "aws_iam_role" "resinstack_client" {
  name               = "resinstack-client"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

resource "aws_iam_role_policy_attachment" "client_read_tags" {
  role       = aws_iam_role.resinstack_client.name
  policy_arn = aws_iam_policy.read_tags.arn
}

resource "aws_iam_role_policy_attachment" "client_key_access" {
  role       = aws_iam_role.resinstack_client.name
  policy_arn = aws_iam_policy.client_key_access.arn
}

resource "aws_iam_instance_profile" "client_profile" {
  name = "resinstack-client"
  role = aws_iam_role.resinstack_client.name
}
