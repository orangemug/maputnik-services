SHELL = /bin/bash

CI ?= false
RANCHER_DEPLOY ?= false
IMAGE_TAG ?= staging

CURRENT_DIR = $(shell pwd)
PYTHON_DIR = .venv
NODE_DIR = node_modules
SUBMODULE_DIR = tileserver-gl
MAPUTNIK_ROOT = ${CURRENT_DIR}/maputnik-editor
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
user: editor gatekeeper

.PHONY: dockerbuild
dockerbuild:
	export RANCHER_DEPLOY=false && source rc_gopass && make docker-compose.yml && docker-compose build

.PHONY: dockerrun
dockerrun:
	export RANCHER_DEPLOY=false && source rc_gopass && make docker-compose.yml && docker-compose up -d

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

#${PYTHON_DIR}:
#	virtualenv ${PYTHON_DIR}

#${PYTHON_DIR}/requirements.timestamp: ${PYTHON_DIR} requirements.txt
#	${PIP_CMD} install -r requirements.txt
#	touch $@

#${NODE_DIR}/package.timestamp: package.json
#	npm install
#	touch $@

#docker-compose.yml::
#	source rc_user && ${MAKO_CMD} --var "rancher_deploy=${RANCHER_DEPLOY}" --var "ci=${CI}" --var "image_tag=${IMAGE_TAG}" docker-compose.yml.in > $@

#nginx/nginx.conf::
#	source rc_user && ${MAKO_CMD} --var "maputnik_root=${MAPUTNIK_ROOT}" nginx/nginx.conf.in > $@

define start_service
	rancher --access-key $1 --secret-key $2 --url $3 rm --stop --type stack service-maputnik-$4 || echo "Nothing to remove"
	rancher --access-key $1 --secret-key $2 --url $3 up --stack service-maputnik-$4 --pull --force-upgrade --confirm-upgrade -d
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
	#rm -f docker-compose.yml

.PHONY: cleanall
cleanall: clean
	rm -rf apps/editor/${NODE_DIR}
	rm -rf apps/gatekeeper/${NODE_DIR}
