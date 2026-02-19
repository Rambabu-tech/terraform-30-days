# create local values
locals {
    bucket_name = "${var.channel_name}-bucket-${var.Environment}"
    vpc_name    = "${var.Environment}-vpc"
}