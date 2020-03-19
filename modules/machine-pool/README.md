# Machine Pool

This module is the core of the resinstack on AWS.  A machine pool
represents a group of machines that will all be maintained as a unit.
Depending on the configuration, a machine pool may take on the
function of a control plane, a worker group, or many other use cases.

It is common in a resinstack deployment to have at least 2 machine
pools, one as a control plane and one as a general machine pool.
Typically, you should expect to have many machine pools based on what
your cluster is doing.
