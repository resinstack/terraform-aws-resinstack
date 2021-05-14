module "resin_control_metadata" {
  source  = "resinstack/metadata/local"
  version = "0.2.0"

  base_path   = "${path.module}/metadata/control"
  cluster_tag = "resinstack-demo-${random_pet.cluster_tag.id}"

  secret_provider = "awssm"

  consul_server     = true
  consul_retry_join = ["provider=aws tag_key=resinstack:consul:autojoin tag_value=resinstack-demo-${random_pet.cluster_tag.id}"]
  consul_datacenter = upper(random_pet.cluster_tag.id)

  vault_server = true
  vault_key_id = module.resinstack_security_setup.vault_key_id

  nomad_server     = true
  nomad_datacenter = "${upper(random_pet.cluster_tag.id)}-CONTROL"
}

data "linuxkit_metadata" "control" {
  base_path = "${path.module}/metadata/control"
}

module "resin_control" {
  source = "../../modules/machine-pool"

  ami = var.ami_id

  key_name = aws_key_pair.default.key_name

  machine_size      = "t3a.medium"
  machine_count_min = 3
  machine_count_max = 6

  pool_name = "resinstack-demo-${random_pet.cluster_tag.id}-control"

  block_devices = {
    "/dev/xvda" = 8
    "/dev/xvdb" = 50
  }

  instance_profile = module.resinstack_security_setup.machine_profile["aio-server"]
  security_groups = [
    aws_security_group.base.id,
    module.resinstack_security_groups.consul_gossip_id,
    module.resinstack_security_groups.consul_server_id,
    module.resinstack_security_groups.nomad_server_id,
    module.resinstack_security_groups.vault_server_id,
  ]

  associate_public_address = true
  vpc_subnets              = [aws_subnet.main.id, aws_subnet.secondary.id]

  lb_target_groups = [
    aws_lb_target_group.lb_nomad.id,
    aws_lb_target_group.lb_vault.id,
    aws_lb_target_group.lb_consul.id,
  ]

  user_data = base64encode(data.linuxkit_metadata.control.json)

  cluster_tag = "resinstack-demo-${random_pet.cluster_tag.id}"
}
