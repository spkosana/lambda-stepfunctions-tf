
// Configurations for first lambda function

// Archiving first lambda call function
data "archive_file" "archive-pass-random-name" {
  type        = "zip"
  output_path = "../pass-random-name/archive.zip"
  source_file = "../pass-random-name/name.py"
}

// First Lambda call from step function
resource "aws_lambda_function" "pass-random-name-lambda" {
  filename      = "../pass-random-name/archive.zip"
  source_code_hash = data.archive_file.archive-pass-random-name.output_base64sha256
  function_name = "pass-random-name"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "name.handler"
  runtime       = var.runtime
  timeout       = 120
  memory_size   = 256
}


// Configurations for second lambda function

// Archiving second lambda call function

data "archive_file" "archive-calculate-length-name" {
  type        = "zip"
  output_path = "../calculate-length-name/archive.zip"
  source_file = "../calculate-length-name/length.py"
}

resource "aws_lambda_function" "calculate-length-name-lambda" {
  filename      = "../calculate-length-name/archive.zip"
  source_code_hash = data.archive_file.archive-calculate-length-name.output_base64sha256
  function_name = "calculate-length-name"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "length.handler"
  runtime       = var.runtime
  timeout       = 120
  memory_size   = 256
}




