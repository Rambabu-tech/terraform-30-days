terraform {
    backend "s3" {
    bucket = "my-tf-ram-test-bucket"
    key    = "dev/terraform.tfstate"
    region = "us-east-2"
    encrypt = true
    use_lockfile = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
}
# create a variable
variable "Environment" {
    default     = "dev"
    type = string
  
}
variable "channel_name" {
    default     = "my-tf-ram-test"
    type = string
  
} 
variable "region" {
    default     = "us-east-2"
    type = string
  
}
# create local values
locals {
    bucket_name = "${var.channel_name}-bucket-${var.Environment}"
    vpc_name    = "${var.Environment}-vpc"
}
# create s3 bucket
resource "aws_s3_bucket" "my_bucket_rambabu" {
  bucket = local.bucket_name

  tags = {
    Name        = local.bucket_name
    Environment = var.Environment
  }
}

# Create a VPC
resource "aws_vpc" "sample" {
  cidr_block = "10.0.1.0/24"
    tags = {
        Environment = var.Environment
        Name = local.vpc_name
    }
}

# Create Ec2 Instance
resource "aws_instance" "sample" {
  ami           = "ami-06e3c045d79fd65d9" # Amazon Linux 2 AMI (HVM), SSD Volume Type in us-east-2
  instance_type = "t2.micro"
    tags = {
        Environment = var.Environment
        Name = "${var.Environment}-ec2-instance"
    }
}

# Output the S3 bucket name and VPC ID
output "s3_bucket_name" {
  value = aws_s3_bucket.my_bucket_rambabu.bucket
}   
output "vpc_id" {
  value = aws_vpc.sample.id
}   
output "ec2_instance_id" {
  value = aws_instance.sample.id
}