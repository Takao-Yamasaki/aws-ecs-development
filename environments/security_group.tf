// セキュリティグループの作成
resource "aws_security_group" "my-app-frontend-sg" {
  name        = "my-app-frontend-sg"
  vpc_id      = aws_vpc.my-workspace-vpc.id
  description = "My App Frontend Security Group"

  // アウトバウンドルール
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    description = "allow all outbound traffic by default"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// インバウンドルール(ユーザー向け)
resource "aws_vpc_security_group_ingress_rule" "my-app-frontend-sg-ingress" {
  security_group_id = aws_security_group.my-app-frontend-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

// ALB用のセキュリティグループの作成
resource "aws_security_group" "my-app-lb-sg" {
  vpc_id      = aws_vpc.my-workspace-vpc.id
  description = "Security Group for load balancer"
  // アウトバウンドルール
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    description = "allow all outbound traffic by default"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// インバウンドルール(開発者向け)
resource "aws_vpc_security_group_ingress_rule" "my-app-lb-sg-ingress-dev" {
  security_group_id = aws_security_group.my-app-frontend-sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 9000
  ip_protocol       = "tcp"
  to_port           = 9000
}
