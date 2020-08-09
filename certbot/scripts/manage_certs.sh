#!/bin/bash

. ./config

if [ ! -f .credentials ]
then
	echo "No .credentials file found, check the README to set it up"
	exit 1
fi

if [ ! -d $CERTBOT_DIR_NAME ] && [ -f $CERTBOT_TARBALL_NAME.gpg ]                                    
then
        echo "Certs are locked, unlock them to update existing certs"
        exit 2
fi

certbot certonly \
	--dns-ovh \
	--dns-ovh-credentials .credentials \
	--dns-ovh-propagation-seconds 60 \
	--config-dir certbot_dirs/config_dir \
	--work-dir certbot_dirs/work_dir \
	--logs-dir certbot_dirs/log_dir \
	--agree-tos \
	--non-interactive \
	--email $ISSUER_EMAIL \
	-d $MAIN_DOMAIN \
	-d $MAIN_WILDCARD \
	-d $DEV_WILDCARD

