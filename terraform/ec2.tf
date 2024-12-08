resource "aws_instance" "ec2_instance" {

  count = 1

  ami = "ami-05d2438ca66594916"
  instance_type = "${var.ec2_instance_spec}"

  subnet_id = module.vpc.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.terraform-ec2-sg.id]

  associate_public_ip_address = true

  # 키 페어는 사용하지 않으므로, 설정 안함

  tags = {
    Name = "${var.instance_name}'s server ${count.index}"
  }

  # 인스턴스가 시작될 때 실행할 사용자 데이터
  # 인스턴스가 시작될 때 실행되는 스크립트 코드
  user_data = <<-EOF
    #!/bin/bash
    sudo apt update -y
    sudo apt upgrade -y

    # Git 설치
    sudo apt install -y git nodejs npm

    # Git 리포지토리에서 코드 복제
    git clone https://github.com/junstory/24-2FullstackServiceProgramming.git
    cd 24-2FullstackServiceProgramming/nodeServer
    
    #npm
    npm i
    sudo npm i pm2 -g
    pm2 start ecosystem.config.cjs
  
    
  EOF
}

# IAM User 생성
resource "aws_iam_user" "for_each_set" {
  for_each = toset(var.user_names)
  name = each.key
}