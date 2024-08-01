terraform {
  backend "s3" {
    bucket         = "terrformaurntestterrform"  # Replace with your bucket name
    key            = "terraform.tfstate"   # Path to the state file in the bucket
    region         = "us-east-1"                  # Change to your region
    dynamodb_table = "terraform-locks"            # Optional: For state locking
  }
}

# Specify the provider
provider "aws" {
  region = "us-east-1"  # Change to your desired region
  access_key = ""
  secret_key = ""
}

# Create an EC2 instance
resource "aws_instance" "example" {
  ami           = "ami-0b72821e2f351e396"  # Replace with a valid AMI ID for your region
  instance_type = "t2.medium"  # Change instance type if needed
  tags = {
    Name = "TerraformExampleInstance"
  }
}
