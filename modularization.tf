module/ec2_instance/main.tf 

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

module/ec2_instance/variables.tf

variable "ami_value"{
    description="this is regarding amazon machine image ID"
    type=string
}

variable "instance_type"{
    description="this is regarding amazon machine type"
    type=string
}

variable "instance_name"{
    description="this is regarding amazon name"
    type=string
}

module/ec2_instance/output.tf
output "instance_public_IP" {
    description = "This is regarding the public IP address"
    value = aws_instance.instance_server.public_ip
}



///main.tf
provider "aws"{
    region = "us-east-1"
}

variable "ami_value"{
    description="this is regarding amazon machine image ID"
    type=string
}

variable "instance_type"{
    description="this is regarding amazon machine type"
    type=string
}

variable "instance_name"{
    description="this is regarding amazon name"
    type=string
}

module "ec2_instance"{
    source = "./modules/ec2_instance"
    ami_value = var.ami_value
    instance_type = var.instance_type
    instance_name = var.instance_name
}


//terraform.tfvars
ami_value="ami-04b4f1a9cf54c11d0"
instance_type="t2.micro"
instance_name="kaustubh2_terraform"
