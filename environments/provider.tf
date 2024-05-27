// 環境情報を定義
variable "aws_vpc_cider" {}
variable "aws_private_subnet_cider" {}
variable "aws_public1a_subnet_cider" {}
variable "aws_public1b_subnet_cider" {}
variable "aws_region" {}

// 必要なプロバイダとそのバージョンを定義
// https://zenn.dev/uepon/articles/db6f76c679eb12
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws" // AWSプロバイダのソース
      version = "~> 5.42"       // バージョン指定
    }
  }
  backend "s3" {
    bucket  = "aws-ecs-development-tfstate-bucket-20240503"
    key     = "terraform.tfstate"
    region  = "ap-northeast-1"
    profile = "default"
  }
}

// AWSプロバイダの設定
provider "aws" {
  region = var.aws_region
}

// AWSアカウントIDの取得
data "aws_caller_identity" "self" {}
