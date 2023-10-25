# GoのECRリポジトリ
resource "aws_ecr_repository" "go_ecr_repository" {
  name                 = "${local.app}-go"
  image_tag_mutability = "IMMUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "go_ecr_lifecycle_policy" {
  repository = aws_ecr_repository.go_ecr_repository.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last 30 images for Go",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": 30
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}

# Next.jsのECRリポジトリ
resource "aws_ecr_repository" "nextjs_ecr_repository" {
  name                 = "${local.app}-nextjs"
  image_tag_mutability = "IMMUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "nextjs_ecr_lifecycle_policy" {
  repository = aws_ecr_repository.nextjs_ecr_repository.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep last 30 images for Next.js",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": 30
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}