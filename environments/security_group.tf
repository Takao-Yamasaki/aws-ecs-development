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
    cidr_blocks = "0.0.0.0/0"
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
  vpc_id      = aws_vpc.my-workspace-vpc.id
  description = "Security Group for load balancer"
  // インバウンドルール（ユーザー向け）
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = "0.0.0.0/0"
    description = "for User"
  }

  // インバウンドルール(開発者向け)
  ingress {
    from_port = 9000
    to_port   = 9000
    protocol  = "tcp"
    // NOTE: 本来ならIP制限していい
    cidr_blocks = "0.0.0.0/0"
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
