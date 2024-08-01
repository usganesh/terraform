terraform {
  backend "s3" {
    bucket         = "ec2dynamodb"  # Replace with your bucket name
    key            = "nginx.tfstate"   # Path to the state file in the bucket
    region         = "us-east-1"                  # Change to your region
    dynamodb_table = "terraform-locks"            # Optional: For state locking
    access_key = "****"
    secret_key = "****"
  }
}

# Specify the provider
provider "aws" {
  region = "us-east-1"  # Change to your desired region
  access_key = "*****"
  secret_key = "******"
}

# Create a security group
resource "aws_security_group" "allow_ssh" {
  name        = "webserver access"
  description = "Allow webserver and console access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Change to your desired IP range
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Change to your desired IP range
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"  # All protocols
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create an EC2 instance
resource "aws_instance" "webserver" {
  count         = 2
  ami           = "ami-0b72821e2f351e396"  # Replace with a valid AMI ID for your region
  instance_type = "t2.medium"  # Change instance type if needed
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  tags = {
    Name = "webserver-${count.index + 1}" 
  }
  user_data = <<-EOF
              #!/bin/bash
              #-----------Adding Lab-key-----------------------------------
              echo "***" >> /home/ec2-user/.ssh/authorized_keys
              # Update the package manager
              yum update -y
              # Install Apache web server
              yum install -y httpd
              # Start the web server
              systemctl start httpd
              # Enable the web server to start on boot
              systemctl enable httpd
              # Create a simple index.html file
              echo "<h1>Hello from $HOSTNAME </h1>" > /var/www/html/index.html
              EOF
   
}


# Create an EC2 instance
resource "aws_instance" "nginx" {
  ami           = "ami-0b72821e2f351e396"  # Replace with a valid AMI ID for your region
  instance_type = "t2.medium"  # Change instance type if needed
    vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  tags = {
    Name = "NginxLoadBalancer" 
  }
  user_data = <<-EOF
              #!/bin/bash
              #-----------Adding Lab-key-----------------------------------
              echo "****" >> /home/ec2-user/.ssh/authorized_keys
              # Update the package manager
              yum update -y
              # Install nginx web server
              amazon-linux-extras install -y nginx1
              yum install -y nginx
                # Configure Nginx as a load balancer
              cat <<EOT > /etc/nginx/conf.d/load_balancer.conf
              upstream backend {
                  server ${aws_instance.webserver[0].private_ip};
                  server ${aws_instance.webserver[1].private_ip};
              }

              server {
                  listen 80;

                  location / {
                      proxy_pass http://backend;
                      proxy_set_header Host \$host;
                      proxy_set_header X-Real-IP \$remote_addr;
                      proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
                      proxy_set_header X-Forwarded-Proto \$scheme;
                  }
              }
              EOT
              # Start the web server
              systemctl start nginx
              # Enable the web server to start on boot
              systemctl enable nginx

              EOF
  
}