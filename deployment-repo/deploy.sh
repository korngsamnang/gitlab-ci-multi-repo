#!/bin/bash
set -e

scp -o StrictHostKeyChecking=no -i "$SSH_PRIVATE_KEY" \
  docker-compose.yml \
  nginx/nginx.conf \
  ubuntu@13.229.251.210:"$PROJECT_DIR/"

ssh -o StrictHostKeyChecking=no -i "$SSH_PRIVATE_KEY" ubuntu@13.229.251.210 "
  set -e
  cd $PROJECT_DIR

  if [ -n \"$CI_REGISTRY_PASSWORD_APP1\" ] && [ -n \"$IMAGE_NAME_APP1\" ] && [ -n \"$IMAGE_TAG_APP1\" ]; then
    echo \"$CI_REGISTRY_PASSWORD_APP1\" | docker login -u \"$CI_REGISTRY_USER_APP1\" --password-stdin \"$CI_REGISTRY\" &&
    docker pull $IMAGE_NAME_APP1:$IMAGE_TAG_APP1 &&
    IMAGE_NAME_APP1=$IMAGE_NAME_APP1 IMAGE_TAG_APP1=$IMAGE_TAG_APP1 docker-compose up -d --no-deps app1 nginx
  fi

  if [ -n \"$CI_REGISTRY_PASSWORD_APP2\" ] && [ -n \"$IMAGE_NAME_APP2\" ] && [ -n \"$IMAGE_TAG_APP2\" ]; then
    echo \"$CI_REGISTRY_PASSWORD_APP2\" | docker login -u \"$CI_REGISTRY_USER_APP2\" --password-stdin \"$CI_REGISTRY\" &&
    docker pull $IMAGE_NAME_APP2:$IMAGE_TAG_APP2 &&
    IMAGE_NAME_APP2=$IMAGE_NAME_APP2 IMAGE_TAG_APP2=$IMAGE_TAG_APP2 docker-compose up -d --no-deps app2
  fi
"