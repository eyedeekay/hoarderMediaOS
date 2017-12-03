
docker-clean:
	docker rm $(image_prename)-$(distro) $(image_prename)-build; \
	true

docker-clobber:
	docker rmi -f $(image_prename)-$(distro) $(image_prename)-build-$(distro); \
	docker system prune -f; \
	true

docker-clobber-all:
	make docker-clobber
	docker rmi -f $(image_prename)-build-debian \
		$(image_prename)-build-devuan \
		$(image_prename)-build-ubuntu \
		$(image_prename)-debian \
		$(image_prename)-devuan \
		$(image_prename)-ubuntu; \
	true

docker-full-build:
	make docker-setup
	make docker-build

docker-copy:
	docker cp $(image_prename)-build-$(distro):/home/livebuilder/hoarder-live/auto/common  ./auto/common
	./auto/copy

docker-init:
	rm -fr .build; \
	sudo -E lb init -t 3 5 1> init.log 2> init.err; true

docker-rebuild:
	git pull; \
	make docker-setup
	make docker-build

docker-rebuild-nochroot:
	git pull; \
	make docker-setup
	make docker-build-nochroot

docker-build:
	docker rm -f $(image_prename)-build-$(distro); \
	docker run -i \
		--cap-add=SYS_ADMIN \
		--device /dev/loop0 \
		-e "distro"="$(distro)" \
		-e "nonfree"="$(nonfree)" \
		-e "hardened"="$($hardened)" \
		-e "custom"="$(custom)" \
		-e "server"="$(server)" \
		-e "proxy_addr"="$(proxy_addr)" \
		-e "proxy_host"="$(proxy_host)" \
		-e "proxy_port"="$(proxy_port)" \
		--name "$(image_prename)-build-$(distro)" \
		--privileged \
		--tty \
		-t $(image_prename)-$(distro)

docker-build-nochroot:
	docker rm -f $(image_prename)-build-$(distro); \
	docker run -i \
		--cap-add=SYS_ADMIN \
		--device /dev/loop0 \
		-e "distro"="$(distro)" \
		-e "nonfree"="$(nonfree)" \
		-e "hardened"="$($hardened)" \
		-e "custom"="$(custom)" \
		-e "server"="$(server)" \
		-e "proxy_addr"="$(proxy_addr)" \
		-e "proxy_host"="$(proxy_host)" \
		-e "proxy_port"="$(proxy_port)" \
		--name "$(image_prename)-build-$(distro)" \
		--privileged \
		--tty \
		-t $(image_prename)-$(distro) make build-nochroot


docker-release:
	make docker-copy
	make release

docker-base:
	docker build --force-rm \
		--build-arg "CACHING_PROXY"="$(proxy_addr)" \
		-t $(image_prename)-build-$(distro) \
		-f Dockerfiles/Dockerfile.live-build.$(distro) .

docker:
	docker build --force-rm -t $(image_prename)-$(distro) \
		--build-arg "nonfree"="$(nonfree)" \
		--build-arg "custom"="$(custom)" \
		--build-arg "hardened"="$(hardened)" \
		--build-arg "proxy_addr"="$(proxy_addr)" \
		--build-arg "proxy_host"="$(proxy_host)" \
		--build-arg "proxy_port"="$(proxy_port)" \
		-f Dockerfiles/Dockerfile.$(distro) .

docker-conf:
	make docker-base
	make docker

docker-setup:
	make docker-base | tee setup.log
	make docker | tee -a setup.log

errs:
	docker exec -t $(image_prename)-build-$(distro) cat err | less

logs:
	docker exec -t $(image_prename)-build-$(distro) cat log | less

conflog:
	docker exec -t $(image_prename)-build-$(distro) cat config.log | less

conferr:
	docker exec -t $(image_prename)-build-$(distro) cat config.err | less

ls:
	docker exec -t $(image_prename)-build-$(distro) ls -laR ../ | less

ps:
	docker exec -t $(image_prename)-build-$(distro) ps aux

enter:
	docker exec -t $(image_prename)-build-$(distro) bash | less

initlog:
	docker exec -t $(image_prename)-build-$(distro) cat init.log | less

initerr:
	docker exec -t $(image_prename)-build-$(distro) cat init.err | less
