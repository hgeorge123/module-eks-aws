data "aws_iam_policy_document" "ec2" {
  statement {
    sid    = "EC2AssumeRole"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "eks" {
  statement {
    sid    = "EKSAssumeRole"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "cluster" {
  name               = "${var.name_prefix}-EKS-Cluster-Role"
  assume_role_policy = data.aws_iam_policy_document.eks.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  ]
  tags = { Name = "${var.name_prefix}-EKS-Cluster-Role" }
}

resource "aws_iam_role" "node" {
  name               = "${var.name_prefix}-EKS-Node-Role"
  assume_role_policy = data.aws_iam_policy_document.ec2.json
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ]
  tags = { Name = "${var.name_prefix}-EKS-Cluster-Role" }
}