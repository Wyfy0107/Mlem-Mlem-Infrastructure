resource "aws_iam_role" "mlem-mlem" {
  name = "mlem-mlem-server-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name = "mlem-mlem-server-role"
  }
}

resource "aws_iam_role_policy" "mlem-mlem" {
  name = "mlem-mlem-policy"
  role = aws_iam_role.mlem-mlem.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:CreateBucket",
          "s3:PutBucketWebsite",
          "s3:PutObject",
          "s3:PutBucketPolicy",
          "s3:GetObject",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "cloudfront:CreateDistribution",
          "cloudfront:CreateInvalidation",
          "cloudfront:CreateCloudFrontOriginAccessIdentity",
          "cloudfront:GetDistribution",
        ],
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "route53:ChangeResourceRecordSets",
          "route53:ListHostedZones",
          "route53:GetChange",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}
