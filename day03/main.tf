terraform {
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
# create s3 bucket
resource "aws_s3_bucket" "my_bucket_rambabu" {
  bucket = "my-tf-ram-test-bucket"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}