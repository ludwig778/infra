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
	--output terraform.tfstate \
	--decrypt terraform_state.gpg

echo $INFRA_TLS_LOCKER_PASSWORD | gpg \
	--batch \
	--yes \
	--passphrase-fd 0 \
	--output terraform.tfstate.backup \
	--decrypt terraform_state_backup.gpg

echo "Successfully unlocked state"
