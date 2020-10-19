#!/bin/bash


if [ -z "$INFRA_LOCKER_PASSWORD" ]
then
	echo "\$INFRA_LOCKER_PASSWORD is not set"
	exit 1
fi

echo $INFRA_LOCKER_PASSWORD | gpg \
	--batch \
	--yes \
	--passphrase-fd 0 \
	--output terraform_state.gpg \
	--symmetric terraform.tfstate

echo $INFRA_LOCKER_PASSWORD | gpg \
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

echo "Successfully locked state"

./scripts/clean_state.sh
