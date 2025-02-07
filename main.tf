provider "aws" {
    region : "us-east-1"
}

resource "aws_instance" "terraformPractical" {
  ami           = "ami-04b4f1a9cf54c11d0"
  instance_type = "t2.micro"
  name = "terraform1"
  tags = {
    Name = "HelloWorld"
  }
}