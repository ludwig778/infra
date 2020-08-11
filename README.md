# Infra repo

## Setup with direnv (.envrc)

Such as:

``` bash
# cat .envrc
# This is a shared password, agreed upon by the users
export INFRA_TLS_LOCKER_PASSWORD=*****

# To access digital ocean APIs with terraform
export DIGITALOCEAN_ACCESS_TOKEN=*****

# OVH tokens must be set to configure the domains and allow the DNS challenge used
# to create letsencrypt certificates
export OVH_ENDPOINT=ovh-eu
export OVH_APPLICATION_KEY=*****
export OVH_APPLICATION_SECRET=*****
export OVH_CONSUMER_KEY=*****

# Set the issuer email variable when getting letsencrypt certificates
export LETSENCRYPT_ISSUER_EMAIL=laurent.arthur75@gmail.com

# Set the main domain
export MAIN_DOMAIN=hartware.fr

# Set main_domain terraform variable
export TF_VAR_main_domain=$MAIN_DOMAIN
```

