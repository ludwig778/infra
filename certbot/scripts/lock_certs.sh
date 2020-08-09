#!/bin/bash

. ./config

if [ -z "$INFRA_TLS_LOCKER_PASSWORD" ]
then
	echo "\$INFRA_TLS_LOCKER_PASSWORD is not set"
	exit 1
fi

if [ ! -d $CERTBOT_DIR_NAME ] && [ -f $CERTBOT_TARBALL_NAME.gpg ]
then
	echo "Certs already locked"
	exit 2
fi

if ! tar -zcvf $CERTBOT_TARBALL_NAME $CERTBOT_DIR_NAME 1>/dev/null
then
	echo "Error when tar'ing' $CERTBOT_DIR_NAME"
	exit 3
fi

echo $INFRA_TLS_LOCKER_PASSWORD | gpg --batch --yes --passphrase-fd 0 -c $CERTBOT_TARBALL_NAME

if [ $? -ne 0 ]
then
	echo "Error when encrypting $CERTBOT_DIR_NAME tarball"
	exit 4
fi


if ! rm -rf $CERTBOT_DIR_NAME $CERTBOT_TARBALL_NAME
then
	echo "Error while deleting $CERTBOT_DIR_NAME and corresponding tarball"
	exit 5
fi

echo "Successfully locked certs"
