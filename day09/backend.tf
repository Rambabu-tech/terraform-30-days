terraform {
    backend "s3" {
    bucket = "my-tf-ram-test-bucket"
    key    = "dev/terraform.tfstate"
    region = "us-east-2"
    encrypt = true
    use_lockfile = true
  }
}
