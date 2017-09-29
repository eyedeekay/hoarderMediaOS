
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
	docker cp $(image_prename)-build-$(distro):/home/livebuilder/hoarder-live/$(image_prename)-$(distro)*-amd64.hybrid.iso .
	docker cp $(image_prename)-build-$(distro):/home/livebuilder/hoarder-live/$(image_prename)-$(distro)*-amd64.files .
	docker cp $(image_prename)-build-$(distro):/home/livebuilder/hoarder-live/$(image_prename)-$(distro)*-amd64.contents .
	docker cp $(image_prename)-build-$(distro):/home/livebuilder/hoarder-live/$(image_prename)-$(distro)*-amd64.hybrid.iso.zsync .
	docker cp $(image_prename)-build-$(distro):/home/livebuilder/hoarder-live/$(image_prename)-$(distro)*-amd64.packages .

docker-init:
	rm -fr .build; \
	mkdir -p .build

docker-rebuild:
	make docker-setup
	make docker-build

docker-build:
	docker rm -f $(image_prename)-build-$(distro); \
	docker run -i \
		-e "distro=$(distro) nonfree=$(nonfree) hardened=$($hardened) customize=$(customize)" \
		--name "$(image_prename)-build-$(distro)" \
		--volume $(shell pwd)/build \
		--privileged \
		-t $(image_prename)-$(distro)
	make docker-copy

docker-release:
	make docker-build
	make release

docker-base:
	docker build --force-rm --build-arg "CACHING_PROXY=$(proxy_addr)" -t $(image_prename)-build-devuan -f Dockerfiles/Dockerfile.live-build.$(distro) .

docker:
	docker build --force-rm -t $(image_prename)-$(distro) \
		--build-arg "nonfree=$(nonfree)" \
		--build-arg "customize=$(customize)" \
		--build-arg "hardened=$(hardened)" \
		-f Dockerfiles/Dockerfile.$(distro) .

docker-conf:
	make docker-base
	make docker

docker-base-debian:
	docker build --force-rm --build-arg "CACHING_PROXY=$(proxy_addr)" -t $(image_prename)-build-debian -f Dockerfiles/Dockerfile.live-build.debian .

docker-base-ubuntu:
	docker build --force-rm --build-arg "CACHING_PROXY=$(proxy_addr)" -t $(image_prename)-build-ubuntu -f Dockerfiles/Dockerfile.live-build.ubuntu .

docker-base-devuan:
	docker build --force-rm --build-arg "CACHING_PROXY=$(proxy_addr)" -t $(image_prename)-build-devuan -f Dockerfiles/Dockerfile.live-build.devuan .

docker-debian:
	docker build --force-rm -t $(image_prename)-debian \
		--build-arg "nonfree=$(nonfree)" \
		--build-arg "customize=$(custom)" \
		--build-arg "hardened=$(hardened)" \
		-f Dockerfiles/Dockerfile.debian .

docker-ubuntu:
	docker build --force-rm -t $(image_prename)-ubuntu \
		--build-arg "nonfree=$(nonfree)" \
		--build-arg "customize=$(custom)" \
		--build-arg "hardened=$(hardened)" \
		-f Dockerfiles/Dockerfile.ubuntu .

docker-devuan:
	docker build --force-rm -t $(image_prename)-devuan \
		--build-arg "nonfree=$(nonfree)" \
		--build-arg "customize=$(custom)" \
		--build-arg "hardened=$(hardened)" \
		-f Dockerfiles/Dockerfile.devuan .

docker-base-all:
	make docker-base-debian
	make docker-base-ubuntu
	make docker-base-devuan

docker-all:
	make docker-debian
	make docker-ubuntu
	make docker-devuan

docker-setup:
	make docker-base-$(distro)
	make docker-$(distro)

errs:
	docker exec -t $(image_prename)-build-$(distro) cat err

logs:
	docker logs -f $(image_prename)-build-$(distro)

ls:
	docker exec -t $(image_prename)-build-$(distro) ls

ps:
	docker exec -t $(image_prename)-build-$(distro) ps aux
