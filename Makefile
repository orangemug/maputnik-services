SHELL = /bin/bash

CI ?= false
RANCHER_DEPLOY ?= false
IMAGE_TAG ?= staging

CURRENT_DIR = $(shell pwd)
PYTHON_DIR = .venv
NODE_DIR = node_modules
SUBMODULE_DIR = tileserver-gl
MAKO_CMD = ${PYTHON_DIR}/bin/mako-render
PIP_CMD = ${PYTHON_DIR}/bin/pip


.PHONY: help
help:
	@echo ""
	@echo "- user                 Install the project"
	@echo "- dockerbuild          Builds all images via docker-compose"
	@echo "- dockerrun            Launches all the containers for the service"
	@echo "- dockerpurge          Remove all docker related docker containers and images"
	@echo "- rancherdeploydev     Deploys the app to Rancher"
	@echo "- clean                Remove generated templates"
	@echo "- cleanall             Remove all build artefacts"
	@echo ""

.PHONY: user
user: ${PYTHON_DIR}/requirements.timestamp editor gatekeeper

.PHONY: dockerbuild
dockerbuild: 
	export RANCHER_DEPLOY=false && make docker-compose.yml && docker-compose build

.PHONY: dockerrun
dockerrun:
	export RANCHER_DEPLOY=false && make docker-compose.yml && docker-compose up -d

.PHONY: rancherdeploydev
rancherdeploydev: guard-RANCHER_ACCESS_KEY_DEV \
                  guard-RANCHER_SECRET_KEY_DEV \
                  guard-RANCHER_URL_DEV
	export RANCHER_DEPLOY=true && make docker-compose.yml
	$(call start_service,$(RANCHER_ACCESS_KEY_DEV),$(RANCHER_SECRET_KEY_DEV),$(RANCHER_URL_DEV),dev)

.PHONY: dockerpurge
dockerpurge:
	@if test "$(shell docker ps -a -q --filter name=servicemaputnik)" != ""; then \
		sudo docker rm -f $(shell sudo docker ps -a -q --filter name=servicemaputnik); \
	fi
	@if test "$(shell docker images -q swisstopo/service-maputnik-editor)" != ""; then \
		sudo docker rmi -f swisstopo/service-maputnik-editor:latest; \
	fi
	@if test "$(shell docker images -q swisstopo/service-maputnik-gatekeeper)" != ""; then \
		sudo docker rmi -f swisstopo/service-maputnik-gatekeeper:latest; \
	fi
	@if test "$(shell docker images -q swisstopo/service-maputnik-haproxy)" != ""; then \
		sudo docker rmi -f swisstopo/service-maputnik-haproxy:latest; \
	fi

${PYTHON_DIR}:
	virtualenv ${PYTHON_DIR}

${PYTHON_DIR}/requirements.timestamp: ${PYTHON_DIR} requirements.txt
	${PIP_CMD} install -r requirements.txt
	touch $@

#${NODE_DIR}/package.timestamp: package.json
#	npm install
#	touch $@

docker-compose.yml: guard-GK_OAUTH_CLIENT_ID \
                    guard-GK_OAUTH_CLIENT_SECRET
	source rc_user && ${MAKO_CMD} \
	       --var "rancher_deploy=${RANCHER_DEPLOY}" \
	       --var "ci=${CI}" \
	       --var "image_tag=${IMAGE_TAG}" \
	       --var "gk_oauth_client_id=${GK_OAUTH_CLIENT_ID}" \
	       --var "gk_oauth_client_secret=${GK_OAUTH_CLIENT_SECRET}" \
	       --var "image_tag=${IMAGE_TAG}" \
	       docker-compose.yml.in > $@

define start_service
	#rancher --access-key $1 --secret-key $2 --url $3 rm --stop --type stack service-tileservergl-$4 || echo "Nothing to remove"
	rancher --access-key $1 --secret-key $2 --url $3 up --stack service-tileservergl-$4 --pull --force-upgrade --confirm-upgrade -d
endef

guard-%:
	@ if test "${${*}}" = ""; then \
	  echo "Environment variable $* not set. Add it to your command."; \
	  exit 1; \
	fi

.PHONY: editor
editor:
	cd apps/editor; \
	npm install; \
	npm run build 

.PHONY: gatekeeper
gatekeeper:
	cd apps/gatekeeper; \
	npm install

.PHONY: clean
clean:
	rm -f docker-compose.yml

.PHONY: cleanall
cleanall: clean
	rm -rf ${PYTHON_DIR}
	rm -rf apps/editor/${NODE_DIR}
	rm -rf apps/gatekeeper/${NODE_DIR}
