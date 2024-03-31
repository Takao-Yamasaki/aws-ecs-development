// タスク実行ロールの作成
resource "aws_iam_role" "my-app-task-execution-role" {
  name = "my-app-task-execution-role"
  assume_role_policy = data.aws_iam_policy_document.my-app-task-execution-assume-policy.json
}

data "aws_iam_policy_document" "my-app-task-execution-assume-policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

// タスク実行ロール用のポリシーをアタッチ
resource "aws_iam_role_policy_attachment" "my-app-task-execution-policy" {
  role = aws_iam_role.my-app-task-execution-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

## NOTE: タスクロールは使っていない
# // タスクロールの作成
# resource "aws_iam_role" "my-app-task-role" {
#   name = "my-app-task-role"
#   assume_role_policy = data.aws_iam_policy_document.my-app-task-execution-assume-policy.json
# }

# data "aws_iam_policy_document" "my-app-task-assume-policy" {
#   statement {
#     actions = ["sts:AssumeRole"]
#     principals {
#       type = "Service"
#       identifiers = ["ecs-tasks.amazonaws.com"]
#     }
#   }
# }

# resource "aws_iam_policy" "my-app-task-policy" {
#   name = "my-app-task-policy"
#   policy = data.aws_iam_policy_document.my-app-task-policy.json
# }

# // https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/task_definition_parameters.html
# data "aws_iam_policy_document" "my-app-task-policy" {
#   statement {
#     actions = [
#       "logs:CreateLogStream",
#       "logs:CreateLogGroup",
#       "logs:DescribeLogStreams",
#       "logs:PutLogEvents",
#     ]
#     effect = "Allow"
#     resources = ["*"]
#   }
# }

# resource "aws_iam_role_policy_attachment" "my-app-task-role" {
#   role = aws_iam_role.my-app-task-role.name
#   policy_arn = aws_iam_policy.my-app-task-policy.arn
# }
