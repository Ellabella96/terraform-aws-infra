# Data source for latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
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
}


# Security Group for EC2 instances
resource "aws_security_group" "ec2" {
  name_prefix = "${var.project_name}-ec2-"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidrs
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.project_name}-ec2-sg-${var.environment}"
    Environment = var.environment
    Project     = var.project_name
  }

  lifecycle {
    create_before_destroy = true
  }
}

# IAM role for EC2 instances
resource "aws_iam_role" "ec2" {
  name = "${var.project_name}-ec2-role-${var.environment}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-ec2-role-${var.environment}"
    Environment = var.environment
    Project     = var.project_name
  }
}

# IAM instance profile
resource "aws_iam_instance_profile" "ec2" {
  name = "${var.project_name}-ec2-profile-${var.environment}"
  role = aws_iam_role.ec2.name
}

# Attach SSM managed policy to the role
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Key pair for EC2 instances
resource "aws_key_pair" "main" {
  count = var.key_pair_public_key != "" ? 1 : 0

  key_name   = "${var.project_name}-key-${var.environment}"
  public_key = var.key_pair_public_key

  tags = {
    Name        = "${var.project_name}-key-${var.environment}"
    Environment = var.environment
    Project     = var.project_name
  }
}

# EC2 instances
resource "aws_instance" "main" {
  count = var.instance_count

  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = var.key_pair_public_key != "" ? aws_key_pair.main[0].key_name : null
  vpc_security_group_ids = [aws_security_group.ec2.id]
  subnet_id              = var.subnet_ids[count.index % length(var.subnet_ids)]
  iam_instance_profile   = aws_iam_instance_profile.ec2.name

  user_data = base64encode(<<-EOF
#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<h1>Hello from ${var.project_name} - Instance $((${count.index} + 1))</h1>" > /var/www/html/index.html
echo "<p>Environment: ${var.environment}</p>" >> /var/www/html/index.html
echo "<p>Instance ID: $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</p>" >> /var/www/html/index.html
EOF
  )

  tags = {
    Name        = "${var.project_name}-instance-${count.index + 1}-${var.environment}"
    Environment = var.environment
    Project     = var.project_name
  }

  root_block_device {
    volume_type = "gp3"
    volume_size = var.root_volume_size
    encrypted   = true
  }
}