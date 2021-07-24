provider "aws" {
    profile = "default"
    region     = "us-east-1"
}
resource "aws_instance" "example" {
    ami           = "ami-03295ec1641924349"
    instance_type = "t2.micro"
tags = {    Name = "ExampleAppServerInstance"  }
}