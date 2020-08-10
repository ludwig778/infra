#!/bin/bash

if [ -z "$OVH_ENDPOINT" ] || [ -z "$OVH_APPLICATION_KEY" ] || [ -z "$OVH_APPLICATION_SECRET" ] || [ -z "$OVH_CONSUMER_KEY" ]
then
	exit 1
fi

echo """dns_ovh_endpoint = $OVH_ENDPOINT
dns_ovh_application_key = $OVH_APPLICATION_KEY
dns_ovh_application_secret = $OVH_APPLICATION_SECRET
dns_ovh_consumer_key = $OVH_CONSUMER_KEY""" > .credentials

chmod 600 .credentials

