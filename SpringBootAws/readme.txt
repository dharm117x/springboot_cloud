http://localhost:9001/aws/producer
{
"id":101,
"name":"Dharmendra",
"email": "dk@gmail.com",
"phone":"1234512345"
}


Create topic in AWS SNS
--------------------------
Then create subscription for the topic: mail, sms, http, https, topic, lambda

aws sns list-topics

aws sns publish --topic-arn:aws:sns:us-east-1:636851749624:my-topic --message "Hello from SNS"

curl -X POST "http://localhost:8080/sns/publish?message=HelloWorld"


SNS-SQS:
--------
Step 1: Create an SQS Queue:
aws sqs create-queue --queue-name LogisticsQueue
queue URL:
https://sqs.us-east-1.amazonaws.com/123456789012/LogisticsQueue

Step 2: Get the Queue ARN:
aws sqs get-queue-attributes \
  --queue-url https://sqs.us-east-1.amazonaws.com/123456789012/LogisticsQueue \
  --attribute-names QueueArn
    

Step 3: Subscribe Queue to SNS Topic:
aws sns subscribe \
  --topic-arn arn:aws:sns:us-east-1:123456789012:OrderEvents \
  --protocol sqs \
  --notification-endpoint arn:aws:sqs:us-east-1:123456789012:LogisticsQueue

Step 4: Attach Filter Policy to Subscription:  
aws sns set-subscription-attributes \
  --subscription-arn arn:aws:sns:us-east-1:123456789012:abcd1234-ef56-7890-gh12-ijkl3456mnop \
  --attribute-name FilterPolicy \
  --attribute-value '{"eventType": ["orderCreated"]}'  

Recive message by cmd:
------------------------
aws sqs receive-message \
  --queue-url https://sqs.us-east-1.amazonaws.com/123456789012/LogisticsQueue \
  --message-attribute-names All
  

S3:  dk.static.site 
------
aws s3 ls
aws s3api get-bucket-location --bucket dk.static.site


-
