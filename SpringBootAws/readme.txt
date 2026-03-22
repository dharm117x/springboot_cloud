SNS-SQS:
--------
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

S3:  dk.static.site 
----------------------
aws s3 ls
aws s3api get-bucket-location --bucket dk.static.site



-
