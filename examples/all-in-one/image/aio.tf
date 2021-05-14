module "all_in_one" {
  source  = "resinstack/resinstack/linuxkit"
  version = "0.0.5"

  enable_sshd    = true
  enable_console = true

  enable_ntpd         = true
  system_ntpd_servers = "169.254.169.123"
  enable_emissary     = true

  consul_server      = true
  consul_acl         = "deny"
  consul_acl_enabled = true

  nomad_server            = true
  nomad_client            = true
  nomad_acl               = true
  nomad_vault_integration = true

  vault_server = true

  enable_docker = true

  build_aws                 = true
  build_aws_size            = 1200
  system_metadata_providers = ["aws"]
}
