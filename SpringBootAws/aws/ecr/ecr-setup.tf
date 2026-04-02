provider "aws" {
  region = var.region
}

resource "aws_ecr_repository" "repo" {
  name = var.ecr_repo_name
}

resource "aws_iam_policy" "ecr_policy" {
  name   = "ecr-read-write-policy"
  policy = templatefile("${path.module}/policies/ecr-read-write-policy.json", { ecr_arn = var.ecr_repo_arn})
}

data "aws_iam_role" "existing_role" {
  name = "ec2-app-role"
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "attach" {
  role       = data.aws_iam_role.existing_role.name
  policy_arn = aws_iam_policy.ecr_policy.arn
}
