# aws-ecs-development
TerraformでECS環境(`Blue/Green Deploy`)を構築するサンプルです
## AWSリソースの更新方法
- `CodeBuild`と`tfnotify`を使用して、`terraform plan/apply`の結果が自動的にGitHubに通知される仕組みを構築している
- プルリクエストを作成して、tfnotifyから通知される`terraform plan`の結果に問題ないか確認
- mainブランチにmergeすると、自動的に`terraform apply`する
