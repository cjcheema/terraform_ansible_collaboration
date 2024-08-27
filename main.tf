terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    ansible = {
      source  = "ansible/ansible"
      version = "~> 1.3.0"
    }
  }
}

provider "aws" {
  region     = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

provider "ansible" {} # Calling Ansible provider after AWS provider

resource "aws_instance" "web_server" {
  ami           = "ami-02b49a24cfb95941c"  # Replace with your preferred AMI ID
  instance_type = "t2.micro"
  key_name      = var.key_pair_name

  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "WebServer"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.private_key_path)
    host        = self.public_ip
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

resource "ansible_playbook" "run_playbook" { # Using the ansible_playbook resource to run the ansible playbook
  playbook   = "patch_apache_install.yml"   
  name = aws_instance.web_server.public_ip
  replayable = true
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