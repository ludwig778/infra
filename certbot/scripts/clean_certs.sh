#!/bin/bash

. ./config


if [ -d $CERTBOT_DIR ]
then
	rm -rf $CERTBOT_DIR

	echo "Successfully cleaned certs"
	exit 0
fi
