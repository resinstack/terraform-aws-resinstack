module "all_in_one" {
  source = "git::https://github.com/resinstack/terraform-linuxkit-resinstack?ref=step"

  enable_sshd    = true
  enable_console = true

  enable_ntpd         = true
  system_ntpd_servers = "169.254.169.123"
  enable_emissary     = false

  consul_server      = true
  consul_acl         = "deny"
  consul_acl_enabled = true

  nomad_server            = true
  nomad_client            = true
  nomad_acl               = true
  nomad_vault_integration = true

  vault_server        = true
  vault_agent         = true
  vault_agent_role    = "aio"
  vault_agent_address = "https://vault.resinstack.io:8200"

  enable_docker = true

  build_vmdk                = true
  system_metadata_providers = ["aws"]
}
