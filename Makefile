dummy:
	make list

include config.mk
include includes/git.mk
include includes/packages.mk
include includes/release.mk
include includes/repos.mk
include includes/skel.mk

list:
	@echo "Available commands"
	@echo "=================="
	@echo ""
	@echo " Image Name Prefix: $(IMAGE_PRENAME)"
	@echo "  Whole Image Variant $$image_prename$$tag_distro$$is_harden$$non_free$$customized$$serverdist"
	@echo ""
	@echo " Proxy: $(proxy_addr)"
	@echo ""
	@echo " Signing Key $(KEY)"
	@echo ""
	@echo "  These commands are available in this makefile. They should be pretty"
	@echo "  self explanatory."
	@echo ""
	@grep '^[^#[:space:]].*:' Makefile includes/*.mk

clean:
	sudo lb clean; echo "cleaned"
	rm -f *.hybrid.iso
	rm -f *.hybrid.iso.sha256sum
	rm -f *.hybrid.iso.sha256sum.asc
	rm -f *.files
	rm -f *.contents
	rm -f *.hybrid.iso.zsync
	rm -f *.packages
	rm -rf config

config:
	lb config

config-nonfree:
	export nonfree="yes"; \
	lb config --firmware-chroot true \
		--firmware-binary true

unfree:
	make playdeb-repo; \
	make plex-repo; \
	#make nonfree-repo; \

unfree-ubuntu:
	make playdeb-repo; \
	make plex-repo; \
	make nonfree-ubuntu-repo; \

libre:
	make i2pd-repo; \
	make old-repo; \
	make tor-repo; \
	make syncthing-repo; \
	make palemoon-repo; \
	#make emby-repo; \
	#make tox-repo; \

libre-ubuntu:
	make i2pd-repo; \
	make tor-ubuntu-repo; \
	make syncthing-repo; \
	make palemoon-repo; \
	#make emby-repo; \
	#make tox-repo; \

custom:
	make apt-now-repo; \
	make lair-game-repo

build:
	sudo lb build

build-hardened-on-hardened:
	make soften-container
	make build
	make harden-container

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

docker:
	make docker-base-$(distro)
	make docker-$(distro)

docker-debian:
	docker build --force-rm -t $(image_prename)-debian \
		--build-arg "nonfree=$(nonfree) customize=$(customize) hardened=$(hardened)" \
		-f Dockerfiles/Dockerfile.debian .

docker-ubuntu:
	docker build --force-rm -t $(image_prename)-ubuntu \
		--build-arg "nonfree=$(nonfree) customize=$(customize) hardened=$(hardened)" \
		-f Dockerfiles/Dockerfile.ubuntu .

docker-devuan:
	docker build --force-rm -t $(image_prename)-devuan \
		--build-arg "nonfree=$(nonfree) customize=$(customize) hardened=$(hardened)" \
		-f Dockerfiles/Dockerfile.devuan .

docker-all:
	make docker-debian
	make docker-ubuntu
	make docker-devuan

docker-clean:
	docker rm $(image_prename)-$(distro)
	docker rm $(image_prename)-build

docker-update:
	git pull
	make docker-all

docker-copy:
	docker cp $(image_prename)-build-$(distro):/home/livebuilder/hoarder-live/$(image_prename)-$(distro)-amd64.hybrid.iso
	docker cp $(image_prename)-build-$(distro):/home/livebuilder/hoarder-live/$(image_prename)-$(distro)-amd64.files
	docker cp $(image_prename)-build-$(distro):/home/livebuilder/hoarder-live/$(image_prename)-$(distro)-amd64.contents
	docker cp $(image_prename)-build-$(distro):/home/livebuilder/hoarder-live/$(image_prename)-$(distro)-amd64.hybrid.iso.zsync
	docker cp $(image_prename)-build-$(distro):/home/livebuilder/hoarder-live/$(image_prename)-$(distro)-amd64.packages

docker-init:
	rm -fr .build; \
	mkdir -p .build

docker-build:
	docker rm -f $(image_prename)-build-$(distro); \
	docker run -i \
		-e "distro=$(distro) nonfree=$(nonfree) hardened=$($hardened) customize=$(customize)" \
		--name "$(image_prename)-build-$(distro)" \
		--privileged \
		-t $(image_prename)-$(distro) \
		make build

docker-build-hardened-on-hardened:
	make soften-container; \
	docker run -i \
		-e "distro=$(distro) nonfree=$(nonfree) hardened=$($hardened) customize=$(customize)" \
		--name "$(image_prename)-build-$(distro)" \
		--privileged \
		-t $(image_prename)-$(distro) \
		make build-hardened-on-hardened
	make harden-container


docker-clobber:
	docker rmi -f $(image_prename)-debian \
		$(image_prename)-devuan \
		$(image_prename)-ubuntu; \
	docker rm -f $(image_prename)-build-debian \
		$(image_prename)-build-devuan \
		$(image_prename)-build-ubuntu; \
	docker system prune -f
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

docker-rebuild:
	make docker-base-$(distro)
	make docker-$(distro)

docker-full-build:
	docker rm -f $(image_prename)-$(distro); \
	docker rm -f $(image_prename)-build-$(distro); \
	make docker-base-$(distro)
	make docker-$(distro)

docker-rebuild-all:
	make docker-clobber
	make docker-all

docker-rebuild-clean:
	make docker-clobber-all
	make docker-base-all
	make docker-all

docker-release:
	make docker-build
	make docker-copy
	make release

throw:
	scp -r . media@media:Docker/hoarderMediaOS
