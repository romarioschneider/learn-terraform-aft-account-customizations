resource "null_resource" "test_trigger" {
  provisioner "local-exec" {
    command = "echo null_resource test output"
  }
}