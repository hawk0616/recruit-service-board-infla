terraform {
  # Assumes s3 bucket and dynamo DB table already set up
  backend "s3" {
    bucket         = "tfstate-bucket-for-recruit-info-service"
    key            = "terraform.tfstate"
    region         = "ap-northeast-1"
    dynamodb_table = "recruit-info-service-tfstate"
    encrypt        = true
  }
}