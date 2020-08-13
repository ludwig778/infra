#!/bin/bash


if [ -f  terraform.tfstate ] && [ -f  terraform.tfstate.backup ]
then
	rm -f terraform.tfstate terraform.tfstate.backup

	echo "Successfully cleaned state"
	exit 0
fi
