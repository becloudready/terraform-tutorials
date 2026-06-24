provider "aws" {
  region = "ca-central-1"
}

# Variable for authorized IP address
variable "authorized_ip" {
  description = "IP address authorized to access the instance"
  type        = string
  default     = "4.4.4.4/32"
}

# Data source to fetch the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

# Custom Security Group following best practices
resource "aws_security_group" "web" {
  name        = "web-secure"
  description = "Security group with restricted inbound access - only from authorized IP"

  # Inbound rule: SSH only from authorized IP
  ingress {
    description = "SSH from authorized IP only"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.authorized_ip]
  }

  # Deny all other inbound traffic (implicit deny)

  # Outbound rule: Allow all outbound traffic (best practice for updates/patches)
  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "web-sg-secure"
    Environment = "production"
  }
}

resource "aws_instance" "web" {
  ami            = data.aws_ami.amazon_linux_2.id
  instance_type  = "t3.micro"
  vpc_security_group_ids = [aws_security_group.web.id]
  
  # Best practice: Enable EBS encryption by default
  root_block_device {
    volume_size           = 20
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = true
  }

  # Best practice: Enable detailed monitoring
  monitoring = true

  # Best practice: Add descriptive tags
  tags = {
    Name        = "web-server-secure"
    Environment = "production"
  }
}

# Output the instance details
output "instance_id" {
  value       = aws_instance.web.id
  description = "EC2 instance ID"
}

output "instance_public_ip" {
  value       = aws_instance.web.public_ip
  description = "Public IP address of the EC2 instance"
}

output "security_group_id" {
  value       = aws_security_group.web.id
  description = "Security group ID"
}