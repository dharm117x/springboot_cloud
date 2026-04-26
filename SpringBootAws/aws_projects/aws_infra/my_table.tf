resource "aws_dynamodb_table" "table" {
    name           = "${var.my-env}-my-table"
    billing_mode   = "PAY_PER_REQUEST"
    hash_key       = "id"
    
    attribute {
        name = "id"
        type = "S"
    }
    
    tags = {
        Name        = "${var.my-env}-my-table"
        Environment = var.my-env
    }
}