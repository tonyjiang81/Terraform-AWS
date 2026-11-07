output "state_bucket" {
  value = aws_s3_bucket.state.bucket
}

output "lock_table" {
  value = aws_dynamodb_table.locks.name
}

output "backend_hcl_example" {
  value = <<-EOT
    bucket         = "${aws_s3_bucket.state.bucket}"
    key            = "${var.project}/<env>/<stack>/terraform.tfstate"
    region         = "${var.aws_region}"
    dynamodb_table = "${aws_dynamodb_table.locks.name}"
    encrypt        = true
  EOT
}
