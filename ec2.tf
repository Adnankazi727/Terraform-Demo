
provider "aws" {
    region = "us-east-2"
}

resource "aws_instance" "my-instance" {
    ami = "ami-08ca1d1e465fbfe0c"
    instance_type = "t2.micro"
    vpc_security_group_ids = ["sg-035405d565570ee56"]
}

