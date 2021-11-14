resource "aws_cloudwatch_event_rule" "trigger_rule" {
  name                = "trigger_rule"
  schedule_expression = "rate(1 day)"
  description         = "Triggers statemachine every one minute"

}

resource "aws_cloudwatch_event_target" "trigger_rule_state_machine" {
  target_id = "trigger_state_machine"
  rule      = aws_cloudwatch_event_rule.trigger_rule.name
  arn       = aws_sfn_state_machine.sfn_state_machine.arn
  role_arn  = aws_iam_role.iam_for_events.arn
}

