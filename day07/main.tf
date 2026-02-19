# Create Ec2 Instance
resource "aws_instance" "sample" {
  count = var.instance_count
  ami           = "ami-06e3c045d79fd65d9" # Amazon Linux 2 AMI (HVM), SSD Volume Type in us-east-2
  instance_type = var.allowed_vm_types[1]
  #region = tolist(var.allowed_region)[1]
  region = var.config.region

  monitoring = var.monitoring_enabled
  associate_public_ip_address = var.associate_public_ip


    tags = var.tags
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic and all outbound traffic"

  tags = var.tags
}

resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = var.cidr_block[0]
  from_port         = var.ingress_values[0]
  ip_protocol       = var.ingress_values[1]
  to_port           = var.ingress_values[2]
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_tls.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}
