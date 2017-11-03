
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
	docker cp $(image_prename)-build-$(distro):/home/livebuilder/hoarder-live/$(image_prename)-$(distro)-amd64.hybrid.iso .
	docker cp $(image_prename)-build-$(distro):/home/livebuilder/hoarder-live/$(image_prename)-$(distro)-amd64.files .
	docker cp $(image_prename)-build-$(distro):/home/livebuilder/hoarder-live/$(image_prename)-$(distro)-amd64.contents .
	docker cp $(image_prename)-build-$(distro):/home/livebuilder/hoarder-live/$(image_prename)-$(distro)-amd64.hybrid.iso.zsync .
	docker cp $(image_prename)-build-$(distro):/home/livebuilder/hoarder-live/$(image_prename)-$(distro)-amd64.packages .

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
		--privileged \
		-t $(image_prename)-$(distro)
	make docker-copy

docker-release:
	make docker-build
	make release

docker-base:
	docker build --force-rm \
		--build-arg "CACHING_PROXY=$(proxy_addr)" \
		-t $(image_prename)-build-$(distro) \
		-f Dockerfiles/Dockerfile.live-build.$(distro) .

docker:
	docker build --force-rm -t $(image_prename)-$(distro) \
		--build-arg "nonfree=$(nonfree)" \
		--build-arg "customize=$(customize)" \
		--build-arg "hardened=$(hardened)" \
		-f Dockerfiles/Dockerfile.$(distro) .

docker-conf:
	make docker-base
	make docker

docker-setup:
	make docker-base
	make docker

errs:
	docker exec -t $(image_prename)-build-$(distro) cat err

logs:
	docker logs -f $(image_prename)-build-$(distro)

ls:
	docker exec -t $(image_prename)-build-$(distro) ls

ps:
	docker exec -t $(image_prename)-build-$(distro) ps aux
