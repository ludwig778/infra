#!/bin/bash

. ./config

if [ -z "$INFRA_TLS_LOCKER_PASSWORD" ]
then
	echo "\$INFRA_TLS_LOCKER_PASSWORD is not set"
	exit 1
fi

if [ ! -d $CERTBOT_DIR ] && [ -f $CERTBOT_ARCHIVE ]
then
	echo "Certs already locked"
	exit 0
fi

if ! tar -zcvf $CERTBOT_ARCHIVE $CERTBOT_DIR 1>/dev/null
then
	echo "Error when tar'ing' $CERTBOT_DIR"
	exit 2
fi

echo $INFRA_TLS_LOCKER_PASSWORD | gpg \
	--batch \
	--yes \
	--passphrase-fd 0 \
	--output $CERTBOT_ENCRYPTED_ARCHIVE \
	--symmetric $CERTBOT_ARCHIVE

if [ $? -ne 0 ]
then
	echo "Error when encrypting $CERTBOT_DIR tarball"
	exit 3
fi


if ! rm -rf $CERTBOT_DIR $CERTBOT_ARCHIVE
then
	echo "Error while deleting $CERTBOT_DIR and corresponding tarball"
	exit 4
fi

echo "Successfully locked certs"
