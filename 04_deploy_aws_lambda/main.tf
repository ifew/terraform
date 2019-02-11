data "archive_file" "zipfile" {
  type        = "zip"
  source_dir  = "project_workspace/src/aws-lambda-function/bin/Release/netcoreapp2.1/publish"
  output_path = "project_workspace/deployment.zip"
}

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
  source_code_hash  = "${data.archive_file.zipfile.output_base64sha256}"
  function_name     = "sample-function-deploy"
  role              = "${var.role}"
  handler           = "MyFunction::MyFunction.Function::FunctionHandler"
  runtime           = "dotnetcore2.1"
  memory_size       = 256
  timeout           = 60
}