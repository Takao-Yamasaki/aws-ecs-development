## 使用技術一覧
<img src="https://camo.qiitausercontent.com/11e97646e81c116c851923e0f45e6a6a8037f64c/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f2d446f636b65722d3134383843362e7376673f6c6f676f3d646f636b6572267374796c653d666f722d7468652d6261646765">
<img src="https://camo.qiitausercontent.com/ec57734305b17aa755e88894461c2239ca05e3ea/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f2d7465727261666f726d2d3230323332413f7374796c653d666f722d7468652d6261646765266c6f676f3d7465727261666f726d266c6f676f436f6c6f723d383434454241">
<img src="https://camo.qiitausercontent.com/38f0d65f0b30d5c48c51df90da9235549605af35/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f2d676974687562616374696f6e732d4646464646462e7376673f6c6f676f3d6769746875622d616374696f6e73267374796c653d666f722d7468652d6261646765">
<img src="https://camo.qiitausercontent.com/07d5685b5d939aa1426673c1bab1a41895543caa/68747470733a2f2f696d672e736869656c64732e696f2f62616467652f2d415753253230666172676174652d3233324633452e7376673f6c6f676f3d6177732d66617267617465267374796c653d666f722d7468652d6261646765">

## 目次
1. [プロジェクトについて](#プロジェクトについて)
2. [環境](#環境)
3. [ディレクトリ構成](#ディレクトリ構成)
4. [開発環境構築](#開発環境構築)
## プロジェクト名
aws-ecs-environment
## プロジェクトについて
ECSで以下の技術を試したサンプルです。Spring BootのAPIが`Hello AWS`を返します
- Blue/Greenデプロイ
- Github Actionsを使った標準デプロイ
- ECS AutoScaling
## GitHub Actionsを使った標準デプロイ
### 構成図
<li>infraMapを使って出力しました</li>
<image alt=inframap src=inframap_generate.png>

## 環境
- Terraform
```bash
$ terraform version
Terraform v1.5.0
on darwin_amd64
```

## ディレクトリ構成
```bash
.
├── Dockerfile
├── Makefile
├── README.md
├── cicd-section
│   └── api
│       ├── Dockerfile
│       ├── Makefile
│       ├── build.gradle
│       ├── gradle
│       │   └── wrapper
│       │       ├── gradle-wrapper.jar
│       │       └── gradle-wrapper.properties
│       ├── gradlew
│       ├── gradlew.bat
│       ├── settings.gradle
│       └── src
│           ├── main
│           │   ├── java
│           │   │   └── com
│           │   │       └── example
│           │   │           └── myapp
│           │   │               ├── MyAppApplication.java
│           │   │               └── controller
│           │   │                   └── HelloController.java
│           │   └── resources
│           │       └── application.properties
│           └── test
│               └── java
│                   └── com
│                       └── example
│                           └── myapp
│                               ├── MyAppApplicationTests.java
│                               └── controller
│                                   └── HelloControllerTests.java
├── codebuild
│   ├── buildspec_apply.yml
│   ├── buildspec_plan.yml
│   └── tfnotify.yml
├── environments
│   ├── alb.tf
│   ├── code_deploy.tf
│   ├── ecr.tf
│   ├── ecs.tf
│   ├── iam.tf
│   ├── network.tf
│   ├── provider.tf
│   ├── security_group.tf
│   ├── terraform.tfstate
│   ├── terraform.tfstate.backup
│   └── terraform.tfvars
├── graph.png
├── html
│   └── index.html
├── inframap_generate.png
└── nginx.conf

```
## 開発環境構築
- Terraformでリソース作成
```bash
$ make apply
```
- Terraformで作成したリソース削除
```bash
$ make destroy
```
