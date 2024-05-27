// セキュリティグループの作成
resource "aws_security_group" "my-app-frontend-sg" {
  name        = "my-app-frontend-sg"
  vpc_id      = aws_vpc.my-workspace-vpc.id
  description = "My App Frontend Security Group"
  // インバウンドルール
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  // TODO: あとから削除する
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // アウトバウンドルール
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    description = "allow all outbound traffic by default"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// ALB用のセキュリティグループの作成
resource "aws_security_group" "my-app-lb-sg" {
  name        = "my-app-lb-sg"
  vpc_id      = aws_vpc.my-workspace-vpc.id
  description = "Security Group for load balancer"
  // インバウンドルール（ユーザー向け）
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "for User"
  }

  // インバウンドルール(開発者向け)
  ingress {
    from_port = 9000
    to_port   = 9000
    protocol  = "tcp"
    // NOTE: 開発用のIP制限
    cidr_blocks = ["49.109.0.0/16"]
    description = "for Developer"
  }

  // アウトバウンドルール
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    description = "allow all outbound traffic by default"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# セキュリティグループの作成 my-app-api-sg
resource "aws_security_group" "my-app-api-sg" {
  name        = "my-app-api-sg"
  vpc_id      = aws_vpc.my-workspace-vpc.id
  description = "For my app api service"
  # インバウンドルール
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # アウトバウンドルール
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    description = "allow all outbound traffic by default"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
