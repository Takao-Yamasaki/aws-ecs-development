// 必要なプロバイダとそのバージョンを定義
// https://zenn.dev/uepon/articles/db6f76c679eb12
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws" // AWSプロバイダのソース
      version = "~> 5.42" // バージョン指定
    }
  }
}

// AWSプロバイダの設定
provider "aws" {
  region = "ap-northeast-1"
}
