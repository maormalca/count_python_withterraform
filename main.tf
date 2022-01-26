provider "aws" {
  access_key = "AKIA4QDUZQ7LHAVX6KFN"
  secret_key = "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"
  region     = "us-east-2"
}

resource "aws_instance" "exsample" {
  ami           = "ami-001089eb624938d9f"
  instance_type = "t2.micro"
  key_name= "aws_key"
  vpc_security_group_ids = [aws_security_group.allow_8080.id]

provisioner "remote-exec" {
    inline = [
      "touch hello.txt",
      "echo helloworld remote provisioner >> hello.txt",
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

