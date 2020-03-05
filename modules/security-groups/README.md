# Security Groups

This module provides a reference set of security groups that you can
use with the HashiStack.  These groups are kept in step with the
access required as documented by the published HashiCorp documentation
for each component of the stack.

WAN traffic rules are not provided by this module.  The recommended
approach to this is to attach additional rules to the IDs managed by
this group, and provide the allowances for traffic in your WAN region.
