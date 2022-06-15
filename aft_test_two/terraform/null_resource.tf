provider "aws" {
  region = "eu-central-1"
}

resource "null_resource" "test_trigger_1" {
  provisioner "local-exec" {
    command = "echo null_resource test output 1"
  }
}

resource "aws_ssm_parameter" "test_ssm_param" {
  name  = "/test_param"
  type  = "String"
  value = "test_value"
}

resource "aws_ssm_parameter" "test_ssm_param_2" {
  name  = "/test_param_2"
  type  = "String"
  value = "test_value_2"
}
