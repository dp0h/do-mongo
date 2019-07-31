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
	@echo "	mongo-init"
	@echo "	mongo-create"
	@echo "	mongo-start"
	@echo "	mongo-stop"
	@echo "	mongo-kill"
	@echo

# MongoDB dev commands

mongo-init:
	docker pull mongo
	mkdir -p $(MONGO_PATH)

mongo-create:
	docker run -d -p $(MONGO_PORT):27017 -v  $(MONGO_PATH):/data/db --name mongo mongo

mongo-start:
	docker start mongo

mongo-stop:
	docker stop mongo

mongo-kill:
	docker kill mongo
