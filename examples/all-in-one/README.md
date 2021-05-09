# All In One

This is the fastest possible way to take the ResinStack for a spin.
It will get you a control plane with no workers attached that you can
subsequently play with.  It is a balance between a fully secured best
practices cluster and a cluster that has enough items configured to
get a feel for the Hashistack.  ACLs are enabled in default-deny mode.

To deploy this stack, prepare a ResinStack image using the terraform
project in the image directory.  Upload this image using the AWS VM
Import process as you would any other custom AMI.  Note the AMI ID
that is assigned to the image.

Export a variable `TF_VAR_ami_id=<id from earlier>`, and run the up.sh
script.

Once the up script completes your cluster will be running but not
configured.  You can configure the cluster using the bootstrap script
in the cpolicy directory.


Standard disclaimers apply, this demo costs at least $1 to run since
it depends on a KMS key.  You're on your own for paying for your AWS
account, remember to stop your boxes, etc.
