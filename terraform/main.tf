provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "customer_backups" {
  bucket = "payliteng-customer-backups-2025"
}

resource "aws_s3_bucket_public_access_block" "customer_backups" {
  bucket                  = aws_s3_bucket.customer_backups.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_acl" "backup_acl" {
  bucket = aws_s3_bucket.customer_backups.id
  acl    = "private"
}

resource "aws_db_instance" "paylite_db" {
  identifier           = "paylite-production"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  username             = "admin"
  password             = var.db_password
  publicly_accessible  = false
  skip_final_snapshot  = true
  storage_encrypted    = true
  deletion_protection  = true
}

variable "db_password" {
  type      = string
  sensitive = true
}

resource "aws_instance" "web_server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name      = "payliteng-keypair"
}

resource "aws_security_group" "web_sg" {
  name = "payliteng-web-sg"

  ingress {
    description = "Allow HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow HTTPS out"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_cloudtrail" "audit_log" {
  name                          = "payliteng-audit"
  s3_bucket_name                = aws_s3_bucket.customer_backups.id
  include_global_service_events = true
  enable_log_file_validation    = true
}
