# create a variable
variable "Environment" {
    default     = "dev"
    type = string
  
}
variable "region" {
    default     = "us-east-2"
    type = string
  
}
variable "instance_count" {
    description = "Number of EC2 instances to create"
    type = number
  
}

variable "monitoring_enabled" {
    description = "Enable detailed monitoring for EC2 instances"
    type = bool
    default = true
  
}
variable "associate_public_ip" {
    description = "Associate a public IP address with EC2 instances"
    type = bool
    default = true
  
}

variable "cidr_block" {
    description = "CIDR block for the VPC"
    type = list(string)
    default = ["10.0.0.0/8", "192.168.0.0.0/16","172.16.0.0/12"]
  
}

variable "allowed_vm_types" {
    description = "List of allowed VM instance types"
    type = list(string)
    default = ["t2.micro", "t2.small", "t2.medium"]
  
}

variable "allowed_region" {
    description = "List of allowed AWS regions"
    type = set(string)
    default = ["us-east-1", "us-east-2", "us-west-1", "us-west-2","us-east-1"]
  
}

variable "tags" {
    type = map(string)
    default = {
        Environment = "dev"
        Name        = "dev-instance"
        created_by  = "terraform"
        compliance  = "yes"
    }
}

variable "ingress_values" {
    description = "List of ingress CIDR blocks"
    type = tuple([number, string, number])
    default = [443, "tcp", 443]
  
}
variable "config" {
    type = object({
      region = string,
      monitoring = bool,
      instance_count = number
    })
    default = {
      region = "us-east-2",
      monitoring = true,
      instance_count = 1
    }
  
}

variable "bucket_name" {
    description = "Name of the S3 bucket"
    type = list(string)
    default = ["my-tf-ram-test-bucket-day08-123456", "my-tf-ram-test-bucket-day08-654321"]
  
}

variable "bucket_name_set" {
    description = "Name of the S3 bucket"
    type = set(string)
    default = ["my-tf-ram-test-bucket-day08-123457", "my-tf-ram-test-bucket-day08-654320"]
  
}

variable "ingress_rule" {
    description = "Ingress rules for security group"
    type = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
      description = string
    }))
    default = [
      {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow HTTP"
      },
      {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow HTTPS"
      }
    ]
}