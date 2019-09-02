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
	@echo
	@echo " *** mongodb targets ***	"
	@echo "	mongo-start"
	@echo "	mongo-stop"
	@echo "	mongo-init-user"
	@echo

# MongoDB dev commands
mongo-start:
	docker-compose -f docker/mongo/docker-compose.yml up -d

mongo-stop:
	docker-compose -f docker/mongo/docker-compose.yml down

mongo-init-user:
	mongo admin --host localhost -u $(MONGO_ADM) -p $(MONGO_ADM_PSW) --eval "db.createUser({user: '$(MONGO_USER)', pwd: '$(MONGO_USER_PSW)', roles: [{role: 'readWrite', db: '$(MONGO_APP_DB)'}], passwordDigestor:'server'});"

mongo-init-backup:
	mongo admin --host localhost -u $(MONGO_ADM) -p $(MONGO_ADM_PSW) --eval "db.createUser({user: '$(MONGO_BACKUP_USER)', pwd: '$(MONGO_BACKUP_USER_PSW)', roles: [{role: 'backup', db: '$(MONGO_APP_DB)'}], passwordDigestor:'server'});"

mongo-dump:
	mongodump --username $(MONGO_BACKUP_USER) --password $(MONGO_BACKUP_USER_PSW) --excludeCollectionsWithPrefix=system --authenticationDatabase admin --db backdb

mongo-restore:
	mongorestore --username $(MONGO_ADM) --password $(MONGO_ADM_PSW)

do-mongo-create:
	docker-machine create --digitalocean-size "s-1vcpu-1gb" --driver digitalocean --digitalocean-access-token $(DO_ACCESS_TOKEN) --digitalocean-region lon1 $(MONGO_CONTAINER)

do-mongo-machine:
	docker-machine create --driver generic --generic-ip-address=$(MONGO_HOST_IP) --generic-ssh-key ~/.docker_machine/$(MONGO_CONTAINER)/id_rsa vm
