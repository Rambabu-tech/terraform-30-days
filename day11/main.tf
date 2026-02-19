/*resource "aws_instance" "example" {
  ami           = "ami-06e3c045d79fd65d9"
  count = var.instance_count
 #instance_type = "t3.micro"
 instance_type = var.Environment == "dev" ? "t2.micro" : "t3.micro"
  tags = var.tags
  
}

resource "aws_security_group" "ingress_rule" {
  name   = "sg"
  dynamic "ingress" {
    for_each = var.ingress_rule 
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      description = ingress.value.description
    }
    
  }
  egress  = []
}

locals {
  all_instance_ids = aws_instance.example[*].id
}

output "instance_ids" {
  value = local.all_instance_ids
}
*/


locals {
  formatted_project_name = lower(replace(var.project_name," ","-"))
  new_tag = merge(var.default_tags,var.environment_tags)
  formattted_bucket_name = replace(substr(lower(var.bucket_name[0]),0,63)," ","-")

  port_list = split(",", var.allowed_ports)

  sg_rules = [
    for port in local.port_list : {
      name = "port-${port}"
      port = port
      description = "Allow inbound traffic on port ${port}"
    }
  ]

  instance_size = lookup(var.instance_sizes, var.environment, "t2.micro")

}

resource "aws_s3_bucket" "my_bucket_rambabu" {
  bucket = local.formattted_bucket_name
  tags   = local.new_tag
}

