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
	lb config --firmware-chroot true \
		--firmware-binary true \

config-hardened:
	export hardened="yes"; \
	lb config --firmware-chroot true \
		--firmware-binary true \

config-custom:
	export customize="yes"; \
	lb config --firmware-chroot true \
		--firmware-binary true \

config-nonfree:
	export nonfree="yes"; \
	lb config --firmware-chroot true \
		--firmware-binary true \

config-hardened-custom:
	export hardened="yes"; \
	export customize="yes"; \
	lb config --firmware-chroot true \
		--firmware-binary true \

config-nonfree-hardened:
	export nonfree="yes"; \
	export hardened="yes"; \
	lb config --firmware-chroot true \
		--firmware-binary true \

config-nonfree-custom:
	export nonfree="yes"; \
	export customize="yes"; \
	lb config --firmware-chroot true \
		--firmware-binary true \

config-nonfree-hardened-custom:
	export nonfree="yes"; \
	export hardened="yes"; \
	export customize="yes"; \
	lb config --firmware-chroot true \
		--firmware-binary true \

unfree:
	make playdeb-repo; \
	make plex-repo; \
	#make nonfree-repo; \

libre:
	make old-repo; \
	make tor-repo; \
	make syncthing-repo; \
	make emby-repo; \
	make i2pd-repo; \
	make palemoon-repo; \
	#make tox-repo; \

custom:
	make apt-now-repo; \
	make lair-game-repo

build:
	make packages
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

all-hardened:
	make config-hardened ; \
	make libre; \
	make skel; \
	make permissive-user

all-nonfree:
	make config-nonfree ; \
	make libre; \
	make unfree; \
	make skel; \
	make easy-user ; \
	make nonfree-firmware

all-nonfree-hardened:
	make config-nonfree-hardened ; \
	make libre; \
	make unfree; \
	make skel; \
	make permissive-user; \
	make nonfree-firmware

all-custom:
	make config-custom ; \
	make libre; \
	make custom; \
	make skel; \
	make easy-user

all-hardened-custom:
	make config-hardened-custom ; \
	make libre; \
	make custom; \
	make skel; \
	make permissive-user

all-nonfree-custom:
	make config-nonfree-custom ; \
	make libre; \
	make custom; \
	make unfree; \
	make skel; \
	make easy-user ; \
	make nonfree-firmware

all-nonfree-hardened-custom:
	make config-nonfree-hardened-custom; \
	make libre; \
	make custom; \
	make unfree; \
	make skel; \
	make permissive-user; \
	make nonfree-firmware

docker-base:
	docker build -t live-build-debian -f Dockerfiles/Dockerfile.live-build.Debian .
	docker build -t live-build-ubuntu -f Dockerfiles/Dockerfile.live-build.Ubuntu .
	docker build -t live-build-devuan -f Dockerfiles/Dockerfile.live-build.Devuan .

docker:
	make docker-debian

docker-debian:
	docker build -t live-build-debian -f Dockerfiles/Dockerfile.live-build.Debian .
	docker build -t hoarder-build-debian \
		--build-arg "nonfree=$(nonfree) customize=$(customize) hardened=$(hardened)" \
		-f Dockerfiles/Dockerfile.Debian .

docker-ubuntu:
	docker build -t live-build-ubuntu -f Dockerfiles/Dockerfile.live-build.Ubuntu .
	docker build -t hoarder-build-ubuntu \
		--build-arg "nonfree=$(nonfree) customize=$(customize) hardened=$(hardened)" \
		-f Dockerfiles/Dockerfile.Ubuntu .

docker-devuan:
	docker build -t live-build-devuan -f Dockerfiles/Dockerfile.live-build.Devuan .
	docker build -t hoarder-build-devuan \
		--build-arg "nonfree=$(nonfree) customize=$(customize) hardened=$(hardened)" \
		-f Dockerfiles/Dockerfile.Devuan .

docker-all:
	make docker-debian
	make docker-ubuntu
	make docker-devuan

docker-update:
	git pull
	make docker-all

docker-copy:
	docker cp $(image_prename)-live-build:/home/livebuilder/hoarder-live/*-amd64.hybrid.iso . ; \
	docker cp $(image_prename)-live-build:/home/livebuilder/hoarder-live/*-amd64.hybrid.iso.sha256sum . ; \
	docker cp $(image_prename)-live-build:/home/livebuilder/hoarder-live/*-amd64.hybrid.iso.sha256sum.asc . ; \
	docker cp $(image_prename)-live-build:/home/livebuilder/hoarder-live/*-amd64.files . ; \
	docker cp $(image_prename)-live-build:/home/livebuilder/hoarder-live/*-amd64.contents . ; \
	docker cp $(image_prename)-live-build:/home/livebuilder/hoarder-live/*-amd64.hybrid.iso.zsync . ; \
	docker cp $(image_prename)-live-build:/home/livebuilder/hoarder-live/*-amd64.packages . ;

docker-init:
	mkdir -p .build

docker-clean:
	docker run -i \
		--name "$(image_prename)-live-build" \
		--privileged \
		-t hoarder-build \
		make clean

docker-build:
	docker run -i \
		--name "$(image_prename)-live-build" \
		--privileged \
		-t hoarder-build \
		make build

docker-build-hardened-on-hardened:
	make soften-container
	docker run -i \
		--name "$(image_prename)-live-build" \
		--privileged \
		-t hoarder-build \
		make build-hardened-on-hardened
	make harden-container

#--build-arg "nonfree=$(nonfree) customize=$(customize) harden=$(harden)" \
