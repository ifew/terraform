# data "archive_file" "zipfile" {
#   type        = "zip"
#   source_dir  = "project_workspace/src/aws-lambda-function/bin/Release/netcoreapp2.1/publish"
#   output_path = "project_workspace/deployment.zip"
# }

resource "null_resource" "git_pull" {
  provisioner "local-exec" {
    command = "git clone https://github.com/ifew/aws-lambda-function.git project_workspace"
  } 
  provisioner "local-exec" {
    command = "cd project_workspace/test/aws-lambda-function.Tests && dotnet test"
    interpreter = ["/bin/sh", "-c"]
  } 

  provisioner "local-exec" {
    command = "cd project_workspace/src/aws-lambda-function && dotnet publish -c Release"
    interpreter = ["/bin/sh", "-c"]
  }

  provisioner "local-exec" {
    command = "cd project_workspace/src/aws-lambda-function/bin/Release/netcoreapp2.1/publish && zip ../../../../../../deployment.zip *.*"
    interpreter = ["/bin/sh", "-c"]
  }
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
  depends_on        = ["null_resource.git_pull"]
  filename          = "project_workspace/deployment.zip"
  function_name     = "sample-function-deploy"
  role              = "${var.role}"
  handler           = "aws-lambda-function::aws_lambda_function.Function::FunctionHandler"
  runtime           = "dotnetcore2.1"
  memory_size       = 256
  timeout           = 60
}