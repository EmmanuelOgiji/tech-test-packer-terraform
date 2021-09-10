terraform {
  required_version = "~> 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.23.0"
    }
  }
  backend "s3" {
    bucket = "emmanuel-pius-ogiji-tf-states"
    key    = "tfstate/tech-test-packer.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}
