output "instance_public_ip" {
  description = "Public IP address of the deployed EC2 web server"
  value       = aws_instance.web.public_ip
}

output "web_url" {
  description = "Live Website URL"
  value       = "http://${aws_instance.web.public_ip}"
}

