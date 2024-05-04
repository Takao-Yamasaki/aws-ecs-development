
# クラスターの作成
resource "aws_ecs_cluster" "my-app-cluster" {
  name = "my-app-cluster"
}

# タスク定義の作成
## https://zenn.dev/hsaki/books/golang-grpc-starting/viewer/awshost
## https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition
## https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/task-cpu-memory-error.html
## https://gallery.ecr.aws/nginx/nginx
## https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/task_definition_parameters.html
resource "aws_ecs_task_definition" "my-app-frontend" {
  family                   = "my-app-frontend"
  requires_compatibilities = ["FARGATE"]

  network_mode = "awsvpc"
  cpu          = 256
  memory       = 512
  container_definitions = jsonencode([
    {
      name      = "frontend"
      image     = "public.ecr.aws/nginx/nginx:stable-perl"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      logConfigration = {
        logDriver = "awslogs"
        options = {
          region            = "ap-northeast-1"
          log_group_name    = "ecs/my-app-frontend"
          log_stream_prefix = "ecs"
        }
      }
    }
  ])
  # OSとアーキテクチャの指定
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  # NOTE: Nginxのイメージを使用するだけなので、タスク実行ロールのみ付与
  execution_role_arn = aws_iam_role.my-app-task-execution-role.arn
}

# サービスの作成
resource "aws_ecs_service" "my-app-frontend-service" {
  name                = "my-app-frontend-service"
  cluster             = aws_ecs_cluster.my-app-cluster.arn
  task_definition     = aws_ecs_task_definition.my-app-frontend.arn
  launch_type         = "FARGATE"
  scheduling_strategy = "REPLICA"
  platform_version    = "LATEST"
  desired_count       = 1
  deployment_controller {
    type = "CODE_DEPLOY"
  }
  
  network_configuration {
    # パブリックIPの自動割り当てを有効化
    assign_public_ip = true
    security_groups = [
      aws_security_group.my-app-frontend-sg.id
    ]
    subnets = [ 
      aws_subnet.my-workspace-subnet-app-public1-a.id,
      aws_subnet.my-workspace-subnet-app-public1-b.id
    ]
  }
  load_balancer {
    target_group_arn = aws_lb_target_group.my-app-frontend-tg-1.arn
    container_name = "frontend"
    container_port = 80
  }
}
