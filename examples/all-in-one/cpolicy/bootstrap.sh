#!/bin/sh

mkdir -p state secrets

. ./vars.sh

if [ ! -f state/consul_done ] ; then
    if [ ! -f secrets/resinstack-consul-gossip-key ] ; then
        consul keygen > secrets/resinstack-consul-gossip-key
        aws secretsmanager put-secret-value --secret-id $SM_CONSUL_GOSSIP_KEY --secret-string "$(cat secrets/resinstack-consul-gossip-key)"
    fi

    if [ ! -f state/consul_bootstrap.json ] ; then
        while ! consul acl bootstrap -format=json > state/consul_bootstrap.json 2>/dev/null ; do
            sleep 5
        done
    fi

    export CONSUL_HTTP_TOKEN=$(jq -r .SecretID < state/consul_bootstrap.json)
    while ! terraform apply -target=module.consul_base -auto-approve ; do
        sleep 5
    done

    consul acl token create -role-name consul-agent -format=json > state/consul_agent.json
    consul acl token create -role-name vault-server -format=json > state/consul_vault.json
    consul acl token create -role-name nomad-server -format=json > state/consul_nomad_server.json
    consul acl token create -role-name nomad-client -format=json > state/consul_nomad_client.json

    consul acl token create -policy-name global-management -format=json > state/consul_vault_integration.json

    aws secretsmanager put-secret-value --secret-id $SM_CONSUL_AGENT_TOKEN --secret-string "$(jq -r .SecretID < state/consul_agent.json)"
    aws secretsmanager put-secret-value --secret-id $SM_VAULT_CONSUL_TOKEN --secret-string "$(jq -r .SecretID < state/consul_vault.json)"
    aws secretsmanager put-secret-value --secret-id $SM_NOMAD_SERVER_CONSUL_TOKEN --secret-string "$(jq -r .SecretID < state/consul_nomad_server.json)"
    aws secretsmanager put-secret-value --secret-id $SM_NOMAD_CLIENT_CONSUL_TOKEN --secret-string "$(jq -r .SecretID < state/consul_nomad_client.json)"

    touch state/consul_done
fi

if [ ! -f state/vault_done ] ; then
    if [ ! -f state/vault_bootstrap.json ] ; then
        while ! vault operator init -format=json -n 1 -t 1 > state/vault_bootstrap.json ; do
            sleep 5
        done
    fi

    export VAULT_TOKEN=$(jq -r .root_token < state/vault_bootstrap.json)
    while ! terraform apply -target=module.vault_base -auto-approve ; do
        sleep 5
    done

    vault write consul/config/access \
          address=consul.service.consul:8500 \
          token=$(jq -r .SecretID < state/consul_vault_integration.json)

    vault token create -policy resin-nomad-server \
          -period 72h -orphan \
          -format json > state/vault_nomad_token.json

    jq -r .auth.client_token < state/vault_nomad_token.json > secrets/resinstack-nomad-vault-token
    aws secretsmanager put-secret-value --secret-id $SM_NOMAD_SERVER_VAULT_TOKEN --secret-string "$(cat secrets/resinstack-nomad-vault-token)"

    touch state/vault_done
fi


if [ ! -f state/nomad_done ] ; then
    if [ ! -f secrets/resinstack-nomad-gossip-key ] ; then
        nomad operator keygen > secrets/resinstack-nomad-gossip-key
        aws secretsmanager put-secret-value --secret-id $SM_NOMAD_GOSSIP_KEY --secret-string "$(cat secrets/resinstack-nomad-gossip-key)"
    fi

    while ! curl --fail-with-body -o state/nomad_bootstrap.json -X POST $NOMAD_ADDR/v1/acl/bootstrap ; do
        sleep 5
    done
    export NOMAD_TOKEN=$(jq -r .SecretID < state/nomad_bootstrap.json)

    curl -o state/nomad_vault_auth.json \
         -X POST -d '{"Name": "Vault Integration", "Type": "management"}' \
         -H "X-Nomad-Token: $NOMAD_TOKEN" \
         $NOMAD_ADDR/v1/acl/token

    vault write nomad/config/access \
          address=http://nomad.service.consul:4646 \
          token=$(jq -r .SecretID < state/nomad_vault_auth.json)

    while ! terraform apply -target=module.nomad_base -auto-approve ; do
        sleep 5
    done

    touch state/nomad_done
fi
