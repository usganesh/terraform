provider "aws" {
    access_key = "AKIAU2QQVWMQ63FYTUWI"
    secret_key = "L7TRbcZ9Pfq4HnjJqy+uDlBiZaaH6sQN66eJ2rrd"
    region     = "us-east-1"
}
resource "aws_instance" "example" {
    ami           = "ami-0c278895328cddfdd"
    instance_type = "t2.micro"
}
