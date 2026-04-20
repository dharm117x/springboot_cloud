# springboot_cloud
Push to repositray: WIthout docker
mvn compile jib:build

# Terraform 
terraform plan
terraform apply
terraform destroy

# Mysql cliet setup on ec2 and connection:

sudo dnf update -y
sudo dnf install mariadb105 -y

mysql -h mysql-single-az-db.*************.us-east-1.rds.amazonaws.com -P 3306 -u admin -p

create database aws_db;
show databases
use aws_db;
show tables;
select * from flyway_schema_history