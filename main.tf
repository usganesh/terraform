provider "aws" {
    profile = "default"
    region     = "us-east-1"
}
resource "aws_instance" "example" {
    ami           = "ami-0c278895328cddfdd"
    instance_type = "t2.micro"
}
