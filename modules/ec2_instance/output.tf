output "instance_pub_ip"{
    description="This is public IP of ec2 instance"
    value= aws_instance.example.public_ip
}