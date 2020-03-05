# Consul Auto-Join

This module provisions an AWS account to support Consul's cloud
auto-join feature.  This allows your cluster to more seemlessly
recover from scaling events and from other changes that would require
cluster members to find each other.

The module will create a role in your AWS account and will apply a
policy that permits `ec2:DescribeInstances` on all resources.
Additionally, this role will be attached to an instance profile called
`resinstack-cloud-autojoin`.

It is only required to apply this module once per account, it can be
used by an arbitrary number of clusters.
