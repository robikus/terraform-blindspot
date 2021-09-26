# Lambda source code needs to be zipped.
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "./lambda/my_lambda.py"
  output_path = "./lambda/my_lambda.zip"
}

resource "aws_lambda_function" "my_lambda" {
  filename      = data.archive_file.lambda_zip.output_path
  function_name = "my_lambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "my_lambda.lambda_handler"
  # using the zipped lambda hash to trigger an update if there are any changes
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime          = "python3.8"
  tags = {
    create_datetime = timestamp()
  }
  # Lambda operates in UTC by default
  environment {
    variables = {
      TZ = "Europe/Prague"
    }
  }
}

# basic Lambda's execution role
resource "aws_iam_role" "lambda_role" {
  name               = "basic_lambda_role"
  assume_role_policy = <<EOF
{
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": [
              "sts:AssumeRole"
          ],
          "Principal": {
            "Service": "lambda.amazonaws.com"
          },
          "Effect": "Allow",
          "Sid": ""
        }
      ]
}
EOF
}

# additional policies needed to work with S3 objects
resource "aws_iam_policy" "lambda_policies" {
  name        = "lambda_policies"
  description = "Policies for getting Lambda tags, interact with SQS"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBuckets",
                "s3:PutObject",
                "s3:PutObjectAcl",
                "s3:GetObjectAcl",
                "s3:DeleteObject"
            ],
            "Resource": [
                "*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attach_lambda_tags" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policies.arn
}
