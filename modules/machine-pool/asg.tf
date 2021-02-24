resource "aws_launch_template" "pool" {
  name = var.pool_name

  dynamic "block_device_mappings" {
    for_each = var.block_devices
    iterator = block
    content {
      device_name = block.key
      ebs {
        volume_size = block.value
        encrypted   = true
      }
    }
  }

  image_id = var.ami
  key_name = var.key_name

  instance_initiated_shutdown_behavior = "terminate"

  instance_type = var.machine_size

  user_data = var.user_data

  iam_instance_profile {
    name = var.instance_profile
  }

  network_interfaces {
    associate_public_ip_address = var.associate_public_address
    security_groups = var.security_groups
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      "resinstack:consul:autojoin" = var.cluster_tag
      "resinstack:cluster"         = var.cluster_tag
    }
  }
}

resource "aws_placement_group" "pool" {
  name = var.pool_name

  # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/placement-groups.html
  strategy = "partition"

  tags = {
    "resinstack:cluster" = var.cluster_tag
  }
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

  tags = flatten([
    [
      {
        key                 = "resinstack:cluster"
        value               = var.cluster_tag
        propagate_at_launch = true
      },
    ],
    [for key, value in var.instance_tags : { key = key, value = value, propagate_at_launch = true }],
  ])
}
