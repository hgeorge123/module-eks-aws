# EKS Cluster Definition:
resource "aws_eks_cluster" "cluster" {
  name                      = "${var.name_prefix}-EKS-Cluster"
  version                   = var.cluster_version
  role_arn                  = var.use_external_role ? var.cluster_role_arn : aws_iam_role.cluster.arn
  enabled_cluster_log_types = var.cluster_log_type
  tags                      = { Name = "${var.name_prefix}-EKS-Cluster" }

  vpc_config {
    endpoint_public_access  = false
    endpoint_private_access = true
    subnet_ids              = var.private_subnet[*]
  }

  encryption_config {
    resources = ["secrets"]
    provider {
      key_arn = aws_kms_key.kms-cluster.arn
    }
  }
}

# EKS Log Group:
resource "aws_cloudwatch_log_group" "logs" {
  name              = lower("/aws/eks/${var.name_prefix}/eks_cluster")
  retention_in_days = var.logs_retention
  tags              = { Name = "${var.name_prefix}-EKS-Cluster" }
}

# Node Groups Definition:
resource "aws_eks_node_group" "node_groups" {
  for_each        = { for k, v in var.node_groups : k => v }
  cluster_name    = aws_eks_cluster.cluster.name
  node_group_name = each.value.name
  node_role_arn   = var.use_external_role ? var.node_role_arn : aws_iam_role.node.arn
  subnet_ids      = var.private_subnet[*]
  instance_types  = var.instance_type

  tags = { Name = "${each.value.name}" }

  scaling_config {
    desired_size = each.value.desired
    max_size     = each.value.max
    min_size     = each.value.min
  }

  # remote_access {
  #   ec2_ssh_key               = var.eks_nodes_key
  #   source_security_group_ids = []
  # }
}


### Addon
resource "aws_eks_addon" "vpc-cni" {
  cluster_name = aws_eks_cluster.cluster.name
  addon_name   = "vpc-cni"
}

resource "aws_eks_addon" "coredns" {
  cluster_name = aws_eks_cluster.cluster.name
  addon_name   = "coredns"
}

resource "aws_eks_addon" "kube-proxy" {
  cluster_name = aws_eks_cluster.cluster.name
  addon_name   = "kube-proxy"
}