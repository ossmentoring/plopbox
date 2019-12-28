#!/bin/sh

echo "Min.io debugger"

mc config host add minio http://minio:9000 $(cat /run/secrets/access_key) $(cat /run/secrets/secret_key)
mc admin trace minio
