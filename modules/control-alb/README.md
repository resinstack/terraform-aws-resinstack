# control-alb

During bootstrapping it is necessary to have some way to access the
cluster control plane that is not the self hosted proxy.  This module
sets up an Application Load Balancer which can be used to directly
access Consul, Nomad, and Vault.
