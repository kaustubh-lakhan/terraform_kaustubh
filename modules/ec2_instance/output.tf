output "instance_public_IP" {
    description = "This is regarding the public IP address"
    value = aws_instance.instance_server.public_ip
}
