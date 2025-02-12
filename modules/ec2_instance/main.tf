provider "aws"{
    region ="us-east-1"
}

resource "aws_instance" "instance_server"{
    ami=var.ami_value
    instance_type = var.instance_type
    tags ={
        Name= var.instance_name
    }
}
