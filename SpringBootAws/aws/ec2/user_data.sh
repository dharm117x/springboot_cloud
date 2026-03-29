#!/bin/bash
yum update -y

# Install Docker (robust way)
yum install -y docker

# Start & enable Docker
systemctl start docker
systemctl enable docker

# Add ec2-user to docker group
usermod -aG docker ec2-user

# Verify Docker
docker --version

# Install Java (optional)
yum install -y java-17-amazon-corretto

# Run sample container
docker run -d \
  --name nginx-app \
  --log-driver=awslogs \
  --log-opt awslogs-region=us-east-1 \
  --log-opt awslogs-group=docker-logs \
  --log-opt awslogs-stream=nginx-stream \
  -p 80:80 \
  nginx

# Install Git
yum install -y git

# OR run jar (optional)
#java -jar /home/ec2-user/app.jar