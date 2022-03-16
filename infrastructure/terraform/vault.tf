resource "aws_iam_user" "vault" {
  name = "vault"
}

resource "aws_iam_access_key" "vault" {
  user = aws_iam_user.vault.name
}

resource "aws_iam_user_policy" "vault" {
  name = "vault"
  user = aws_iam_user.vault.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowAssumeOrganizationAccountRole",
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Resource": ["${aws_iam_role.cluster.arn}"]
    },
    {
      "Effect": "Allow",
      "Action": [
        "iam:AttachUserPolicy",
        "iam:CreateAccessKey",
        "iam:CreateUser",
        "iam:DeleteAccessKey",
        "iam:DeleteUser",
        "iam:DeleteUserPolicy",
        "iam:DetachUserPolicy",
        "iam:ListAccessKeys",
        "iam:ListAttachedUserPolicies",
        "iam:ListGroupsForUser",
        "iam:ListUserPolicies",
        "iam:PutUserPolicy",
        "iam:AddUserToGroup",
        "iam:RemoveUserFromGroup"
      ],
      "Resource": ["${aws_iam_user.vault.arn}"]
    }
  ]
}
EOF
}