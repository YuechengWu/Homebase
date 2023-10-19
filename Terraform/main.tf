provider "aws" {
  region  = var.region
  access_key = "aws_access_key"
  secret_key = "aws_secret_key"
}

resource "aws_s3_bucket" "website" {
  bucket = var.bucket_name

  tags = {
    Name = "My Website"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_website_configuration" "website" {
  depends_on = [aws_s3_bucket.website]
  
  bucket = aws_s3_bucket.website.id
  
  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_ownership_controls" "website" {
  bucket = aws_s3_bucket.website.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "website" {
  depends_on = [aws_s3_bucket_ownership_controls.website, aws_s3_bucket_public_access_block.website]

  bucket = aws_s3_bucket.website.id
  acl    = "public-read"
}

variable "region" {
  description = "The AWS region where the S3 bucket will be created."
  type        = string
  default     = "us-east-1" # Default region, change as needed
}

variable "bucket_name" {
  description = "The name of the S3 bucket used for hosting the website."
  type        = string
}

output "bucket_name" {
  description = "The name of the created S3 bucket."
  value       = aws_s3_bucket.website.bucket
}

output "bucket_website_endpoint" {
  description = "The website endpoint URL of the S3 bucket."
  value       = aws_s3_bucket.website.website_endpoint
}
