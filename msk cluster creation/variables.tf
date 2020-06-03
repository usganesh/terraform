//clust_name = "test cluster"
//clust_ver = 

variable "aws_region" {
    description = "AWS region"
}
variable "clust_name" {
    description = "Name of the Kafka cluster"
}
variable "clust_ver" {
  description = "version of the Kafka cluster"
  default = "2.2.1"
}
variable "env" {
    description = "This is used for naming conversion for tags, Ex., Prod, Non-Prod"
}
variable "platform" {
  description = "This is also used for naming conversion for Ex., Traffic, this will result Prod_Traffic_Msk_Bucket"
  default = "Traffic"
}
variable "app" {
  description = "This is app name for tags"
  default = "Traffic"
}
variable "s3_name" {
  description = "Name of the S3 Bucket"
  default = "Msk-Bucket"
}
variable "cloudwatch_name" {
    description = "Name of the cloudwatch log"
    default = "Msk_Broker_Logs"
}
variable "firehose_role" {
    description = "Name of the IAM ROle"  
    default = "Firehose_Role"
}
variable "msk_stream_name" {
    description = "Name of the kinesis-firehose-msk-broker-logs-stream"  
    default = "kinesis-firehose-msk-broker-logs-streams"
}
variable "broker_number" {
    description = "number of the brokers to be configured in the cluster"
}
variable "instance_size" {
  description = "instance type Eg., kafka.t3.small"
}
variable "ebs_size" {
  description = "Size of the EBS Volume in numberic, in GB"  
}
variable "subnet1" {
  description = "subnet id from the same region declared, should be in diiferent availability zone from var.subnet2 and subnet3" 
}
variable "subnet2" {
  description = "subnet id from the same region declared, should be in diiferent availability zone from var.subnet1 and subnet3" 
}
variable "subnet3" {
  description = "subnet id from the same region declared, should be in diiferent availability zone from var.subnet1 and subnet2" 
}
variable "sec_group" {
    description = "security group to be used used for the msk cluster"
}
