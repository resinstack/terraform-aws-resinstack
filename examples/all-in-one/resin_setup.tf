module "resinstack_security_setup" {
  source = "../../modules/security-setup"

  machine_roles = {
    aio-server = ["read-tags", "nomad-keys", "consul-keys", "vault-keys", "vault-kms"]
  }

  cluster_tag         = "resinstack-demo-${random_pet.cluster_tag.id}"
  enable_key_rotation = true
}

module "resinstack_security_groups" {
  source = "../../modules/security-groups"

  vpc_id = aws_vpc.vpc.id

  cluster_tag = "resinstack-demo-${random_pet.cluster_tag.id}"

  nomad_api_client_sgs  = [aws_security_group.lb.id]
  vault_api_client_sgs  = [aws_security_group.lb.id]
  consul_api_client_sgs = [aws_security_group.lb.id]
}
