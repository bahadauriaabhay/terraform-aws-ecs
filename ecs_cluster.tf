resource "aws_ecs_cluster" "mycluster" {
  count = var.enable_ecs_cluster ? 1 : 0  
  name = var.ecs_clustername
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}
resource "aws_autoscaling_group" "asg" {
  name                      = var.name
  max_size                  = var.asg_max
  min_size                  = var.asg_min
  health_check_grace_period = var.health_check_grace_period
  health_check_type         = var.health_check_type
  desired_capacity          = var.desired_capacity
  force_delete              = var.force_delete
  launch_configuration      = aws_launch_configuration.as_conf.name
  vpc_zone_identifier       = var.vpc_zone_id
}

resource "aws_security_group" "aws_sg" {
  name        = "aws_sg-${var.name}"
  description = "Allow TLS inbound traffic"
  vpc_id      = var.sg_vpc_id

  ingress {
    description      = "TLS from VPC"
    from_port        = var.from_port
    to_port          = var.to_port
    protocol         = "tcp"
    cidr_blocks      = var.vpc_cidr
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}
resource "aws_launch_configuration" "as_conf" {
  image_id      = var.image_id
  instance_type = "${var.instance_types}"
#  associate_public_ip_address = true
  security_groups = [aws_autoscaling_group.asg.id]
  user_data = <<EOF
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
output "asg_arn" {
  value = aws_autoscaling_group.asg.arn
}

resource "aws_iam_role" "ecs-instance-role" {
    name                = "ecs-instance-role"
    path                = "/"
    assume_role_policy  = data.aws_iam_policy_document.ecs-instance-policy.json
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

