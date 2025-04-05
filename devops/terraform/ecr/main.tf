resource "aws_ecr_repository" "service_repository" {
  name                 = "${var.environment_name}-${var.service_name}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(
    var.tags,
    tomap(
      {
        Name = "${var.environment_name}-${var.service_name}-ecr_repository"
      }
    )
  )

}

resource "aws_ecr_lifecycle_policy" "snapshot_policy" {
  repository = aws_ecr_repository.service_repository.name


  policy = <<EOF
{
  "rules": [
    {
      "action": {
        "type": "expire"
      },
      "selection": {
        "countType": "imageCountMoreThan",
        "countNumber": 10,
        "tagStatus": "tagged",
        "tagPrefixList": [
          "SNAPSHOT"
        ]
      },
      "description": "Only store 10 SNAPSHOTS",
      "rulePriority": 1
    }
  ]
}
EOF
}
