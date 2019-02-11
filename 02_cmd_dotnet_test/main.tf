resource "null_resource" "git_pull" {
  provisioner "local-exec" {
    command = "git clone https://github.com/ifew/aws-lambda-function.git project_workspace"
  } 
    provisioner "local-exec" {
    command = "/bin/sh -c cd project_workspace/test/aws-lambda-function.Tests && dotnet test"
  } 
}