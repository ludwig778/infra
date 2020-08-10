# Let's Encrypt certificates management

## Setup with OVH domain name provider and DNS challenge

You must install certbot and certbot-dns-ovh plugin with pip3 beforehand

On mac

```
brew install certbot
python3 -m pip install certbot-dns-ovh
```

Or on debian based distros

```
apt-get install certbot
python3 -m pip install certbot-dns-ovh
```

Then setup a token on OVH API (https://eu.api.ovh.com/createToken/) with these endpoint rights:

```
GET /domain/zone/
GET /domain/zone/{domain.ext}/status
GET /domain/zone/{domain.ext}/record
GET /domain/zone/{domain.ext}/record/*
POST /domain/zone/{domain.ext}/record
POST /domain/zone/{domain.ext}/refresh
DELETE /domain/zone/{domain.ext}/record/*
```

Retrieve the application key, secret and consumer key and put them in a .credentials file (not to commit though) as such:

``` bash
# cat .credentials
dns_ovh_endpoint = ovh-eu
dns_ovh_application_key = *APP_KEY*
dns_ovh_application_secret = *APP_SECRET*
dns_ovh_consumer_key = *CONSUMER_KEY*
```

Then run the handle Makefile target:

``` bash
make handle
```

## Backup and restore existing certificates

You can backup and restore certificates using the lock and unlock Makefile targets, using the password contained in the INFRA_TLS_LOCKER_PASSWORD env variable (which must be set to run these targets), and will create a commitable symetricaly encrypted .gpg file.

``` bash
# make lock
./scripts/lock_certs.sh
Successfully locked certs
# make unlock
./scripts/unlock_certs.sh
gpg: WARNING: no command supplied.  Trying to guess what you mean ...
gpg: données chiffrées avec AES256
gpg: chiffré avec 1 phrase secrète
Successfully unlocked certs
```
