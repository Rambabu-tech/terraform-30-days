# Output the S3 bucket name and VPC ID
output "s3_bucket_name" {
  value = aws_s3_bucket.my_bucket_rambabu.bucket
}   
output "vpc_id" {
  value = aws_vpc.sample.id
}   
output "ec2_instance_id" {
  value = aws_instance.sample.id
}