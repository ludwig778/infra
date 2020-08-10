#!/bin/bash

. ./config

if [ -z "$INFRA_TLS_LOCKER_PASSWORD" ]
then
	echo "\$INFRA_TLS_LOCKER_PASSWORD is not set"
	exit 1
fi

echo $INFRA_TLS_LOCKER_PASSWORD | gpg \
	--batch \
	--yes \
	--passphrase-fd 0 \
	--output $CERTBOT_ARCHIVE \
	--decrypt $CERTBOT_ENCRYPTED_ARCHIVE

if [ $? -ne 0 ]
then
	echo "Error when decrypting $CERTBOT_DIR tarball"
	exit 2
fi

if ! tar -zxvf $CERTBOT_ARCHIVE 1>/dev/null
then
	echo "Error when untar'ing' $CERTBOT_DIR"
	exit 3
fi

rm $CERTBOT_ARCHIVE

echo "Successfully unlocked certs"
