#Import and expose environment variables
cnf ?= .env
include $(cnf)
export $(shell sed 's/=.*//' $(cnf))
cnf_priv ?= ../.env
include $(cnf_priv)
export $(shell sed 's/=.*//' $(cnf_priv))

help:
	@echo
	@echo "Usage: make TARGET"
	@echo
	@echo "Targets:"
	@echo "	up - starts a mongodb"
	@echo "	down - stops a mongodb"
	@echo "	do-machine-create - creates a Droplet for mongodb"
	@echo "	do-machine - activates a docker machine with mongodb"
	@echo

up:
	docker-compose -f docker-compose.yml up -d

down:
	docker-compose -f docker-compose.yml down

create-user:
	mongo admin --host $(MONGO_HOST) --port $(MONGO_PORT) -u $(MONGO_ADM) -p $(MONGO_ADM_PSW) --eval "db.createUser({user: '$(MONGO_USER)', pwd: '$(MONGO_USER_PSW)', roles: [{role: 'readWrite', db: '$(MONGO_APP_DB)'}], passwordDigestor:'server'});"

create-backup-user:
	mongo admin --host $(MONGO_HOST) --port $(MONGO_PORT) -u $(MONGO_ADM) -p $(MONGO_ADM_PSW) --eval "db.createUser({user: '$(MONGO_BACKUP_USER)', pwd: '$(MONGO_BACKUP_USER_PSW)', roles: [{role: 'backup', db: 'admin'}], passwordDigestor:'server'});"

dump:
	mongodump --username $(MONGO_BACKUP_USER) --password $(MONGO_BACKUP_USER_PSW) --excludeCollectionsWithPrefix=system --authenticationDatabase admin --db $(MONGO_APP_DB)

restore:
	mongorestore --username $(MONGO_ADM) --password $(MONGO_ADM_PSW)

do-machine-create:
	docker-machine create --digitalocean-size "s-1vcpu-1gb" --driver digitalocean --digitalocean-access-token $(DO_ACCESS_TOKEN) --digitalocean-region lon1 $(MONGO_CONTAINER) --digitalocean-private-networking true

#do-machine-attach:
#	docker-machine create --driver generic --generic-ip-address=$(MONGO_HOST) --generic-ssh-key ~/.docker/machine/$(MONGO_CONTAINER)/id_rsa $(MONGO_CONTAINER)

do-machine:
	echo "eval $$(docker-machine env $(MONGO_CONTAINER))"
