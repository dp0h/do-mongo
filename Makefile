#Import and expose environment variables
cnf ?= .env
include $(cnf)
export $(shell sed 's/=.*//' $(cnf))

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
	mongo admin --host localhost -u $(MONGO_ADM) -p $(MONGO_ADM_PSW) --eval "db.createUser({user: '$(MONGO_BACKUP_USER)', pwd: '$(MONGO_BACKUP_USER_PSW)', roles: [{role: 'backup', db: 'admin'}], passwordDigestor:'server'});"

mongo-dump:
	mongodump --username root --password root --excludeCollectionsWithPrefix=system --authenticationDatabase admin --db backdb

mongo-restore:
	mongorestore --username root --password root
