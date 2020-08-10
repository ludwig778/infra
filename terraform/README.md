# Getting started

## Setup env variables

Retrieve the access and secret keys and put them in the .envrc file of the parent folder as such:

```
export SCW_ACCESS_KEY=*****
export SCW_SECRET_KEY=*****
export SCW_DEFAULT_ZONE=fr-par-1
export SCW_DEFAULT_REGION=fr-par
export SCW_DEFAULT_ORGANIZATION_ID=*****
```

... or for digital ocean

```
export DIGITALOCEAN_ACCESS_TOKEN=*****
```

## Backup and restore states

You can backup and restore states using the lock and unlock Makefile targets, using the password contained in the INFRA_TLS_LOCKER_PASSWORD env variable (which must be set to run these targets), and will create a commitable symmetrically encrypted .gpg file.

``` bash
# make lock
./scripts/lock_state.sh
Successfully locked state
make unlock
./scripts/unlock_state.sh
gpg: données chiffrées avec AES256
gpg: chiffré avec 1 phrase secrète
gpg: données chiffrées avec AES256
gpg: chiffré avec 1 phrase secrète
Successfully unlocked state
```
