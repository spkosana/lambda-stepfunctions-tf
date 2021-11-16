variable "region" {
  type = string
  description = "Aws region"
  default = "us-east-2"
}

variable "profile" {
  type = string
  description = "Aws profile"
  default = "terraform"
}


variable "runtime" {
  type        = string
  description = "Python run time"
  default     = "python3.8"
}


variable "sns_email_subscription_address_list" {
  type = list(string)
  description = "List of email addresses"
  default = ["email1@gmail.com", "email2@gmail.com"]
}

variable "sns_email_subscription_protocol" {
  type = string
  default = "email"
  description = "SNS subscription protocal"
}

variable "sns_subscription_email_address" {
  type = string
  description = "(optional) describe your variable"
}

variable "secondary_sns_subscription_email_address" {
  type = string
  description = "(optional) describe your variable"
}
