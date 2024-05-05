# プライベートリポジトリ フロントエンド
resource "aws_ecr_repository" "my-app-frontend" {
  name = "my-app-frontend"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}
