output "db_instance_id" {
  value = aws_db_instance.this.id
}

output "db_endpoint" {
  value = aws_db_instance.this.address
}

output "db_port" {
  value = aws_db_instance.this.port
}

output "master_user_secret_hint" {
  description = "Password is managed in Terraform state; move to Secrets Manager in a follow-up stack for production."
  value       = "tfstate:random_password.master"
  sensitive   = true
}
