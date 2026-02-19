# create a variable
variable "Environment" {
    default     = "dev"
    type = string
  
}
variable "Primary" {
    default     = "us-east-2"
    type = string
  
}
variable "Secondary" {
    default     = "us-west-1"
    type = string
  
}

variable "Primary_VPC_cidr" {
    description = "CIDR block for the Primary VPC"
    type = string
    default = "10.0.0.0/16"
  
}
variable "Secondary_VPC_cidr" {
    description = "CIDR block for the Secondary VPC"
    type = string
    default = "10.1.0.0/16"

}
variable "primary_subnet_cidr" {
    description = "CIDR block for the Primary Subnet"
    type = string
    default = "10.0.1.0/24"
  
}
variable "secondary_subnet_cidr" {
    description = "CIDR block for the Secondary Subnet"
    type = string
    default = "10.1.1.0/24"
}
variable "instance_type" {
    description = "EC2 Instance Type"
    type = string
    default = "t2.micro"
  
} 
variable "Primary_key_name" {
    description = "Key pair name for EC2 instances"
    type = string
    default = ""
  
}
variable "Secondary_key_name" {
    description = "Key pair name for EC2 instances"
    type = string
    default = ""
  
}
