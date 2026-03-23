SQS_SNS: By terraform:
------------------------
Terraform automatically "picks up" every .tf file 
or specific:
terraform plan -out=tfplan sns-sqs-setup.tf
terraform apply tfplan


terraform init: Initializes the directory by downloading the necessary AWS provider plugins.
terraform plan: Previews exactly what Terraform will create, change, or delete without actually making changes yet.
terraform apply: Executes the changes. You will be prompted to type yes to confirm the action

terraform destroy: Destroy all.



SNS-SQS: By Simple comand
----------------------------
Step 1: Create an SQS Queue:
aws sqs

aws sqs list-queues

aws sqs create-queue --queue-name my-payment-queue
aws sqs purge-queue --queue-url https://sqs.us-east-1.amazonaws.com/AWS_ACC_NO/my-payment-queue


Step 2: Get the Queue ARN:
aws sqs get-queue-attributes --queue-url https://sqs.us-east-1.amazonaws.com/AWS_ACC_NO/my-order-queue --attribute-names QueueArn
aws sqs get-queue-attributes --queue-url https://sqs.us-east-1.amazonaws.com/AWS_ACC_NO/my-user-queue --attribute-names QueueArn
    
"QueueArn": "arn:aws:sqs:us-east-1:AWS_ACC_NO:my-order-queue"
    

Step 4: Crate topic:
-------------------------
aws sns list-topics
aws sns create-topic --name my-topic
aws sns publish --topic-arn:aws:sns:us-east-1:AWS_ACC_NO:my-topic --message "Hello from SNS"

"TopicArn": "arn:aws:sns:us-east-1:AWS_ACC_NO:my-topic"



Step 5: Subscribe Queue to SNS Topic:
aws sns subscribe --topic-arn arn:aws:sns:us-east-1:AWS_ACC_NO:my-topic --protocol sqs --notification-endpoint arn:aws:sqs:us-east-1:AWS_ACC_NO:my-order-queue
SubscriptionArn": "arn:aws:sns:us-east-1:AWS_ACC_NO:my-topic:5e9cb900-148a-4b0d-b28d-0f764c729528

aws sns subscribe --topic-arn arn:aws:sns:us-east-1:AWS_ACC_NO:my-topic --protocol sqs --notification-endpoint arn:aws:sqs:us-east-1:AWS_ACC_NO:my-user-queue
SubscriptionArn": "arn:aws:sns:us-east-1:AWS_ACC_NO:my-topic:ac45231c-dff7-4549-9cc1-58d213cbc31a


Step 4: Attach Filter Policy to Subscription:  
aws sns set-subscription-attributes --subscription-arn arn:aws:sns:us-east-1:AWS_ACC_NO:my-topic:5e9cb900-148a-4b0d-b28d-0f764c729528 --attribute-name FilterPolicy --attribute-value "{\"eventType\": [\"OrderType\"]}"
  
aws sns set-subscription-attributes --subscription-arn arn:aws:sns:us-east-1:AWS_ACC_NO:my-topic:ac45231c-dff7-4549-9cc1-58d213cbc31a --attribute-name FilterPolicy --attribute-value "{\"eventType\": [\"UserType\"]}"
  
aws sns get-subscription-attributes --subscription-arn arn:aws:sns:us-east-1:AWS_ACC_NO:my-topic:ac45231c-dff7-4549-9cc1-58d213cbc31a


Recive message by cmd:
------------------------
aws sqs receive-message --queue-url https://sqs.us-east-1.amazonaws.com/AWS_ACC_NO/my-user-queue --message-attribute-names All

  

Delete SNS SQS
---------------------
aws sns delete-topic --topic-arn arn:aws:sns:us-east-1:AWS_ACC_NO:my-topic

aws sqs delete-queue --queue-url https://sqs.us-east-1.amazonaws.com/AWS_ACC_NO/my-order-queue
aws sqs delete-queue --queue-url https://sqs.us-east-1.amazonaws.com/AWS_ACC_NO/my-user-queue

S3:  dk.static.site - us-east-1
----------------------
aws s3 ls

aws s3 mb s3://s3-java-pgm

aws s3api get-bucket-location --bucket s3-java-pgm

aws s3api create-bucket --bucket your-unique-bucket-name --region us-west-2 --create-bucket-configuration LocationConstraint=us-west-2

aws s3api put-bucket-policy --bucket s3-java-pgm --policy file://s3_policy.json


aws s3 rb s3://s3-java-pgm --force



-
