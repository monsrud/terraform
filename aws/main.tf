terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.60.0"
    }
  }

  required_version = ">= 1.0.7"
}

provider "aws" {
  profile = "default"
  region  = "us-west-2"
}

resource "aws_instance" "test_server" {
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"

  tags = {
    Name = "Test Server"
  }
  
  # existing security group
  security_groups = ["ssh-group"]
  key_name = "ec2-keypair2"
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_instance.test_server.public_ip
}
