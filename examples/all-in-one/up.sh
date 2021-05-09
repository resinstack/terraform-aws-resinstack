terraform apply -target aws_lb.lb -auto-approve                        # sets up the minimum VPC components
terraform apply -target module.resinstack_security_setup -auto-approve # sets up the KMS keys and secrets manager components
terraform apply -target module.resin_control_metadata -auto-approve    # sets up the metadata files in the local checkout
terraform apply -auto-approve                                          # everything else
