/*resource aws_instance name {
    ami           = "ami-06e3c045d79fd65d9" # Amazon Linux 2 AMI (HVM), SSD Volume Type in us-east-2
    instance_type = var.allowed_vm_types[1]
    region        = var.region
    
    tags = var.tags

    lifecycle {
        create_before_destroy = true
        prevent_destroy = false
    }
}

resource "aws_launch_template" "app_server" {
  name_prefix   = "app-server-"
  image_id      = "ami-06e3c045d79fd65d9" # Amazon Linux 2 AMI (HVM), SSD Volume Type in us-east-2
  instance_type = var.allowed_vm_types[1]

  tag_specifications {
    resource_type = "instance"

    tags = var.tags
  }
  
}

# Create an Auto Scaling Group
resource "aws_autoscaling_group" "app_servers" {
    name = "app-servers-asg"
  min_size                  = 1
  max_size                  = 5
  desired_capacity          = 2
  health_check_type = "EC2"
  availability_zones = ["us-east-2a", "us-east-2b"]
    launch_template {
        id      = aws_launch_template.app_server.id
        version = "$Latest"
    }

  tag {
    key                 = "name"
    value               = "App-Server_ASG"
    propagate_at_launch = true
  }
    tag {
        key                 = "Demo"
        value               = "ignore_changes"
        propagate_at_launch = false
    }
}
*/

#Security Group
/*resource "aws_security_group" "app_sg" {
    name        = "app_secrity_sg"
    description = "Allow inbound traffic on port 80 and all outbound traffic"
    
    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow HTTP inbound traffic"
    }
    
    ingress {
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        description = "Allow HTTPS inbound traffic" 
    }
    
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1" # all ports
        cidr_blocks = ["0.0.0.0/0"]
            description = "Allow all outbound traffic"
        }

    tags = var.tags
}

#ec2 instance that gets replaced when security group changes
resource "aws_instance" "app_with_sg" {
    ami           = "ami-06e3c045d79fd65d9" # Amazon Linux 2 AMI (HVM), SSD Volume Type in us-east-2
    instance_type = var.allowed_vm_types[0]
    security_groups = [aws_security_group.app_sg.id]
    
    tags = var.tags

    lifecycle {
        replace_triggered_by = [
            aws_security_group.app_sg.id
        ]
    }
}

*/

resource "aws_s3_bucket" "compliance_bucket" {
  bucket = "compliance-bucket-${var.Environment}-${var.region}"
    tags   = var.tags

    lifecycle {
      postcondition {
        condition = contains(keys(var.tags), "compliance")
        error_message = "ERROR: Bucket must have a ' compliance' tag."
      }
    }
  
}