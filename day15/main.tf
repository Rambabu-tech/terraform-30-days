# Get availability zones for Primary region
data "aws_availability_zones" "primary" {
  provider = aws.Primary
  state    = "available"
}

# Get availability zones for Secondary region
data "aws_availability_zones" "secondary" {
  provider = aws.Secondary
  state    = "available"
}

resource "aws_vpc" "Primary_VPC" {
  cidr_block       = var.Primary_VPC_cidr
  provider = aws.Primary
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true  

  tags = {
    Name = "primary-vpc-${var.Primary}"
  }
}

resource "aws_vpc" "Secondary_VPC" {
  cidr_block       = var.Secondary_VPC_cidr
  provider = aws.Secondary
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true  

  tags = {
    Name = "secondary-vpc-${var.Secondary}"
  }
}
# Subnet in Primary VPC
resource "aws_subnet" "primary_subnet" {
  provider                = aws.Primary
  vpc_id                  = aws_vpc.Primary_VPC.id
  cidr_block              = var.Primary_VPC_cidr
  availability_zone       = data.aws_availability_zones.primary.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name        = "Primary-Subnet-${var.Primary}"
    Environment = "Demo"
  }
}

# Subnet in Secondary VPC
resource "aws_subnet" "secondary_subnet" {
  provider                = aws.Secondary
  vpc_id                  = aws_vpc.Secondary_VPC.id
  cidr_block              = var.Secondary_VPC_cidr
  availability_zone       = data.aws_availability_zones.secondary.names[0]
  map_public_ip_on_launch = true

  tags = {
    Name        = "Secondary-Subnet-${var.Secondary}"
    Environment = "Demo"
  }
}

resource "aws_internet_gateway" "Primary_IGW" {
  provider = aws.Primary
  vpc_id   = aws_vpc.Primary_VPC.id

  tags = {
    Name = "Primary-IGW-${var.Primary}"
  }
  
}

resource "aws_internet_gateway" "Secondary_IGW" {
  provider = aws.Secondary
  vpc_id   = aws_vpc.Secondary_VPC.id

  tags = {
    Name = "Secondary-IGW-${var.Secondary}"
  }
  
}

# Route Table for Primary VPC
resource "aws_route_table" "Primary_RT" {
  provider = aws.Primary
  vpc_id   = aws_vpc.Primary_VPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Primary_IGW.id
  }
  tags = {
    Name = "Primary-RT-${var.Primary}"
  }
}
# Route Table for Secondary VPC
resource "aws_route_table" "Secondary_RT" {
  provider = aws.Secondary
  vpc_id   = aws_vpc.Secondary_VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.Secondary_IGW.id
  }
  tags = {
    Name = "Secondary-RT-${var.Secondary}"
  }
}

# Associate Primary Subnet with Primary Route Table
resource "aws_route_table_association" "Primary_RTA" {
  provider       = aws.Primary
  subnet_id      = aws_subnet.primary_subnet.id
  route_table_id = aws_route_table.Primary_RT.id
}   
# Associate Secondary Subnet with Secondary Route Table
resource "aws_route_table_association" "Secondary_RTA" {
  provider       = aws.Secondary
  subnet_id      = aws_subnet.secondary_subnet.id
  route_table_id = aws_route_table.Secondary_RT.id
}

# VPC Peering Connection
resource "aws_vpc_peering_connection" "primary_to_secondary" {
  provider               = aws.Primary
  vpc_id                 = aws_vpc.Primary_VPC.id
  peer_vpc_id            = aws_vpc.Secondary_VPC.id
  peer_region            = var.Secondary
  auto_accept            = false

  tags = {
    Name = "Primary-to-Secondary-Peering"
    Environment = "Demo"
    side = "Requester"
  }
}
resource "aws_vpc_peering_connection_accepter" "secondary_to_primary" {
  provider                  = aws.Secondary
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_secondary.id
  auto_accept               = true

  tags = {
    Name = "Secondary-to-Primary-Peering"
    Environment = "Demo"
    side = "Requester"
  }
}
# Update Route Table in Primary VPC to route traffic to Secondary VPC
resource "aws_route" "Primary_to_Secondary_route" {
  provider              = aws.Primary
  route_table_id        = aws_route_table.Primary_RT.id
  destination_cidr_block = var.Secondary_VPC_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_secondary.id
}
# Update Route Table in Secondary VPC to route traffic to Primary VPC
resource "aws_route" "Secondary_to_Primary_route" {
  provider              = aws.Secondary
  route_table_id        = aws_route_table.Secondary_RT.id
  destination_cidr_block = var.Primary_VPC_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.primary_to_secondary.id
}

#Security Group in Primary VPC ec2 instances
resource "aws_security_group" "Primary_SG" {
  provider = aws.Primary
  name        = "Primary-SG-${var.Primary}"
  description = "Security Group for Primary VPC"
  vpc_id      = aws_vpc.Primary_VPC.id 
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "ICMP from Secondary VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.Secondary_VPC_cidr]
  }
  ingress {
    description = "All traffic from Secondary VPC"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.Secondary_VPC_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Primary-SG-${var.Primary}"
    Environment = "Demo"
  }
}
#Security Group in Secondary VPC ec2 instances
resource "aws_security_group" "Secondary_SG" {
  provider = aws.Secondary
  name        = "Secondary-SG-${var.Secondary}"
  description = "Security Group for Secondary VPC"
  vpc_id      = aws_vpc.Secondary_VPC.id 
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "ICMP from Primary VPC"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.Primary_VPC_cidr]
  }
  ingress {
    description = "All traffic from Primary VPC"
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = [var.Primary_VPC_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "Secondary-SG-${var.Secondary}"
    Environment = "Demo"
  }
}

# EC2 Instance in Primary VPC
resource "aws_instance" "Primary_instance" {
  provider = aws.Primary
  ami           = data.aws_ami.Primary_ami.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.primary_subnet.id
  key_name      = var.Primary_key_name
  vpc_security_group_ids = [aws_security_group.Primary_SG.id]

  user_data = local.primary_user_data

  tags = {
    Name = "Primary-Instance-${var.Primary}"
    Environment = "Demo"
    region = var.Primary
  }
}
# EC2 Instance in Secondary VPC
resource "aws_instance" "Secondary_instance" {
  provider = aws.Secondary
  ami           = data.aws_ami.Secondary_ami.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.secondary_subnet.id
  key_name      = var.Secondary_key_name
  vpc_security_group_ids = [aws_security_group.Secondary_SG.id]
  user_data = local.secondary_user_data
  tags = {
    Name = "Secondary-Instance-${var.Secondary}"
    Environment = "Demo"
    region = var.Secondary
  }
}
