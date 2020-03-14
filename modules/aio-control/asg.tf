resource "aws_launch_template" "controller" {
  name = "aio-controller"

  block_device_mappings {
    device_name = "/dev/xvda"
    ebs {
      volume_size = 2
      encrypted   = true
    }
  }

  block_device_mappings {
    device_name = "/dev/xvdb"
    ebs {
      volume_size = 32
      encrypted   = true
    }
  }

  vpc_security_group_ids = var.security_groups

  image_id = var.ami
  key_name = var.key_name

  instance_initiated_shutdown_behavior = "terminate"

  instance_type = var.machine_size

  user_data = var.user_data

  iam_instance_profile {
    name = var.instance_profile
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      "resinstack:consul:autojoin" = "true"
    }
  }
}

resource "aws_placement_group" "controller" {
  name = "aio-controller"

  # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/placement-groups.html
  strategy = "partition"
}

resource "aws_autoscaling_group" "controller" {
  name     = "aio-controller"
  min_size = var.machine_count
  max_size = var.machine_count

  placement_group = aws_placement_group.controller.id
  target_group_arns = [
    var.control_alb_nomad,
    var.control_alb_consul,
    var.control_alb_vault,
  ]

  vpc_zone_identifier = var.vpc_subnets

  launch_template {
    id      = aws_launch_template.controller.id
    version = "$Latest"
  }
}
