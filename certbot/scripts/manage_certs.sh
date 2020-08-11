#!/bin/bash

if ! ./scripts/set_credentials.sh
then
	echo "Infra repo OVH API keys must be set"
	exit 1
fi

. ./config

if [ ! -f .credentials ]
then
	echo "No .credentials file found, check the README to set it up"
	exit 2
fi

if [ ! -d $CERTBOT_DIR ] && [ -f $CERTBOT_ENCRYPTED_ARCHIVE ]
then
	echo "Certs are locked, unlock them to update existing certs"
	exit 3
fi

certbot certonly \
	--dns-ovh \
	--dns-ovh-credentials .credentials \
	--dns-ovh-propagation-seconds 60 \
	--config-dir $CERTBOT_DIR/config_dir \
	--work-dir $CERTBOT_DIR/work_dir \
	--logs-dir $CERTBOT_DIR/log_dir \
	--agree-tos \
	--non-interactive \
	--email $ISSUER_EMAIL \
	-d $MAIN_DOMAIN \
	-d *.$MAIN_DOMAIN \
	-d *.dev.$MAIN_DOMAIN

