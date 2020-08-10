#!/bin/bash


if [ -z "$INFRA_TLS_LOCKER_PASSWORD" ]
then
	echo "\$INFRA_TLS_LOCKER_PASSWORD is not set"
	exit 1
fi

echo $INFRA_TLS_LOCKER_PASSWORD | gpg \
	--batch \
	--yes \
	--passphrase-fd 0 \
	--output terraform_state.gpg \
	--symmetric terraform.tfstate

echo $INFRA_TLS_LOCKER_PASSWORD | gpg \
	--batch \
	--yes \
	--passphrase-fd 0 \
	--output terraform_state_backup.gpg \
	--symmetric terraform.tfstate.backup

if [ $? -ne 0 ]
then
	echo "Error when encrypting $CERTBOT_DIR tarball"
	exit 3
fi

rm -f terraform.tfstate terraform.tfstate.backup

echo "Successfully locked state"
