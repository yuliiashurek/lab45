provider "aws" {
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_instance" "lab6_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.lab6_security_group.id]

  user_data = <<-EOF
    #!/bin/bash
    sudo yum update -y  # Update package list

    # Install Docker
    sudo yum install -y docker

    # Start and enable Docker service
    sudo service docker start
    sudo systemctl enable docker

    # Add ec2-user to the docker group
    sudo usermod -aG docker ec2-user

    # Run Docker containers
    sudo docker run -d --name lab45 -p 80:80 juliysik/lab45
    sudo docker run -d --name watchtower --restart=always \
      -v /var/run/docker.sock:/var/run/docker.sock \
      containrrr/watchtower --interval 60
  EOF
}


resource "aws_security_group" "lab6_security_group" {
  name        = "launch-wizard-2"
  description = "Allow SSH and HTTP traffic"

  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Дозволяємо SSH трафік з усіх IP адрес
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Дозволяємо HTTP трафік з усіх IP адрес
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
