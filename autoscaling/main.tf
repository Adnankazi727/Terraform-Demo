provider "aws" {
    region = "us-east-2"
}

resource "aws_instance" "my-instance" {
    ami = var.image_id
    instance_type = var.instance_type
    vpc_security_group_ids = [aws_security_group.my_security_group.id]
    #  vpc_security_group_ids = [<RESOURCETYPE>.<RESOURCENAME>.<ATTRIBUTE>]
    tags = {
            env = "dev"
        }
}

    resource "aws_security_group" "my_security_group" {
        region = var.region
        description = "new sg"
        name = "new-security-group"
        ingress {
            protocol = "tcp"
            from_port = 80
            to_port = 80
            cidr_blocks = ["0.0.0.0/0"]
        }
        egress {
            protocol = "-1"
            from_port = 0
            to_port = 0
            cidr_blocks = ["0.0.0.0/0"]
        }
        tags = {
            env = "dev"
        }
        vpc_id = "vpc-06026ffa98c044cfe"
    }

    variable "image_id" {
      default     = "ami-08ca1d1e465fbfe0c"
    }

    variable "instance_type" {
        default = "t2.micro"
    }
    
    variable "region" {
        default = "us-east-2"
    }

    output "public_ip" {
      value  =  aws_instance.my_instance.public_ip
    }
    
    output  "demo" {
        value = "My Name is Adnan"
    }