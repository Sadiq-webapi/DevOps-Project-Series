provider "aws" {
    region = "ap-south-2"
    access_key = ""
    secret_key = "" 
}


resource "aws_instance" "admin" {
    ami = "ami-0aa31b568c1e8d622"
    instance_type = "t3.micro"
    security_groups = [ "default" ]
    key_name = "jenkins"
    root_block_device {
      volume_size = 20
      volume_type = "gp3"
      delete_on_termination = true
    }
    tags = {
        Name = "server"
    }
    user_data = file("samplescript.sh")
}


output "PublicIP" {
  value = aws_instance.admin.public_ip
}
