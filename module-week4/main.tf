terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.27.0"
    }
  }
}

provider "aws" {
  region     = "ap-northeast-2"
}

module "vpc" {
	//1. ����� ��� ��ġ�� �����
  source                    = "./vpc"
	//2. input varialbes �� ���� ����
  vpc_cidr_block            = "10.0.0.0/16"
  public_subnet_cidr_block  = "10.0.0.0/24"
  private_subnet_cidr_block = "10.0.1.0/24"
}
