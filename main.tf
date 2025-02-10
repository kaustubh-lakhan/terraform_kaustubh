provider "aws"{
    region="us-east-1"
}

module "ec2_instance"{
    source= "./modules/ec2_instance"    
    ami_value=var.ami_id   
    instance_type=var.aws_instance
}