#!/bin/sh

DB_USER="${DB_USER:-fc2blog}"
DB_PASSWORD="${DB_PASSWORD:-fc2blog}"
DB_DATABASE="${DB_DATABASE:-fc2blog}"
PASSWORD_SALT="${PASSWORD_SALT:-fc2blog}"
HTTP_PORT="80"

DB_NAME="mysql"
WEB_NAME="apache"
WEB_INTERNAL_PORT="80"

CWD=`dirname $0`
DATE=`date +%Y%m%d%H%M%S`
DB_TAG="fc2blog/${DB_NAME}:latest"
WEB_TAG="fc2blog/${WEB_NAME}:latest"
DB_INSTANCE_NAME="${DB_NAME}-${DATE}"
WEB_INSTANCE_NAME="${WEB_NAME}-${DATE}"

cat "${CWD}/${DB_NAME}/Dockerfile" | sed \
  -e "s/@DB_USER@/$DB_USER/" \
  -e "s/@DB_PASSWORD@/$DB_PASSWORD/" \
  -e "s/@DB_DATABASE@/$DB_DATABASE/" \
  | docker build --tag="${DB_TAG}" -
cat "${CWD}/${WEB_NAME}/Dockerfile" | sed \
  -e "s/@DB_USER@/$DB_USER/" \
  -e "s/@DB_PASSWORD@/$DB_PASSWORD/" \
  -e "s/@DB_DATABASE@/$DB_DATABASE/" \
  -e "s/@PASSWORD_SALT@/$PASSWORD_SALT/" \
  | docker build --tag="${WEB_TAG}" -
docker run --name="${DB_INSTANCE_NAME}" --detach "${DB_TAG}"
docker run --publish="${HTTP_PORT}:${WEB_INTERNAL_PORT}" --name="${WEB_INSTANCE_NAME}" --link="${DB_INSTANCE_NAME}:${DB_NAME}" --detach "${WEB_TAG}"

HOST_PORT=`docker port "${WEB_INSTANCE_NAME}" "${WEB_INTERNAL_PORT}"`
echo "http://${HOST_PORT}/admin/install.php"
