# The standard endpoint (hostname:port)
output "rds_endpoint" {
  description = "The connection endpoint for the database"
  value       = aws_db_instance.mysql_single_az.endpoint
}

# The complete JDBC URL for Spring Boot
output "spring_jdbc_url" {
  description = "The full JDBC URL to be used as SPRING_DATASOURCE_URL"
  value       = "jdbc:mysql://${aws_db_instance.mysql_single_az.endpoint}/${aws_db_instance.mysql_single_az.db_name}"
}

# Optional: Hostname only (if you need it for other scripts)
output "rds_hostname" {
  description = "The hostname of the RDS instance"
  value       = aws_db_instance.mysql_single_az.address
}
