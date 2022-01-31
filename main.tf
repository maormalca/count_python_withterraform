provider "aws" {
  access_key = "your_access_key"
  secret_key = "your_secret_key"
  region     = "us-east-2"
}

resource "aws_instance" "maor" {
  ami           = "ami-001089eb624938d9f"
  instance_type = "t2.micro"
  key_name = "aws_key"
  vpc_security_group_ids = [aws_security_group.allow_8080.id]

provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install git -y",
      "sudo yum install docker -y",
      "git clone https://github.com/maormalca/count_python_withterraform.git",
      "cd count_python_withterraform",
      "docker build -t pythoncounter:1.0 .",
      "docker run -d -p 8080:8080 pythoncounter:1.0",
      "curl localhost:8080/count",

    ]
  }

connection{
      type        = "ssh"
      host        = self.public_ip
      user        = "ec2-user"
      private_key = file("/root/.ssh/id_rsa")
      timeout     = "20m"
}



}
resource "aws_security_group" "allow_8080" {
  name        = "allow_8080"
  description = "Allow 8080 inbound traffic"
  vpc_id      = "vpc-e4b8cf8f"

  ingress {
    description      = "allow_8080"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

ingress {
    description      = "allow_ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }


  tags = {
    Name = "allow_8080"
  }
}

