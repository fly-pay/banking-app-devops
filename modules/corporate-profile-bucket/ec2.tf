

resource "aws_instance" "nextjs_app" {
  ami           = "ami-08d59269edddde222" # Ubuntu
  instance_type = "t2.micro"

  security_groups = [aws_security_group.nextjs_sg.name]


  user_data = <<-EOF
    #!/bin/bash
    set -e

    # Install dependencies as root
    sudo apt update -y
    sudo apt install -y git curl

    sudo curl -fsSL https://deb.nodesource.com/setup_20.x | sudo bash -
    sudo apt install -y nodejs
    node -v
    npm -v
    sudo npm install -g pnpm@latest
    sudo npm install -g pm2@latest

    # create swap memory (VERY IMPORTANT)
    sudo fallocate -l 2G /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile

    cd /home/ubuntu

    git clone https://github.com/haymannko/corporate-frontend-test.git
    cd corporate-frontend-test

    pnpm install
    pnpm build

    pm2 start "pnpm exec next start -H 0.0.0.0 -p 3160" --name nextjs-app
    pm2 save
    

    EOF



  tags = {
    Name = "nextjs-app-test"
  }
}

resource "aws_security_group" "nextjs_sg" {
  name = "nextjs-sg"

  ingress {
    from_port   = 3160
    to_port     = 3160
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
