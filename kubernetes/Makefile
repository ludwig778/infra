restart_traefik:
	kubectl delete -n kube-system deploy traefik-ingress-controller || true
	kubectl apply -f traefik/secret.yml
	kubectl apply -f traefik/configmap.yml
	kubectl apply -f traefik/service.yml
	kubectl apply -f traefik/ingress.yml
	kubectl apply -f traefik/deployment.yml
