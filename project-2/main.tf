provider "aws" {
  region = "ap-south-2"
}

resource "aws_s3_bucket" "mybucket" {
  bucket = "devops-project-s3-2026"
}
