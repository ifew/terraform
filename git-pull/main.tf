resource "null_resource" "git_pull" {
  provisioner "local-exec" {
    command = "git clone https://github.com/ifew/aws-lambda-function.git project_workspace"
  } 
}