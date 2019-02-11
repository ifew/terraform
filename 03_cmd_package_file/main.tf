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
}

data "archive_file" "zipfile" {
  depends_on = ["null_resource.git_pull"]
  type        = "zip"
  source_dir = "project_workspace/src/aws-lambda-function/bin/Release/netcoreapp2.1/publish"
  output_path = "project_workspace/deployment.zip"
}