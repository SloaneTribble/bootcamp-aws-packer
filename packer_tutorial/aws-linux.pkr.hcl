packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.8"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

source "amazon-ebs" "linux" {
  ami_name      = "stribble-packer-ami"
  instance_type = "t2.small"
  region        = "us-east-1"
  source_ami_filter {
    filters = {
      name                = "amzn2-ami-kernel-5.10-hvm-2.0.20240223.0-x86_64-gp2"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["137112412989"]
  }
  ssh_username = "ec2-user"
  vpc_id = "vpc-0735f5b0267022664"
  subnet_id = "subnet-019c03f7b62349192"

  tags = {
    Name = "stribble-packer-ami" 
    Owner = "stribble"
    Application = "packer-tutorial"
    Client = "Internal"
    Project = "Bootcamp"
    Environment = "Demo"
  }
}

build {
  name = "learn-packer"
  sources = [
    "source.amazon-ebs.linux"
  ]

  provisioner "shell" {
    script = "spring-petclinic.sh"
  }
}
