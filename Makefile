lock:
	make -C terraform lock
	make -C certbot lock

unlock:
	make -C terraform unlock
	make -C certbot unlock

clean:
	make -C terraform clean
	make -C certbot clean

setup_traefik:
	make -C certbot unlock
	./scripts/set_traefik_secret.yml
	make -C certbot clean
	make -C kubernetes set_traefik
