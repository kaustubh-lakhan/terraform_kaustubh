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

# module "ec2_instance"{
# <<<<<<< feature
#     source= "./modules/ec2_instance"    
#     ami_value= var.ami_value   
#     instance_type= var.instance_type
# }


variable "ami_value"{
    description="this is regarding amazon machine image ID"
    type=string
}

variable "instance_type"{
    description="this is regarding instance type"
    type=string
}

variable "instance_name"{
    description="this is regarding instance name"
    type=string
}

output "instance_public_IP"{
    description= "this is instance instance_public_IP"
    value= 
}

provider "aws"{
    region = "us-east-1"
}

resource "aws_instance" {
  ami          = var.ami_value
  instance_type = var.instance_type

  tags = {
    Name = var.instance_name
  }
}


provider "aws"{
    region="us-east-1"
}

variable "ami_id"{
    description="this is regarding amazon machine image ID"
    type=string
}

variable "instance_type"{
    description="this is regarding instance type"
    type=string
}

variable "instance_name"{
    description="this is regarding instance name"
    type=string
}

module "ec_instance" "kaustubh2_terraform"{
    source="./modules/ec2_instance"
    ami_value=var.ami_id
    instance_type=var.instance_type
    instance_name=var.instance_name
}


ami_id="ami-04b4f1a9cf54c11d0"
instance_type="t2.micro"
instance_name="kaustubh2_terraform"

----------------------

    source = "./modules/ec2_instance"
    ami_value = var.ami_value
    instance_type = var.instance_type
    instance_name = var.instance_name
}
