# ALB
resource "aws_lb" "my-app-alb" {
  load_balancer_type = "application"
  name               = "my-app-alb"
  internal           = false
  ip_address_type    = "ipv4"
  security_groups = [ aws_security_group.my-app-lb-sg.id ]
  subnets = [ aws_subnet.my-workspace-subnet-app-public1-a.id, aws_subnet.my-workspace-subnet-app-public1-b.id ]

  tags = {
    "Name" : "my-app-alb"
  }
}

# プロダクションリスナー
resource "aws_lb_listener" "my-app-production-listener" {
  load_balancer_arn = aws_lb.my-app-alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my-app-frontend-tg-1.arn
  }
}

# テストリスナー
resource "aws_lb_listener" "my-app-test-listener" {
  load_balancer_arn = aws_lb.my-app-alb.arn
  port              = 9000
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my-app-frontend-tg-1.arn
  }
}

resource "aws_lb_target_group" "my-app-frontend-tg-1" {
  name             = "my-app-frontend-tg-1"
  target_type      = "ip"
  vpc_id           = aws_vpc.my-workspace-vpc.id
  port             = 80
  protocol         = "HTTP"
  protocol_version = "HTTP1"

  health_check {
    path                = "/"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = 200
    port                = "traffic-port"
    protocol            = "HTTP"
  }
}

resource "aws_lb_target_group" "my-app-frontend-tg-2" {
  name             = "my-app-frontend-tg-2"
  target_type      = "ip"
  vpc_id           = aws_vpc.my-workspace-vpc.id
  port             = 9000
  protocol         = "HTTP"
  protocol_version = "HTTP1"

  health_check {
    path                = "/"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
    matcher             = 200
    port                = "traffic-port"
    protocol            = "HTTP"
  }
}
