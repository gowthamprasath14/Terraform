terraform {
  backend "s3" {
    profile      = "gowtham_14"
    bucket       = "gowtham123bucket"
    key          = "state-file/terraform.tfstate"
    region       = "ap-south-1"
    encrypt      = true
    dynamodb_table = "terraform-lock"
  }
}
