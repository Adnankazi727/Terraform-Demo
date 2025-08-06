# Modules

provider "aws" {
    region = "ap-south-1"
}

module "new_vpc" {
    source = "./modual/vpc"
    vpc_cidr = "172.16.0.0/16"
    pri_sub_cidr = "172.16.0.0/20"
    pub_sub_cidr = "172.16.16.0/20" 
}

module "instance" {
    source = "./modual/ec2" 
    image_id = "ami-0f918f7e67a3323f0"
    subnet_id = module.new_vpc.pub_subnet_id
    vpc_id = modual.new_vpc.vpc_id
    key_pair = "ubunto-1"
    project = "cbz"
}
