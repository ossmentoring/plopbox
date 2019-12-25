#!/bin/bash

echo root > keycloak.user.passwd
openssl rand -base64 32 > keycloak.passwd

if [[ -z "$C" ]]; then
    echo -n "C: "; read C
fi

if [[ -z "$CN" ]]; then
    echo -n "CN: "; read CN
fi

echo "C='$C' ST='$ST' L='$L' O='$O' CN='$CN'"


mkdir -p certs
openssl genrsa -out certs/tls.key 3072
openssl req -new -x509 -days 730 \
        -subj "/C=$C/CN=$CN" \
        -addext "subjectAltName = IP.1:$CN" \
        -addext "certificatePolicies = 1.2.3.4" \
        -key certs/tls.key -sha256 -out certs/tls.crt
openssl x509 -in certs/tls.crt -text -noout
