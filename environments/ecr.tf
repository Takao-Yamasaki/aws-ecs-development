# プライベートリポジトリ my-app-frontend
resource "aws_ecr_repository" "my-app-frontend" {
  name                 = "my-app-frontend"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

# # プライベートリポジトリ my-app-api
# resource "aws_ecr_repository" "my-app-api" {
#   name                 = "my-app-api"
#   image_tag_mutability = "MUTABLE"

#   image_scanning_configuration {
#     scan_on_push = false
#   }
# }
