output "instance_public_ip" {
  description = "EC2 Server ka Public IP"
  value       = aws_instance.web.public_ip
}

output "web_url" {
  description = "Website link"
  value       = "http://${aws_instance.web.public_ip}"
}
