SQS_SNS: By terraform:
-----------------------

terraform init: Initializes the directory by downloading the necessary AWS provider plugins.
terraform plan: Previews exactly what Terraform will create, change, or delete without actually making changes yet.
terraform apply: Executes the changes. You will be prompted to type yes to confirm the action
terraform destroy: Destroy all.

Terraform automatically "picks up" every .tf file 
terraform plan -target=aws_s3_bucket.my_bucket -out=tfplan
terraform apply tfplan
terraform destroy

Or better to put in specific fodler for each terraform file.

Terrform setup order:
----------------------
1. VPC
2. S3
3. rds
4. Sqs and sns
5. Cloudwatch
6. ECR
7. IAM (Above craeted firs becoz of policy attachment)
8. Ec2
7. Lambda

Ec2-connect on cmd
--------------------
ssh -i "C:\path\to\your-key.pem" ec2-user@<YOUR_INSTANCE_PUBLIC_IP>

scp -i "C:\path\to\your-key.pem" "C:\path\to\local-file.txt" ec2-user@<EC2-IP>:/home/ec2-user/

Debug log:
sudo cat /var/log/cloud-init-output.log

ECR:-coonect on cmd
------------------------
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin <AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com

docker build -t springboot-app .

docker tag springboot-app:latest <AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/my-ecr-repo:latest

docker push <AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/my-ecr-repo:latest

docker pull <AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/my-ecr-repo:latest

docker run -d -p 9001:9001 <AWS_ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/my-ecr-repo:latest

ARN: Explaination:
---------
arn:partition:service:region:account-id:resource

