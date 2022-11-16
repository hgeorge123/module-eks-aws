resource "aws_kms_key" "kms-cluster" {
  description             = "EKS Cluster Encryption Config KMS Key"
  enable_key_rotation     = var.encryption_config["enable_key_rotation"]
  deletion_window_in_days = var.encryption_config["deletion_window_in_days"]
}

resource "aws_kms_alias" "kms-cluster-alias" {
  name          = var.encryption_config["key_alias"]
  target_key_id = aws_kms_key.kms-cluster.key_id
}