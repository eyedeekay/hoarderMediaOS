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
	sudo lb clean --purge
	rm -rf config

config:
	lb config

config-hardened:
	export hardened="yes"; \
	lb config

config-custom:
	export customize="yes"; \
	lb config

config-hardened-custom:
	export hardened="yes"; \
	export customize="yes"; \
	lb config

config-nonfree:
	export nonfree="yes"; \
	lb config --firmware-chroot true \
		--firmware-binary true

config-nonfree-hardened:
	export nonfree="yes"; \
	export hardened="yes"; \
	lb config --firmware-chroot true \
		--firmware-binary true

config-nonfree-custom:
	export nonfree="yes"; \
	export customize="yes"; \
	lb config --firmware-chroot true \
		--firmware-binary true

config-nonfree-hardened-custom:
	export nonfree="yes"; \
	export hardened="yes"; \
	export customize="yes"; \
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

all:
	@echo "ATTN: Are you sure you don't want to use a container? if so, do make all-free."

all-free:
	make config ; \
	make libre; \
	make skel; \
	make easy-user
	make packages

all-hardened:
	make config-hardened ; \
	make libre; \
	make skel; \
	make permissive-user
	make packages

all-nonfree:
	make config-nonfree ; \
	make libre; \
	make unfree; \
	make skel; \
	make easy-user ; \
	make nonfree-firmware
	make packages

all-nonfree-hardened:
	make config-nonfree-hardened ; \
	make libre; \
	make unfree; \
	make skel; \
	make permissive-user; \
	make nonfree-firmware
	make packages

all-custom:
	make config-custom ; \
	make libre; \
	make custom; \
	make skel; \
	make easy-user
	make packages

all-hardened-custom:
	make config-hardened-custom ; \
	make libre; \
	make custom; \
	make skel; \
	make permissive-user
	make packages

all-nonfree-custom:
	make config-nonfree-custom ; \
	make libre; \
	make custom; \
	make unfree; \
	make skel; \
	make easy-user ; \
	make nonfree-firmware
	make packages

all-nonfree-hardened-custom:
	make config-nonfree-hardened-custom; \
	make libre; \
	make custom; \
	make unfree; \
	make skel; \
	make permissive-user; \
	make nonfree-firmware
	make packages

docker-base-all:
	make docker-base-debian
	make docker-base-ubuntu
	make docker-base-devuan

docker-base-debian:
	docker build --force-rm -t live-build-debian -f Dockerfiles/Dockerfile.live-build.Debian .

docker-base-ubuntu:
	docker build --force-rm -t live-build-ubuntu -f Dockerfiles/Dockerfile.live-build.Ubuntu .

docker-base-devuan:
	docker build --force-rm -t live-build-devuan -f Dockerfiles/Dockerfile.live-build.Devuan .

docker:
	make docker-debian

docker-debian:
	docker build --force-rm -t $(image_prename)-debian \
		--build-arg "nonfree=$(nonfree) customize=$(customize) hardened=$(hardened)" \
		-f Dockerfiles/Dockerfile.Debian .

docker-ubuntu:
	docker build --force-rm -t $(image_prename)-ubuntu \
		--build-arg "nonfree=$(nonfree) customize=$(customize) hardened=$(hardened)" \
		-f Dockerfiles/Dockerfile.Ubuntu .

docker-devuan:
	docker build --force-rm -t $(image_prename)-devuan \
		--build-arg "nonfree=$(nonfree) customize=$(customize) hardened=$(hardened)" \
		-f Dockerfiles/Dockerfile.Devuan .

docker-all:
	make docker-debian
	make docker-ubuntu
	make docker-devuan

docker-clean:
	docker rm tv-debian-build
	docker rm tv-ubuntu-build
	docker rm tv-devuan-build

docker-update:
	git pull
	make docker-all

docker-copy:
	docker cp $(image_prename)-$(distro)-build:/home/livebuilder/hoarder-live/$(image_prename)-amd64.hybrid.iso . ; \
	docker cp $(image_prename)-$(distro)-build:/home/livebuilder/hoarder-live/$(image_prename)-amd64.hybrid.iso.sha256sum . ; \
	docker cp $(image_prename)-$(distro)-build:/home/livebuilder/hoarder-live/$(image_prename)-amd64.hybrid.iso.sha256sum.asc . ; \
	docker cp $(image_prename)-$(distro)-build:/home/livebuilder/hoarder-live/$(image_prename)-amd64.files . ; \
	docker cp $(image_prename)-$(distro)-build:/home/livebuilder/hoarder-live/$(image_prename)-amd64.contents . ; \
	docker cp $(image_prename)-$(distro)-build:/home/livebuilder/hoarder-live/$(image_prename)-amd64.hybrid.iso.zsync . ; \
	docker cp $(image_prename)-$(distro)-build:/home/livebuilder/hoarder-live/$(image_prename)-amd64.packages . ;

docker-init:
	mkdir -p .build

docker-build-clean:
	docker run -i \
		-e "distro=$(distro) nonfree=$(nonfree) hardened=$($hardened)" \
		--name "$(image_prename)-$(distro)-build" \
		--privileged \
		-t $(image_prename)-$(distro) \
		make clean

docker-build:
	docker run -i \
		-e "distro=$(distro) nonfree=$(nonfree) hardened=$($hardened)" \
		--name "$(image_prename)-$(distro)-build" \
		--privileged \
		-t $(image_prename)-$(distro) \
		make build

docker-build-hardened-on-hardened:
	make soften-container; \
	docker run -i \
		-e "distro=$(distro) nonfree=$(nonfree) hardened=$($hardened)" \
		--name "$(image_prename)-$(distro)-build" \
		--privileged \
		-t $(image_prename)-$(distro) \
		make build-hardened-on-hardened
	make harden-container


docker-clobber:
	docker rmi -f tv-debian \
		tv-devuan \
		tv-ubuntu; \
	docker rm -f tv-build-debian \
		tv-build-devuan \
		tv-build-ubuntu; \
	docker system prune -f
	true

docker-clobber-all:
	make docker-clobber
	docker rmi -f live-build-debian \
		live-build-devuan \
		live-build-ubuntu \
		tv-debian \
		tv-devuan \
		tv-ubuntu; \
	true

docker-rebuild:
	make docker-clobber
	make docker-all
	make docker-build

docker-rebuild-all:
	make docker-clobber-all
	make docker-base-all
	make docker-all
	make docker-build

throw:
	scp -r . media@media:Docker/hoarderMediaOS
