// タスク実行ロールの作成
resource "aws_iam_role" "my-app-task-execution-role" {
  name               = "ecsTaskExecutionRole"
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

# IAMポリシー(AWSCodeDeployRoleForECS)をアタッチ
resource "aws_iam_role_policy_attachment" "my-app-ecs-codedeploy-assume-policy" {
  role       = aws_iam_role.my-app-ecs-codedeploy-role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}

# IDプロバイダの作成
# https://docs.github.com/ja/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services#adding-the-identity-provider-to-aws
resource "aws_iam_openid_connect_provider" "github_actions" {
  url = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  thumbprint_list = data.tls_certificate.github_actions.certificates[*].sha1_fingerprint
}

data "http" "github_actions_openid_configration" {
  url = "https://token.actions.githubusercontent.com/.well-known/openid-configuration"
}
# サムプリントを取得
data "tls_certificate" "github_actions" {
  url = jsondecode(data.http.github_actions_openid_configration.response_body).jwks_uri
}

// GitHub Actions用のロールの作成
resource "aws_iam_role" "my-app-ecs-github-actions-role" {
  name               = "GitHubActionsEcsLearningCourse"
  assume_role_policy = data.aws_iam_policy_document.my-app-ecs-github-actions-assume-policy.json
  description = "Role for GitHub Actions ecs-learnig-course repository."
}

locals {
  allowed_github_repositories = [
    "aws-ecs-development"
  ]
  github_org_name = "Takao-Yamasaki"
  full_paths = [
    for repo in local.allowed_github_repositories : "repo:${local.github_org_name}/${repo}:*"
  ]
}

data "aws_iam_policy_document" "my-app-ecs-github-actions-assume-policy" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github_actions.arn]
    }
    
    # OIDCを利用できる対象のGitHub Repositoryを制限
    condition {
      test = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values = local.full_paths
    }
  }
}

# カスタムIAMポリシードキュメントを作成
data "aws_iam_policy_document" "my-app-ecs-ecr-push-pull-image-policy" {
  statement {
    sid = "1"
    effect = "Allow"
    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:BatchCheckLayerAvailability",
      "ecr:PutImage",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:GetAuthorizationToken",
    ]
    resources = [ "*" ]
  }
  statement {
    effect = "Allow"
    actions = [
      "ecs:UpdateService",
      "ecs:RegisterTaskDefinition",
      "ecs:ListTaskDefinitions",
      "ecs:DescribeServices",
    ]
    resources = [ "*" ]
  }
  statement {
    effect = "Allow"
    actions = [ "iam:PassRole" ]
    resources = [ "arn:aws:iam::${data.aws_caller_identity.self.account_id}:role/ecsTaskExecutionRole" ]
  }
}

# カスタムIAMポリシーの作成
resource "aws_iam_policy" "my-app-ecs-ecr-push-pull-image-policy" {
  name = "UpdateECSTask"
  policy = data.aws_iam_policy_document.my-app-ecs-ecr-push-pull-image-policy.json
}

# カスタムIAMポリシーをアタッチ
resource "aws_iam_role_policy_attachment" "my-app-ecs-github-actions-assume-policy" {
  role       = aws_iam_role.my-app-ecs-github-actions-role.name
  policy_arn = aws_iam_policy.my-app-ecs-ecr-push-pull-image-policy.arn
}
