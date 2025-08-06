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
    mkdir /avr/www/html/home
    echo ["<h1> Hello World <h2> Welcome to Cloudblitz"] > /var/www/html/index.html
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
    echo ["<h1> This is Cloth Section"] > /var/www/html/cloth/index.html
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
    echo ["<h1> SALE SALE SALE SALE ON LAPTOP"] > /var/www/html/laptop/index.html
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
    
resource "aws_lb_target_group" "tg_home" {
    name = "tg_home"
    port = 80
    protocol_version = http 
    vpc_id = var.vpc_id
    tags = {
        env = var.env
    }
    health_check = {
        path = "/home"
    }
    }

    resource "aws_lb_target_group" "tg_laptop" {
    name = "tg_laptop"
    port = 80
    protocol_version = http 
    vpc_id = var.vpc_id
    tags = {
        env = var.env
    }
    health_check = {
        path = "/laptop"
    }
    }
    
    resource "aws_lb_target_group" "tg_cloth" {
    name = "tg_cloth"
    port = 80
    protocol_version = http 
    vpc_id = var.vpc_id
    tags = {
        env = var.env
    }
    health_check = {
        path = "/cloth"
    }
    }
    
    resource "aws_lb" "app_lb" {
  name               = "app_lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = var.subnets

  tags = {
    env = var.env
  }
}

resource "aws_security_group" "alb_sg" {
    name = "alb-sg"
    ingress {
        protocol = "TCP"
        to_port = 80
        from_port = 80
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        protocol = "TCP"
        to_port = 22
        from_port = 22
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        protocol = "-1"
        to_port = 80
        from_port = 80
        cidr_blocks = ["0.0.0.0/0"]
    }
    description = "enable 80 and 22 port"
}

resource "aws_lb_listener" "app_lb_listener" {
  load_balancer_arn = aws_lb.app_lb.arn
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_home.arn
    }
}

resource "aws_lb_listener_rule" "app_lb_listener_rule_cloth" {
  listener_arn = aws_lb_listener.app_lb_listener.arn
  priority     = 101

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_cloth.arn
  }

  condition {
   path_pattern = {
    values = ["/cloth/*"]
   }
  }
}

resource "aws_lb_listener_rule" "app_lb_listener_rule_laptop" {
  listener_arn = aws_lb_listener.app_lb_listener.arn
  priority     = 102

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_laptop.arn
  }

  condition {
   path_pattern {
    values = ["/laptop/*"]
   }
  }
}

resource "aws_lb_listener_rule" "app_lb_listener_rule_home" {
  listener_arn = aws_lb_listener.app_lb_listener.arn
  priority     = 103

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_home.arn
  }

  condition {
   path_pattern {
    values = ["/home/*"]
   }
  }
}

variable  "image_id" {
    default = "ami-0f918f7e67a3323f0"
}

variable  "instance_type" {
    default = "t2.micro"
}

variable  "security_group_ids" {
    default = ["sg-09ae786ff8b6ddb3a"]
}

variable  "key_pair" {
    default = ["ubunto-1"]
}

variable  "env" {
    default = "dev"
}

variable "min_size" {
    default = "2"
}


variable "max_size" {
    default = "5"
}

variable "desired_size" {
    default = "2"
}

variable "availability_zone" {
    default = ["ap-south-1a", "ap-south-1c", "ap-south-1b"]
}

variable "vpc_id" {
    default = "vpc-022fc35f010728330"
}

variable "subnets" {
    default = ["subnet-0399de2ec0186ed8e", "subnet-0e71ee4af80c13f22", "subnet-0499ed2658365709b"]
}
