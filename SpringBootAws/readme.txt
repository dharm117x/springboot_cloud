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


Ec2-connect on cmd
--------------------
ssh -i "C:\path\to\your-key.pem" ec2-user@<YOUR_INSTANCE_PUBLIC_IP>

scp -i "C:\path\to\your-key.pem" "C:\path\to\local-file.txt" ec2-user@<EC2-IP>:/home/ec2-user/

Debug log:
sudo cat /var/log/cloud-init-output.log

-
ARN: Explaination:
---------
arn:partition:service:region:account-id:resource

arn:aws:logs:us-east-1:ACC_NO:log-group:/aws/ec2/my-ec2-logsN

log-group
👉 Type of resource
CloudWatch has:

log-group
log-stream

/aws/ec2/my-ec2-logs

👉 Log group name
This is just a string name, often following AWS conventions:

Prefix	Meaning
/aws/ec2/	Logs related to EC2
/aws/lambda/	Lambda logs
custom-name	Your own naming
