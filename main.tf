terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}
resource "aws_key_pair" "k8s-key"{
    key_name = "k8s-key"
    public_key = "rsa-ssh AAAAB3NzaC1yc2EAAAADAQABAAABAQCRNzG3zOXuJ66QEfzFrsHu781BTJi3mDxjmSr/ocsTKyYMTaxJvpDcUmoTBpWw9fMjmrWSfVfcz8Mu+uzYl43C7VQMkZFWJMJHni6OtbPn4EO5T0XW/gtbvhXbHTTvy/bBw5tZutPlrz1LsrBCDHW77F3r7w5OzXzxFCu2l8q5/vKJCxOH/T01O1y3Svly+7fPFKCJQQl2R1CGKTd+NIQpIuSNxpbaRRO/xSk15NwkrwmHhJwR2eGkgK2UAKBcPH5n0hH38pjezrHYlv4qwuR5UIJBhA1KH9+eApnhfNRfowBtti+QE/fT7W9VQcTnDuUCyt7q/8WrUKmcDoeVFDuF"
}

resource "aws_instance" "instanciateste01" {
  ami           = "ami-04505e74c0741db8d"
  instance_type = "t2.micro"
  key_name = "k8s-key"
  count = 2
  tags = {
    Name = "primeiro_código_terraform"
    type = "master"
  }
  security_groups = ["${aws_security_group.k8s-sg.name}"]
}

resource "aws_instance" "instancia_teste02"{
    ami = "ami-04505e74c0741db8d"
    instance_type = "t2.micro"
    key_name = "k8s-key"
    tags = {
        Name = "segundo_código_terraform"
        type = "worker"
    }
    security_groups = ["${aws_security_group.k8s-sg.name}"] 
}

resource "aws_security_group" "k8s-sg"{
    ingress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        self = true
    }
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        cidr_blocks =["0.0.0.0/0"]
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
    }
}