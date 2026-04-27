#!bin/bash
#✔️ Step 1: Update system
sudo yum update -y  
#✔️ Step 2: Install Docker
sudo yum install docker -y
#✔️ Step 3: Start Docker
sudo systemctl start docker
#✔️ Step 4: Enable Docker on boot
sudo systemctl enable docker
#✔️ Step 5: Give permission to ec2-user (IMPORTANT)
sudo usermod -aG docker ec2-user


#!/bin/bash

# Install Amazon Corretto (Java)
echo "Installing Amazon Corretto (Java)..."
sudo dnf install -y java-21-amazon-corretto

# Verify Java installation
echo "Java version:"
java -version

# Add Jenkins repository
#echo "Adding Jenkins repository..."
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo

# Import Jenkins key
#echo "Importing Jenkins GPG key..."
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

# Install Jenkins
#echo "Installing Jenkins..."
sudo dnf install -y jenkins

# Start Jenkins service
#echo "Starting Jenkins service..."
sudo systemctl start jenkins


#echo "Enabling Jenkins to start on boot..."
sudo systemctl enable jenkins
