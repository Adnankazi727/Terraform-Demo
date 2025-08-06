resource "aws_instance" "my_instance" {
    ami = var.image_id
    instance_type = var.instance_type
    vpc_security_group_ids = [aws_security_group.my_sg.id]
    subnet_id = var.subnet_id
    key_name = var.key_pair
    tags = {
        Name = "${var.project}-instance"
    }
}

resource "aws_security_group" "my_sg" {
    vpc_id = var.vpc_id
    tags = {
        Name = "${var.project}-sg"
    }
    description = "enable 80 and 22"
    ingress {
        to_port = 80
        from_port = 80
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        to_port = 80
        from_port = 80
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        to_port = 0
        from_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}