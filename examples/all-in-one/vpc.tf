data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "vpc" {
  cidr_block = "192.168.255.0/24"

  tags = {
    Name = "resinstack-demo-${random_pet.cluster_tag.id}"
  }
}

resource "aws_subnet" "main" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone_id    = data.aws_availability_zones.available.zone_ids[0]
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 1, 0)
  map_public_ip_on_launch = true

  tags = {
    Name = "resinstack-demo-${random_pet.cluster_tag.id}"
  }
}

resource "aws_subnet" "secondary" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone_id    = data.aws_availability_zones.available.zone_ids[1]
  cidr_block              = cidrsubnet(aws_vpc.vpc.cidr_block, 1, 1)
  map_public_ip_on_launch = true

  tags = {
    Name = "resinstack-demo-${random_pet.cluster_tag.id}"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "resinstack-demo-${random_pet.cluster_tag.id}"
  }
}

resource "aws_default_route_table" "tbl" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_security_group" "base" {
  vpc_id      = aws_vpc.vpc.id
  description = "Base group"
}

resource "aws_security_group_rule" "accept_ssh" {
  security_group_id = aws_security_group.base.id
  description       = "Accept SSH from the world"

  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "permit_http" {
  security_group_id = aws_security_group.base.id
  description       = "Permit HTTP to the world"

  type        = "egress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "permit_https" {
  security_group_id = aws_security_group.base.id
  description       = "Permit HTTPS to the world"

  type        = "egress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}
