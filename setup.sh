#!/bin/bash

echo root > keycloak.user.passwd
openssl rand -base64 32 > keycloak.passwd

if [[ -z "$C" ]]; then
    echo -n "C: "; read C
fi

if [[ -z "$ST" ]]; then
    echo -n "ST: "; read ST
fi

if [[ -z "$L" ]]; then
    echo -n "L: "; read L
 fi

if [[ -z "$O" ]]; then
    echo -n "O: "; read O
fi

if [[ -z "$CN" ]]; then
    echo -n "CN: "; read CN
fi

echo "C='$C' ST='$ST' L='$L' O='$O' CN='$CN'"

mkdir -p certs
openssl genrsa -out certs/tls.key 3072
openssl req \
	-new -x509 -key certs/tls.key -sha256 -out certs/tls.crt \
	-days 730 \
	-subj "/C=$C/ST=$ST/L=$L/O=$O/CN=$CN"
openssl x509 -in certs/tls.crt -text -noout
