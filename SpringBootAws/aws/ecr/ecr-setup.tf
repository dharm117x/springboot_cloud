provider "aws" {
  region = var.region
}

# 1. Create the Repository
resource "aws_ecr_repository" "repo" {
  name                 = var.ecr_repo_name
  
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }
  
  tags = {
    Environment = "dev"
    Project     = "my-app"
  }
}

# 2. Apply Lifecycle Policy (Self-contained, no attachment needed)
resource "aws_ecr_lifecycle_policy" "ecr_cleanup_policy" {
  repository = aws_ecr_repository.repo.name
  policy     = file("${path.module}/policies/ecr-lifecycle-policy.json")
}

# 3. Define IAM Policy for EC2 Access
resource "aws_iam_policy" "ecr_ec2_access_policy" {
  name        = "ecr-ec2-access-policy"
  description = "Policy for EC2 to push/pull from ECR"
  
  # Point to the repository ARN created above
  policy = templatefile("${path.module}/policies/ecr-ec2-access-policy.json", { 
    ecr_arn = aws_ecr_repository.repo.arn 
  })
}

# 4. Get Existing Role
data "aws_iam_role" "existing_role" {
  name = "ec2-app-role"
}

# 5. Attach the IAM Policy to the Role
resource "aws_iam_role_policy_attachment" "attach_ec2_access" {
  role       = data.aws_iam_role.existing_role.name
  policy_arn = aws_iam_policy.ecr_ec2_access_policy.arn
}
