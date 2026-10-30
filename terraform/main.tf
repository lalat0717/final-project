variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ssh_public_key" {
  type    = string
  default = ""
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
}

resource "aws_security_group" "web_sg" {
  name        = "my-project-web-sg"
  description = "Allow HTTP and SSH"

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP access for web"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "deployer" {
  count      = var.ssh_public_key != "" ? 1 : 0
  key_name   = "my-project-deployer-key"
  public_key = var.ssh_public_key
}

resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  key_name                    = var.ssh_public_key != "" ? aws_key_pair.deployer[0].key_name : null
  associate_public_ip_address = true

  tags = {
    Name = "my-project-web-server"
  }
}
