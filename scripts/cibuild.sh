#!/usr/bin/env bash
set -e

IMAGE_ARTIFACT=${REGISTRY}/${JOB_NAME}:${BUILD_NUMBER}-${GIT_SHORT_COMMIT}
PROJECT_DIR=$(pwd)

echo "IMAGE_ARTIFACT=$IMAGE_ARTIFACT"

docker build -t $IMAGE_ARTIFACT .

docker run -t --rm \
  -v $PROJECT_DIR/dist:/style-guide/dist \
  -v $PROJECT_DIR/src:/style-guide/src \
  -v $PROJECT_DIR/scripts:/style-guide/scripts \
  -v $PROJECT_DIR/package.json:/style-guide/package.json \
  -v $PROJECT_DIR/gulpfile.js:/style-guide/gulpfile.js \
  $IMAGE_ARTIFACT node_modules/.bin/gulp build --production --no-colors

docker push $IMAGE_ARTIFACT
