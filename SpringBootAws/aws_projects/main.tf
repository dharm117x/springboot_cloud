terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  #access_key = ""
  #secret_key = ""
}


module "dev" {
  source = "./aws_infra"
  my-env = "dev"
  instance_type = "t2.micro"
  ami_id = "ami-0c421724a94bba6d6"
  instance_count = 1
  key_name = "Ec2_keyPair"
}

module "staging" {
  source = "./aws_infra"
  my-env = "staging"
  instance_type = "t2.micro"
  ami_id = "ami-0c421724a94bba6d6"
  instance_count = 1
  key_name = "Ec2_keyPair"
}
