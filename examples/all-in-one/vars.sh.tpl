#!/bin/sh

export NOMAD_ADDR=http://${alb_addr}:4646
export VAULT_ADDR=http://${alb_addr}:8200
export CONSUL_HTTP_ADDR=http://${alb_addr}:8500
