resource "aws_instance" "step_ca" {
  ami = "ami-0385130759ef3917a"

  instance_type = "t3a.small"

  associate_public_ip_address = true

  subnet_id = aws_subnet.main.id

  vpc_security_group_ids = [
    aws_security_group.base.id,
  ]
}
