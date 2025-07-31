
provider "aws" {
    region = "us-east-1"
}

resource "aws_instance" "my-instance" {
    ami = "ami-020cba7c55df1f615"
    instance_type = "t2.micro"
    vpc_security_group_ids = ["sg-0e541e5e9aa9d774a"]
}

