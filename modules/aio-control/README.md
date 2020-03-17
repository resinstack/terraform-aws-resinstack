# Control Plane - All In One

This module provisions an all-in-one control plane for the
HashiStack.  This configuration is explicitly not recommended by
HashiCorp, but is acceptable for small clusters, demonstration
environments, and environments that are idle more than 70% of the
time.

The control plane is a critical component of the stack, and as such it
is recommended to use at least 3 machines (the default) and no more
than 7.  The machines are configured in an Auto Scaling Group with no
automatic decision loaded.

