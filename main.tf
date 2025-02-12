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
