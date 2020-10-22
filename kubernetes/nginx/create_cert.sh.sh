#!/bin/bash

if [ -z "$1" ]; then
    echo "Missing name"
    echo "Usage: name secretname namespace host"
    exit
fi

if [ -z "$2" ]; then
    echo "Missing secret name"
    echo "Usage: name secretname namespace host"
    exit
fi

if [ -z "$3" ]; then
    echo "Missing namespace"
    echo "Usage: name secretname namespace host"
    exit
fi

if [ -z "$4" ]; then
    echo "Missing secret name"
    echo "Usage: name secretname namespace host"
    exit
fi

CERT_FOLDER=certs
KEY_FILE=${CERT_FOLDER}/${1}.key
CERT_FILE=${CERT_FOLDER}/${1}.crt
SECRET_NAME=${2}
NAMESPACE=${3}
HOST=${4}

echo "Generating Cert & Key"
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ${KEY_FILE} -out ${CERT_FILE} -subj "/CN=${HOST}/O=${HOST}"

echo "Creating secrets"
kubectl create secret tls ${SECRET_NAME} --key ${KEY_FILE} --cert ${CERT_FILE} -n ${NAMESPACE}