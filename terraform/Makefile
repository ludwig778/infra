apply:
	terraform apply -auto-approve

destroy:
	terraform destroy -auto-approve

output:
	terraform output

output_json:
	terraform output -json

format_ansible_inventory:
	echo -e '[servers]\nserver\t\tansible_host=$(shell terraform output -json | jq ".ips.value.address" | sed "s/\"//g")'

