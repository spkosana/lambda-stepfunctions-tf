
// Create state machine for step function
resource "aws_sfn_state_machine" "sfn_state_machine" {
  name     = "terraform-state-machine"
  role_arn = aws_iam_role.iam_for_sfn.arn

  definition = <<EOF

{
    "Comment": "A Hello World example of the Amazon States Language using a Pass state",
    "StartAt": "pass-random-name",
    "States": {
        "pass-random-name": {
            "Type": "Task",
            "Resource": "${aws_lambda_function.pass-random-name-lambda.arn}",
            "Next": "calculate-length-name",
            "Comment": "Getting Random name from pass random name function",
            "ResultPath": "$"
        },
        "calculate-length-name": {
            "Comment": "Getting the name from the pass random function",
            "Type": "Task",
            "Resource": "${aws_lambda_function.calculate-length-name-lambda.arn}",
            "Next": "length-name-notification-type",
            "ResultPath": "$"
        },
        "length-name-notification-type": {
            "Type": "Choice",
            "Choices": [
                {
                    "Variable": "$.name_length",
                    "NumericGreaterThan": 10,
                    "Next": "send-email-notification"
                },
                {
                    "Variable": "$.name_length",
                    "NumericLessThanEquals": 10,
                    "Next": "send-secondary-notification"
                }
            ],
            "InputPath": "$",
            "OutputPath": "$"
        },
        "send-email-notification": {
            "Type": "Task",
            "Resource": "arn:aws:states:::sns:publish",
            "Parameters": {
                "Subject": "Message from Step Functions to email",
                "TopicArn": "${aws_sns_topic.email.arn}",
                "Message.$": "States.Format('Name generated in Lambda function is {} and length is {}.', $.name , $.name_length)"
            },
            "End": true,
            "InputPath": "$",
            "ResultPath": "$",
            "Comment": "Notification to email"
        },
        "send-secondary-notification": {
            "Type": "Task",
            "Resource": "arn:aws:states:::sns:publish",
            "Parameters": {
                "Subject": "Message sent from step function to secondary email!",
                "Message.$": "States.Format('Name generated in Lambda function is {} and length is {}.', $.name , $.name_length)",
                "TopicArn": "${aws_sns_topic.secondary-email.arn}"
            },
            "End": true
        }
    }
}
EOF

  depends_on = [aws_lambda_function.pass-random-name-lambda, aws_lambda_function.calculate-length-name-lambda]

}
