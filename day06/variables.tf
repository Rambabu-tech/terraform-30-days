# create a variable
variable "Environment" {
    default     = "dev"
    type = string
  
}
variable "channel_name" {
    default     = "my-tf-ram-test"
    type = string
  
} 
variable "region" {
    default     = "us-east-2"
    type = string
  
}