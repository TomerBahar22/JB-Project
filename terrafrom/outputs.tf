output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.builder.public_ip
}

output "instance_id" {
  description = "Instance ID"
  value       = aws_instance.builder.id
}

output "ssh_private_key_path" {
  description = "Path to the generated private SSH key"
  value       = local_file.private_key.filename
  sensitive   = true
}

output "ssh_command" {
  description = "Example SSH command"
  value       = "ssh -i builder_key.pem ec2-user@${aws_instance.builder.public_ip}"
}
