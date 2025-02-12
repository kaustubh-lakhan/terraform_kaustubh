resource "aws_vpc" "kaustubh-tf" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "kaustubh-tf-subnet1" {
  vpc_id     = aws_vpc.kaustubh-tf.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "kaustubh-tf-subnet1"
  }
}

resource "aws_subnet" "kaustubh-tf-subnet2" {
  vpc_id     = aws_vpc.kaustubh-tf.id
  cidr_block = "10.0.1.0/24"
   availability_zone = "us-east-1b"
  tags = {
    Name = "kaustubh-tf-subnet2"
  }
}

resource "aws_internet_gateway" "igw-kaustubh" {
  vpc_id = aws_vpc.kaustubh-tf.id

  tags = {
    Name = "igw-kaustubh"
  }
}

resource "aws_route_table" "kaustubh-tf-rt" {
  vpc_id = aws_vpc.kaustubh-tf.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-kaustubh.id
  }

  tags = {
    Name = "kaustubh-tf-rt"
  }
}

resource "aws_route_table_association" "kaustubh-tf-sb1-ass" {
  subnet_id      = aws_subnet.kaustubh-tf-subnet1.id
  route_table_id = aws_route_table.kaustubh-tf-rt.id
}

resource "aws_route_table_association" "kaustubh-tf-sb2-ass" {
  subnet_id      = aws_subnet.kaustubh-tf-subnet2.id
  route_table_id = aws_route_table.kaustubh-tf-rt.id
}

resource "aws_default_security_group" "kaustubh-tf-sg" {
  vpc_id = aws_vpc.kaustubh-tf.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "SSH"
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
    
  tags = {
    Name = "kaustubh-tf-sg"
  }
}

resource "aws_s3_bucket" "kaustubh-tf-bucket" {
  bucket = "kaustubh-tf-bucket"
}

resource "aws_iam_role" "instance_to_s3_role" {
  name = "instance_to_s3_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.kaustubh-tf-bucket.id
  policy = data.aws_iam_policy_document.role-access-to s3.json
}

data "aws_iam_policy_document" "role-access-to s3" {
    {
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "AWS": aws_iam_role.instance_to_s3_role.arn
        },
        "Action": "s3:*",
        "Resource": [
            "arn:aws:s3:::aws_s3_bucket.kaustubh-tf-bucket",
            "arn:aws:s3:::aws_s3_bucket.kaustubh-tf-bucket/*"
        ]
        }
    ]
    }
}


resource "aws_instance" "webserver1" {
  ami                    = "ami-0261755bbcb8c4a84"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [kaustubh-tf-sg.id]
  subnet_id              = aws_subnet.kaustubh-tf-subnet1.id
  user_data              = base64encode(file("userdata.sh"))
}

resource "aws_instance" "webserver2" {
  ami                    = "ami-0261755bbcb8c4a84"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [kaustubh-tf-sg.id]
  subnet_id              = aws_subnet.kaustubh-tf-subnet2.id
  user_data              = base64encode(file("userdata1.sh"))
}

#create alb
resource "aws_lb" "myalb" {
  name               = "myalb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [aws_security_group.kaustubh-tf-sg.id]
  subnets         = [aws_subnet.sub1.id, kaustubh-tf-subnet2.id]

  tags = {
    Name = "web"
  }
}

resource "aws_lb_target_group" "tg" {
  name     = "myTG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.kaustubh-tf.id

  health_check {
    path = "/"
    port = "traffic-port"
  }
}

resource "aws_lb_target_group_attachment" "attach1" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.webserver1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "attach2" {
  target_group_arn = aws_lb_target_group.tg.arn
  target_id        = aws_instance.webserver2.id
  port             = 80
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.myalb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.tg.arn
    type             = "forward"
  }
}
