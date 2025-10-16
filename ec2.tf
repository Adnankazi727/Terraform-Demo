provider "aws" {
   region = "us-east-2"
   }

   resource "aws_instance" "my-instance" {
      ami = "ami-od0enoej"
      instance_type = "t2.micro"
      vpc_security_group_ids = ["sg- 028083874082048"]
      }
      
