output "instance_public_ip" {
  description = "Fetching EC2 Public IP address for ssh"
  value = aws_instance.web_server.public_ip  # Ensure this matches the name of your aws_instance resource
}