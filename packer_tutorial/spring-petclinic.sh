#!/bin/bash
sudo yum update -y
sudo yum install git -y
git clone https://github.com/liatrio/spring-petclinic.git
sudo yum install java-17-amazon-corretto.x86_64 -y
cd spring-petclinic
# validate, compile, test and package into distributable format
./mvnw package 
# instead of doing here, use a unit file and systemctl to handle this as a service
# java -jar /home/ec2-user/spring-petclinic/target/*.jar

# retrieve exact path of Java artifact to pass into unit file (unit file can't use wildcard * symbol)
# -print prints full name of match to stdout
# -quit causes command to exit upon finding a match
JAR_PATH=$(find /home/ec2-user/spring-petclinic/target -name '*.jar' -print -quit)

# Create systemd service file for Spring PetClinic
cat <<EOF | sudo tee /etc/systemd/system/spring-petclinic.service > /dev/null
[Unit]
Description=Spring PetClinic Application
After=network.target

[Service]
User=ec2-user
WorkingDirectory=/home/ec2-user/spring-petclinic
ExecStart=/bin/java -jar $JAR_PATH
SuccessExitStatus=143

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd to recognize the new service
sudo systemctl daemon-reload

# Enable the Spring PetClinic service to start on boot
sudo systemctl enable spring-petclinic.service

# # Start the service
# sudo systemctl start spring-petclinic.service
