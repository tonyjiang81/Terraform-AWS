bucket         = "{{STATE_BUCKET}}"
key            = "{{PROJECT}}/{{ENV}}/{{STACK}}/terraform.tfstate"
region         = "{{AWS_REGION}}"
dynamodb_table = "{{LOCK_TABLE}}"
encrypt        = true
