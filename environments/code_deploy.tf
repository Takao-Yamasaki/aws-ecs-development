# CodeDeploy
resource "aws_codedeploy_app" "my-app-frontend" {
  compute_platform = "ECS"
  name             = "my-app-frontend"
}

# CodeDeployデプロイメントグループ
resource "aws_codedeploy_deployment_group" "my-app-cluster-my-app-frontend-service" {
  app_name               = aws_codedeploy_app.my-app-frontend.name
  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  deployment_group_name  = "codedeploy_deployment_group"
  service_role_arn       = aws_iam_role.my-app-ecs-codedeploy-role.arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout    = "STOP_DEPLOYMENT"
      wait_time_in_minutes = 120
    }
    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = 60
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = aws_ecs_cluster.my-app-cluster.name
    service_name = aws_ecs_service.my-app-frontend-service.name
  }

  load_balancer_info {
    target_group_pair_info {
      # プロダクションリスナーを指定
      prod_traffic_route {
        listener_arns = [aws_lb_listener.my-app-production-listener.arn]
      }

      # テストリスナーを指定
      test_traffic_route {
        listener_arns = [aws_lb_listener.my-app-test-listener.arn]
      }

      target_group {
        name = aws_lb_target_group.my-app-frontend-tg-1.name
      }

      target_group {
        name = aws_lb_target_group.my-app-frontend-tg-2.name
      }
    }
  }
}
