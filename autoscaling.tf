# LoadBalancer AutoScaling

provider "aws" {
    region = "ap-south-1"
}

resource "aws_launch_template" "launch_template_home" {
    name = "launch-template-OG"
    image_id = var.image_id
    instance_type = var.instance_type
    user_data = <<EOT 
    #!/bin/bash
    apt update -y
    apt install apache2 -y
    systemctl start apache2
    echo "<h1> Hello World <h2> Welcome to Cloudblitz" > /var/www/html/index.html
    EOT

    key_name = var.key_pair
    vpc_security_group_ids = var.security_group_ids
    tags = {
        env = var.env
    }
}


resource "aws_launch_template" "launch_template_cloth" {
    name = "launch-template-cloth"
    image_id = var.image_id
    instance_type = var.instance_type
    user_data = <<EOT 
    #!/bin/bash
    apt update -y
    apt install apache2 -y
    systemctl start apache2
    mkdir /avr/www/html/cloth
    echo "<h1> This is Cloth Section" > /var/www/html/cloth/index.html
    EOT

    key_name = var.key_pair
    vpc_security_group_ids = var.security_group_ids
    tags = {
        env = var.env
    }
}


resource "aws_launch_template" "launch_template_laptop" {
    name = "launch-template-laptop"
    image_id = var.image_id
    instance_type = var.instance_type
    user_data = <<EOT 
    #!/bin/bash
    apt update -y
    apt install apache2 -y
    systemctl start apache2
    mkdir /avr/www/html/laptop
    echo "<h1> SALE SALE SALE SALE ON LAPTOP" > /var/www/html/laptop/index.html
    EOT

    key_name = var.key_pair
    vpc_security_group_ids = var.security_group_ids
    tags = {
        env = var.env
    }
}

resource "aws_autoscaling_group" "asg-home" {
    name = "asg-home"
    min_size = var.min_size
    max_size = var.max_size
    desired_capacity = var.desired_capacity
    availability_zones = var.availability_zones
    launch_template {
        id = aws_launch_template.launch_template_home.id
    }
    tag {
        env = var.env
    }
    target_group_arns = {aws_lb_target_group.tg_home.arn}
}


resource "aws_autoscaling_policy" "asp-home" {
    name = "asp-home"
    autoscaling_group_name = aws_autoscaling_group.asg_home.name
    policy_type = "TargetTrackingScaling"
   target_tracking_configuration {
    predefined_metric_type {
        predefined_metric_type = "CPUUtilization"
    }
  }
  target_value = 50
}

 resource "aws_autoscaling_group" "asg-laptop" {
    name = "asg-laptop"
    min_size = var.min_size
    max_size = var.max_size
    desired_capacity = var.desired_capacity
    availability_zones = var.availability_zones
    launch_template {
        id = aws_launch_template.launch_template_laptop.id
    }
    tag {
        env = var.env
    }
    target_group_arns = {aws_lb_target_group.tg_laptop.arn}
}


resource "aws_autoscaling_policy" "asp-laptop" {
    name = "asp-laptop"
    autoscaling_group_name = aws_autoscaling_group.asg_laptop.name
    policy_type = "TargetTrackingScaling"
   target_tracking_configuration {
    predefined_metric_type {
        predefined_metric_type = "ASGAverageCPUUtilization"
    }
  }
  target_value = 50
}

 resource "aws_autoscaling_group" "asg-cloth" {
    name = "asg-cloth"
    min_size = var.min_size
    max_size = var.max_size
    desired_capacity = var.desired_capacity
    availability_zones = var.availability_zones
    launch_template {
        id = aws_launch_template.launch_template_cloth.id
    }
    tag {
        env = var.env
    }
    target_group_arns = {aws_lb_target_group.tg.cloth.arn}
}


resource "aws_autoscaling_policy" "asp-cloth" {
    name = "asp-cloth"
    autoscaling_group_name = aws_autoscaling_group.asg_cloth.name
    policy_type = "TargetTrackingScaling"
   target_tracking_configuration {
    predefined_metric_type {
        predefined_metric_type = "ASGAverageCPUUtilization"
    }
  }
  target_value = 50
}
    
