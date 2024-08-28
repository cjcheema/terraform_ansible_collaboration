terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_instance" "web_server" {
  ami           = "ami-02b49a24cfb95941c" # Replace with your preferred AMI ID
  instance_type = "t2.micro"
  key_name      = var.key_pair_name

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "WebServer"
  }


  # Checking if EC2 instance is accessible via ssh post provisioning and before ansible playbook is invoked
  provisioner "remote-exec" {
    inline = [
      "echo 'Hello World! I am cj-web01 and I am alive.'"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
  }

  # Provisioner to run Ansible playbook after the instance is created
  provisioner "local-exec" {
    command = <<EOT
      ansible-playbook -i ${self.public_ip}, --private-key ${var.private_key_path} patch_apache_install.yml
    EOT
  }

}

resource "aws_security_group" "web_sg" {
  name        = "web_sg"
  description = "Allow HTTP and SSH access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


variable "aws_region" {
  description = "The AWS region to create resources in."
  default     = "ap-south-1"
}

variable "aws_access_key" {
  description = "AWS access key"
  type        = string
  sensitive   = true
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type        = string
  sensitive   = true
}

variable "key_pair_name" {
  description = "AWS key pair name"
  type        = string
}

variable "private_key_path" {
  description = "Path to the private SSH key"
  type        = string
}
