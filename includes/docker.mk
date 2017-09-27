
docker-base-all:
	make docker-base-debian
	make docker-base-ubuntu
	make docker-base-devuan

docker-base-debian:
	docker build --force-rm --build-arg "CACHING_PROXY=$(proxy_addr)" -t $(image_prename)-build-debian -f Dockerfiles/Dockerfile.live-build.debian .

docker-base-ubuntu:
	docker build --force-rm --build-arg "CACHING_PROXY=$(proxy_addr)" -t $(image_prename)-build-ubuntu -f Dockerfiles/Dockerfile.live-build.ubuntu .

docker-base-devuan:
	docker build --force-rm --build-arg "CACHING_PROXY=$(proxy_addr)" -t $(image_prename)-build-devuan -f Dockerfiles/Dockerfile.live-build.devuan .

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
	make docker-clobber
	make docker-setup
	make docker-build

docker-copy:
	docker cp $(image_prename)-build-$(distro):/home/livebuilder/hoarder-live/$(image_prename)-$(distro)-amd64.hybrid.iso .
	docker cp $(image_prename)-build-$(distro):/home/livebuilder/hoarder-live/$(image_prename)-$(distro)-amd64.files .
	docker cp $(image_prename)-build-$(distro):/home/livebuilder/hoarder-live/$(image_prename)-$(distro)-amd64.contents .
	docker cp $(image_prename)-build-$(distro):/home/livebuilder/hoarder-live/$(image_prename)-$(distro)-amd64.hybrid.iso.zsync .
	docker cp $(image_prename)-build-$(distro):/home/livebuilder/hoarder-live/$(image_prename)-$(distro)-amd64.packages .

docker-init:
	rm -fr .build; \
	mkdir -p .build

docker-build:
	docker rm -f $(image_prename)-build-$(distro); \
	make soften-container; \
	docker run -i \
		-e "distro=$(distro) nonfree=$(nonfree) hardened=$($hardened) customize=$(customize)" \
		--name "$(image_prename)-build-$(distro)" \
		--privileged \
		-t $(image_prename)-$(distro)
	make docker-copy
	make harden-container; true

docker-release:
	make docker-build
	make release

docker-base:
	docker build --force-rm --build-arg "CACHING_PROXY=$(proxy_addr)" -t $(image_prename)-build-devuan -f Dockerfiles/Dockerfile.live-build.$(distro) .

docker-setup:
	make docker-base-$(distro)
	make docker-$(distro)

docker:
	docker build --force-rm -t $(image_prename)-$(distro) \
		--build-arg "nonfree=$(nonfree)" \
		--build-arg "customize=$(customize)" \
		--build-arg "hardened=$(hardened)" \
		-f Dockerfiles/Dockerfile.$(distro) .

docker-conf:
	make docker-base
	make docker

docker-debian:
	docker build --force-rm -t $(image_prename)-debian \
		--build-arg "nonfree=$(nonfree)" \
		--build-arg "customize=$(customize)" \
		--build-arg "hardened=$(hardened)" \
		-f Dockerfiles/Dockerfile.debian .

docker-ubuntu:
	docker build --force-rm -t $(image_prename)-ubuntu \
		--build-arg "nonfree=$(nonfree)" \
		--build-arg "customize=$(customize)" \
		--build-arg "hardened=$(hardened)" \
		-f Dockerfiles/Dockerfile.ubuntu .

docker-devuan:
	docker build --force-rm -t $(image_prename)-devuan \
		--build-arg "nonfree=$(nonfree)" \
		--build-arg "customize=$(customize)" \
		--build-arg "hardened=$(hardened)" \
		-f Dockerfiles/Dockerfile.devuan .

docker-all:
	make docker-debian
	make docker-ubuntu
	make docker-devuan
