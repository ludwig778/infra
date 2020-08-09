#!/bin/bash

. ./config

if [ -z "$INFRA_TLS_LOCKER_PASSWORD" ]
then
	echo "\$INFRA_TLS_LOCKER_PASSWORD is not set"
	exit 1
fi

echo $INFRA_TLS_LOCKER_PASSWORD | gpg --batch --yes --passphrase-fd 0 $CERTBOT_TARBALL_NAME.gpg 1>/dev/null

if [ $? -ne 0 ]
then
	echo "Error when decrypting $CERTBOT_DIR_NAME tarball"
	exit 1
fi

if ! tar -zxvf $CERTBOT_TARBALL_NAME 1>/dev/null
then
	echo "Error when untar'ing' $CERTBOT_DIR_NAME"
	exit 2
fi

rm $CERTBOT_TARBALL_NAME

echo "Successfully unlocked certs"
