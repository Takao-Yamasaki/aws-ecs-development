// VPCの作成
resource "aws_vpc" "my-workspace-vpc" {
  cidr_block = "10.0.0.0/20"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "my-workspace-vpc"
  }
}

// プライベートサブネットの作成
resource "aws_subnet" "my-workspace-subnet-app-private1-a" {
  vpc_id = aws_vpc.my-workspace-vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = "my-workspace-subnet-app-private1-a"
  }
}

// パブリックサブネットの作成
resource "aws_subnet" "my-workspace-subnet-app-public1-a" {
  vpc_id = aws_vpc.my-workspace-vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = "my-workspace-subnet-app-public1-a"
  }
  map_public_ip_on_launch = true
}

// IGWの作成
resource "aws_internet_gateway" "my-workspace-igw" {
  vpc_id = aws_vpc.my-workspace-vpc.id
  tags = {
    Name = "my-workspace-igw"
  }
}

// プライベートルートテーブルの作成
resource "aws_route_table" "my-workspace-rtb-private1-a" {
  vpc_id = aws_vpc.my-workspace-vpc.id
  tags = {
    Name = "my-workspace-rtb-private1-a"
  }
}

// パブリックルートテーブルの作成
resource "aws_route_table" "my-workspace-rtb-public1-a" {
  vpc_id = aws_vpc.my-workspace-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my-workspace-igw.id
  }
  tags = {
    Name = "my-workspace-rtb-public1-a"
  }
}

// プライベートサブネットにルートテーブルを紐付け
resource "aws_route_table_association" "my-workspace-rt-assoc-private1-a" {
  subnet_id = aws_subnet.my-workspace-subnet-app-private1-a.id
  route_table_id = aws_route_table.my-workspace-rtb-private1-a.id
}

// パブリックサブネットにルートテーブルを紐付け
resource "aws_route_table_association" "my-workspace-rt-assoc-public1-a" {
  subnet_id = aws_subnet.my-workspace-subnet-app-public1-a.id
  route_table_id = aws_route_table.my-workspace-rtb-public1-a.id
}
