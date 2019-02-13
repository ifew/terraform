variable "profile" {
  default   = "default"
}

variable "role" {
  default   = "arn:aws:iam::819684245502:role/service-role/MyRole"
}

variable "region" {
  default   = "ap-southeast-1"
}

provider "aws" {
  region     = "${var.region}"
  profile    = "${var.profile}"
}

resource "aws_lambda_function" "lambda" {
  filename          = "project_workspace/deployment.zip"
  source_code_hash  = "${base64sha256(file("project_workspace/deployment.zip"))}"
  function_name     = "sample-function-deploy"
  role              = "${var.role}"
  handler           = "aws-lambda-function::aws_lambda_function.Function::FunctionHandler"
  runtime           = "dotnetcore2.1"
  memory_size       = 256
  timeout           = 60
  publish           = true
}