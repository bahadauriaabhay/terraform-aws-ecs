resource "aws_ecs_cluster" "mycluster" {
  count = var.enable_ecs_cluster ? 1 : 0
  name  = var.ecs_clustername
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}
data "aws_ecs_cluster" "my-ecs-cluster" {
  count        = var.enable_ecs_cluster ? 0 : 1
  cluster_name = var.ecs_clustername
}
resource "aws_ecs_cluster_capacity_providers" "ecs_capacity_providers" {
  cluster_name = var.enable_ecs_cluster ? aws_ecs_cluster.mycluster[0].id : data.aws_ecs_cluster.my-ecs-cluster[0].id #aws_ecs_cluster.mycluster[0].name
  capacity_providers = compact([
    try(aws_ecs_capacity_provider.ecs_capacity_provider[0].name, ""),
    "FARGATE",
    "FARGATE_SPOT"
  ])
}
resource "aws_ecs_capacity_provider" "ecs_capacity_provider" {
  name  = "provider-${var.name}"
  count = var.fargate_only ? 0 : 1
  auto_scaling_group_provider {
    auto_scaling_group_arn = aws_autoscaling_group.asg[count.index].arn #var.asg_arn
  }
}

resource "aws_autoscaling_group" "asg" {
  count                     = var.fargate_only ? 0 : 1
  name                      = var.name
  max_size                  = var.asg_max
  min_size                  = var.asg_min
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = var.health_check_type
  desired_capacity          = var.desired_capacity
  force_delete              = var.force_delete
  launch_configuration      = aws_launch_configuration.as_conf[count.index].name
  vpc_zone_identifier       = var.vpc_zone_id
}


resource "aws_launch_configuration" "as_conf" {
  count         = var.fargate_only ? 0 : 1
  image_id      = var.image_id
  instance_type = var.instance_types
  #  associate_public_ip_address = true
  security_groups      = var.enable_asg_sg ? [aws_security_group.aws_sg[count.index].id] : var.asg_sg
  user_data            = <<EOF
#!/bin/bash
echo ECS_CLUSTER=${var.ecs_clustername} >> /etc/ecs/ecs.config;echo ECS_BACKEND_HOST= >> /etc/ecs/ecs.config;
cd /tmp
sudo yum install -y https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent
EOF
  iam_instance_profile = aws_iam_instance_profile.ecs-instance-profile.name
  lifecycle {
    create_before_destroy = true
  }
}
#output "asg_arn" {
#  value = aws_autoscaling_group.asg.arn
#}

resource "aws_iam_role" "ecs-instance-role" {
  name               = "ecs-instance-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ecs-instance-policy.json
}

data "aws_iam_policy_document" "ecs-instance-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs-instance-role-attachment" {
  role       = aws_iam_role.ecs-instance-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "ecs_ssm" {
  role       = aws_iam_role.ecs-instance-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_instance_profile" "ecs-instance-profile" {
  name = "ecs-instance-profile"
  path = "/"
  role = aws_iam_role.ecs-instance-role.name
}

