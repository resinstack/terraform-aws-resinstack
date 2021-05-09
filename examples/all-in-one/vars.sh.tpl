#!/bin/sh

export SM_CONSUL_AGENT_TOKEN="${sm-consul-agent-token}"
export SM_CONSUL_GOSSIP_KEY="${sm-consul-gossip-key}"
export SM_NOMAD_GOSSIP_KEY="${sm-nomad-gossip-key}"
export SM_NOMAD_SERVER_CONSUL_TOKEN="${sm-nomad-server-consul-token}"
export SM_NOMAD_SERVER_VAULT_TOKEN="${sm-nomad-server-vault-token}"
export SM_NOMAD_CLIENT_CONSUL_TOKEN="${sm-nomad-client-consul-token}"
export SM_VAULT_CONSUL_TOKEN="${sm-vault-consul-token}"

export NOMAD_ADDR=http://${alb_addr}:4646
export VAULT_ADDR=http://${alb_addr}:8200
export CONSUL_HTTP_ADDR=http://${alb_addr}:8500
