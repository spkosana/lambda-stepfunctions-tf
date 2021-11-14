// Create IAM role for AWS Lambda
resource "aws_iam_role" "iam_for_lambda" {
  name = "TerraformLambdaFunction"

  assume_role_policy = <<-EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
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


# Create IAM role for AWS Step Function
resource "aws_iam_role" "iam_for_sfn" {
  name = "TerraformStepFunction"

  assume_role_policy = <<-EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "states.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


resource "aws_iam_role" "iam_for_events" {
  name = "TerraformCloudWatch"

  assume_role_policy = <<-EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "iam_for_events_attach_invoke_state_machine_sns" {
  role       = aws_iam_role.iam_for_events.name
  policy_arn = aws_iam_policy.invoke_state_machine.arn
}


resource "aws_iam_policy" "invoke_state_machine" {
  name = "CloudWatchStateMachineInvocation"

  policy = <<-EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor11",
            "Effect": "Allow",
            "Action": [
                "states:StartExecution" 
            ],
            "Resource": "*"
        }
    ]
}
EOF
}


// Create IAM role for AWS Step Function to invoke SNS 
resource "aws_iam_policy" "policy_publish_sns" {
  name = "TerraformSnsPublishPolicy"

  policy = <<-EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
              "sns:*"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "iam_for_sfn_attach_policy_publish_sns" {
  role       = aws_iam_role.iam_for_sfn.name
  policy_arn = aws_iam_policy.policy_publish_sns.arn
}

resource "aws_iam_policy" "policy_invoke_lambda" {
  name = "StepFunctionLambdaFunctionInvocationPolicy"

  policy = <<-EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "lambda:InvokeFunction",
                "lambda:InvokeAsync"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}



// Attach policy to IAM Role for Step Function
resource "aws_iam_role_policy_attachment" "iam_for_sfn_attach_policy_invoke_lambda" {
  role       = aws_iam_role.iam_for_sfn.name
  policy_arn = aws_iam_policy.policy_invoke_lambda.arn
}
