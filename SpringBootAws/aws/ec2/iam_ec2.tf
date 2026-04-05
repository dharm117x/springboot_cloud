# Look up the existing IAM Role
data "aws_iam_role" "existing_role" {
  name = "ec2-app-role"
}

# Create the Instance Profile (The "bridge" between the Role and EC2)
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-app-profile"
  role = data.aws_iam_role.existing_role.name 
}
