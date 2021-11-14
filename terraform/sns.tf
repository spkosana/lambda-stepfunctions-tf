

resource "aws_sns_topic" "email" {
    name = "email-notification" 
}

resource "aws_sns_topic_subscription" "email" {
    topic_arn = aws_sns_topic.email.arn
    protocol = "email"
    endpoint = var.sns_subscription_email_address
  
}

resource "aws_sns_topic" "secondary-email" {
    name = "secondary-email-notification"
  
}

resource "aws_sns_topic_subscription" "secondary-email" {
    topic_arn =aws_sns_topic.secondary-email.arn 
    protocol = "email"
    endpoint = var.secondary_sns_subscription_email_address
}