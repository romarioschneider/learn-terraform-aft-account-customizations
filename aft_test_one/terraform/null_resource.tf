resource "null_resource" "test_trigger_1" {
  provisioner "local-exec" {
    command = "echo null_resource test output #1"
  }
}