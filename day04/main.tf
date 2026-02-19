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
# create s3 bucket
resource "aws_s3_bucket" "my_bucket_rambabu" {
  bucket = "my-tf-ram-test-bucket-1234"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}