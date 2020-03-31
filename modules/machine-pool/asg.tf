resource "aws_launch_template" "pool" {
  name = var.pool_name

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

resource "aws_placement_group" "pool" {
  name = var.pool_name

  # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/placement-groups.html
  strategy = "partition"
}

resource "aws_autoscaling_group" "pool" {
  name     = var.pool_name
  min_size = var.machine_count_min
  max_size = var.machine_count_max

  desired_capacity     = var.machine_count_desired
  termination_policies = var.termination_policies

  placement_group     = aws_placement_group.pool.id
  target_group_arns   = var.lb_target_groups
  vpc_zone_identifier = var.vpc_subnets

  launch_template {
    id      = aws_launch_template.pool.id
    version = "$Latest"
  }
}
