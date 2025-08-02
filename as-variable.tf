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
