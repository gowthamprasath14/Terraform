provider "aws" {
  region = "ap-south-1"
  profile = "gowtham_14"
}

resource "aws_instance" "example" {
  ami           = "ami-01b6d88af12965bb6"
  instance_type = "t2.micro"
}