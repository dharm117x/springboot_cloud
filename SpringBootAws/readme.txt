http://localhost:9001/aws/producer
{
"name":"Dharmendra",
"email": "dk@gmail.com",
"phone":"1234512345"
}

Create topic in AWS SNS

Then create subscription for the topic: mail, sms, http, https, topic, lambda

aws sns list-topics

aws sns publish --topic-arn:aws:sns:us-east-1:636851749624:my-topic --message "Hello from SNS"

curl -X POST "http://localhost:8080/sns/publish?message=HelloWorld"