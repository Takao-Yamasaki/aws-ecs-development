// タスク実行ロールの作成
resource "aws_iam_role" "my-app-task-execution-role" {
  name               = "my-app-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.my-app-task-execution-assume-policy.json
}

data "aws_iam_policy_document" "my-app-task-execution-assume-policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

// タスク実行ロール用のポリシーをアタッチ
resource "aws_iam_role_policy_attachment" "my-app-task-execution-policy" {
  role       = aws_iam_role.my-app-task-execution-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

// CodeDeploy用のロールの作成
resource "aws_iam_role" "my-app-ecs-codedeploy-role" {
  name               = "AWSCodeDeployRoleForECS"
  assume_role_policy = data.aws_iam_policy_document.my-app-ecs-codedeploy-assume-policy.json
}

data "aws_iam_policy_document" "my-app-ecs-codedeploy-assume-policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "my-app-ecs-codedeploy-assume-policy" {
  role       = aws_iam_role.my-app-ecs-codedeploy-role.arn
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}
