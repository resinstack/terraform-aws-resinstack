resource "random_pet" "cluster_tag" {}

resource "aws_key_pair" "default" {
  key_name   = "resinstack-demo-${random_pet.cluster_tag.id}"
  public_key = file(pathexpand("~/.ssh/id_rsa.pub"))
}
