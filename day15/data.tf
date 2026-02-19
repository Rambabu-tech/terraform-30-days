# Data Sources for VPC Peering Demo

# Data source to get available AZs in Primary region
data "aws_availability_zones" "Primary" {
  provider = aws.Primary
  state    = "available"
}

# Data source to get available AZs in Secondary region
data "aws_availability_zones" "Secondary" {
  provider = aws.Secondary
  state    = "available"
}

# Data source for Primary region AMI (Ubuntu 24.04 LTS)
data "aws_ami" "Primary_ami" {
  provider    = aws.Primary
  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# Data source for Secondary region AMI (Ubuntu 24.04 LTS)
data "aws_ami" "Secondary_ami" {
  provider    = aws.Secondary
  most_recent = true
  owners      = ["099720109477"] # Canonical (Ubuntu)

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}