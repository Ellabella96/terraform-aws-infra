output "instance_ids" {
  description = "IDs of the EC2 instances"
  value       = aws_instance.main[*].id
}

output "instance_public_ips" {
  description = "Public IP addresses of the EC2 instances"
  value       = aws_instance.main[*].public_ip
}

output "instance_private_ips" {
  description = "Private IP addresses of the EC2 instances"
  value       = aws_instance.main[*].private_ip
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.ec2.id
}

output "key_pair_name" {
  description = "Name of the key pair"
  value       = var.key_pair_public_key != "" ? aws_key_pair.main[0].key_name : null
}