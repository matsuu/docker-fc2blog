#!/bin/sh

set -e

DB_USER="${DB_USER:-fc2blog}"
DB_PASSWORD="${DB_PASSWORD:-fc2blog}"
DB_DATABASE="${DB_DATABASE:-fc2blog}"
PASSWORD_SALT="${PASSWORD_SALT:-fc2blog}"
OS="${OS:-centos}"

DB_NAME="mysql"
WEB_NAME="apache"
WEB_INTERNAL_PORT="80"

CWD=`dirname $0`
DATE=`date +%Y%m%d%H%M%S`
DB_TAG="fc2blog/${DB_NAME}"
WEB_TAG="fc2blog/${WEB_NAME}"
DB_INSTANCE_NAME="${DB_NAME}-${DATE}"
WEB_INSTANCE_NAME="${WEB_NAME}-${DATE}"

cat "${CWD}/${OS}/${DB_NAME}-stage1/Dockerfile" | sed \
  -e "s/@DB_USER@/$DB_USER/g" \
  -e "s/@DB_PASSWORD@/$DB_PASSWORD/g" \
  -e "s/@DB_DATABASE@/$DB_DATABASE/g" \
  | docker build --quiet --tag="${DB_TAG}:stage1" -
cat "${CWD}/${OS}/${DB_NAME}-stage2/Dockerfile" | sed \
  -e "s!@FROM@!${DB_TAG}:stage1!" \
  | docker build --quiet --tag="${DB_TAG}:stage2" -

cat "${CWD}/${OS}/${WEB_NAME}-stage1/Dockerfile" | sed \
  -e "s/@DB_USER@/$DB_USER/g" \
  -e "s/@DB_PASSWORD@/$DB_PASSWORD/g" \
  -e "s/@DB_DATABASE@/$DB_DATABASE/g" \
  -e "s/@PASSWORD_SALT@/$PASSWORD_SALT/g" \
  | docker build --quiet --tag="${WEB_TAG}:stage1" -
cat "${CWD}/${OS}/${WEB_NAME}-stage2/Dockerfile" | sed \
  -e "s!@FROM@!${WEB_TAG}:stage1!" \
  | docker build --quiet --tag="${WEB_TAG}:stage2" -

docker run --name="${DB_INSTANCE_NAME}" --detach "${DB_TAG}:stage2"
docker run --publish="${WEB_INTERNAL_PORT}" --name="${WEB_INSTANCE_NAME}" --link="${DB_INSTANCE_NAME}:${DB_NAME}" --detach "${WEB_TAG}:stage2"

HOST_PORT=`docker port "${WEB_INSTANCE_NAME}" "${WEB_INTERNAL_PORT}"`
echo "Access to http://${HOST_PORT}/admin/install.php and press enter key after installation..."
read
docker commit "${DB_INSTANCE_NAME}" "${DB_TAG}:stage3"
docker commit "${WEB_INSTANCE_NAME}" "${WEB_TAG}:stage3"
docker stop "${WEB_INSTANCE_NAME}" "${DB_INSTANCE_NAME}"
docker rm "${WEB_INSTANCE_NAME}" "${DB_INSTANCE_NAME}"

cat "${CWD}/${OS}/${DB_NAME}-stage2/Dockerfile" | sed \
  -e "s!@FROM@!${DB_TAG}:stage3!" \
  | docker build --quiet --tag="${DB_TAG}:latest" -
cat "${CWD}/${OS}/${WEB_NAME}-stage2/Dockerfile" | sed \
  -e "s!@FROM@!${WEB_TAG}:stage3!" \
  | docker build --quiet --tag="${WEB_TAG}:stage4" -
echo "FROM ${WEB_TAG}:stage4" | docker build --quiet --tag="${WEB_TAG}:latest" -

docker rmi ${DB_TAG}:stage1 ${DB_TAG}:stage2 ${DB_TAG}:stage3
docker rmi ${WEB_TAG}:stage1 ${WEB_TAG}:stage2 ${WEB_TAG}:stage3 ${WEB_TAG}:stage4

echo "docker run --name=fc2blog-${DB_NAME} --detach ${DB_TAG}"
echo "docker run --publish=80:${WEB_INTERNAL_PORT} --name=fc2blog-${WEB_NAME} --link=fc2blog-${DB_NAME}:${DB_NAME}" --detach "${WEB_TAG}"
