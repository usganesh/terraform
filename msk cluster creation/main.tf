provider "aws" {
  region = var.aws_region
}

resource "aws_kms_key" "msk_key" {
  description = "Encription key for kafka cluster"
}
resource "aws_s3_bucket" "bucket" {
  bucket = "${lower(var.env)}-${lower(var.platform)}-${lower(var.s3_name)}"
  acl    = "private"
}
resource "aws_cloudwatch_log_group" "msk_log" {
  name = "${var.env}_${var.platform}_${var.cloudwatch_name}"
}
resource "aws_iam_role" "firehose_role" {
  name = "${var.env}_${var.platform}_${var.firehose_role}"

  assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
  {
    "Action": "sts:AssumeRole",
    "Principal": {
      "Service": "firehose.amazonaws.com"
    },
    "Effect": "Allow",
    "Sid": ""
  }
  ]
}
EOF
}

resource "aws_kinesis_firehose_delivery_stream" "msk_stream" {
  name        = "${var.env}_${var.platform}_${var.msk_stream_name}"
  destination = "s3"

  s3_configuration {
    role_arn   = "${aws_iam_role.firehose_role.arn}"
    bucket_arn = "${aws_s3_bucket.bucket.arn}"
  }

  tags = {
     platformName = var.platform
     productName = "Product-infrastructure"
     environment = var.env
     APP = var.app
     Name = "MSK-cluster-test"
     Project = "Project"
  }
  lifecycle {
    ignore_changes = [
      tags["APP"],
    ]
  }
}
resource "aws_msk_cluster" "msk_cluster" {
  cluster_name           = "${var.env}-${var.platform}-${var.clust_name}"
  kafka_version          = var.clust_ver
  number_of_broker_nodes = var.broker_number

  broker_node_group_info {
    instance_type   = var.instance_size
    ebs_volume_size = var.ebs_size
    client_subnets = [
      var.subnet1,
      var.subnet2,
      var.subnet3,
    ]
    security_groups = [var.sec_group]
  }

  encryption_info {
    encryption_at_rest_kms_key_arn = "${aws_kms_key.msk_key.arn}"
  }

  open_monitoring {
    prometheus {
      jmx_exporter {
        enabled_in_broker = true
      }
      node_exporter {
        enabled_in_broker = true
      }
    }
  }

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = true
        log_group = "${aws_cloudwatch_log_group.msk_log.name}"
      }
      firehose {
        enabled         = true
        delivery_stream = "${aws_kinesis_firehose_delivery_stream.msk_stream.name}"
      }
      s3 {
        enabled = true
        bucket  = "${aws_s3_bucket.bucket.id}"
        prefix  = "logs/${var.env}_${var.platform}_${var.clust_name}-"
      }
    }
  }

  tags = {
     platformName = var.platform
     productName = Product-infrastructure"
     environment = var.env
     APP = var.app
     Name = "MSK-cluster-test"
     Project = "Project-Name"
  }
}
