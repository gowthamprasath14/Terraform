provider "aws" {
  region = "ap-south-1"
  profile = "gowtham_14"
}
resource "aws_instance" "ec2_instance" {
  ami           = "ami-01b6d88af12965bb6"
  instance_type = "t2.micro"
}


resource "aws_s3_bucket" "s3_bucket" {
  bucket = "gowtham123bucket"
}

resource "aws_dynamodb_table" "dynamodb_table" {
  name         = "terraform-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
  
