#generate keypair
#set permissions
#apply terraform

.PHONY: gen-keys create-disk remove-instance remove-all start-instance fresh

gen-keys:
	ssh-keygen -f bbb-access.key -N ""

create-disk:
	terraform init bbb-disk/ && terraform apply -auto-approve -var="disk_name=test" bbb-disk/

remove-instance:
	terraform destroy -auto-approve bbb-instace/

remove-all: remove-instance
	terraform destroy -auto-approve bbb-disk/ && rm bbb-access*

start-instance: gen-keys
	terraform init bbb-instace/ && terraform apply -auto-approve -var="disk_name=test" bbb-instace/

fresh: create-disk start-instance