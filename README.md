# aws-ecs-development
TerraformでECS環境を構築するサンプルです
## 起動方法
~~~
terraform apply
~~~
## 更新方法
- CodeBuildとtfnotifyを使用して、terraform plan/applyの結果が自動的にGitHubに通知される仕組みを作成している
- プルリクエストを作成して、tfnotifyから通知される`terraform plan`の結果に問題ないか確認
- mainブランチにmergeすると、自動的に`terraform apply`する
