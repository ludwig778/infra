set_traefik:
	kubectl delete -n kube-system deploy traefik || true
	kubectl apply -f traefik/secret.yml
	kubectl apply -f traefik/configmap.yml
	kubectl apply -f traefik/service.yml
	kubectl apply -f traefik/deployment.yml
	envsubst < traefik/ingress.yml | kubectl apply -f -

set_vault:
	kubectl apply -f vault/service.yml
	kubectl apply -f vault/deployment.yml
	envsubst < vault/ingress.yml | kubectl apply -f -
