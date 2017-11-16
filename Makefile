include config.mk

dummy:
	make list | less

include includes/docker.mk
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
	@echo "  Whole Image Variant: $(image_prename)"
	@echo "   Parent Distro: $(distro)"
	@echo "   Additional Hardening: $(hardened)"
	@echo "   Non-Free: $(nonfree)"
	@echo "   Personal Customizations: $(custom)"
	@echo "   No X variant: $(server)"
	@echo ""
	@echo " Mirror: $(mirror_devuan)"
	@echo " Proxy: $(proxy_addr)"
	@echo ""
	@echo " Signing Key $(KEY)"
	@echo ""
	@echo "  These commands are available in this makefile. They should be pretty"
	@echo "  self explanatory."
	@echo ""
	@grep '^[^#[:space:]].*:' Makefile includes/*.mk

clean:
	sudo -E lb clean --all

clobber: clean
	rm -rf *.hybrid.iso \
	*.hybrid.iso.sha256sum \
	*.hybrid.iso.sha256sum.asc \
	*.files \
	*.contents \
	*.hybrid.iso.zsync \
	*.packages \
	*log *err \
	config

config:
	lb config

config-nochroot:
	lb config --build-with-chroot false

unfree:
	make playdeb-repo; \
	make plex-repo; \
	make nonfree-repo

unfree-ubuntu:
	make playdeb-repo; \
	make plex-repo; \
	make nonfree-ubuntu-repo; \

libre:
	make i2pd-repo; \
	make tor-repo; \
	make syncthing-repo; \
	make tox-repo; \
	#make emby-repo; \

libre-ubuntu:
	make i2pd-repo; \
	make tor-ubuntu-repo; \
	make syncthing-repo; \
	make tox-repo; \
	#make emby-repo; \

custom:
	make apt-now-repo; \
	make lair-game-repo

build:
	make clean
	sudo -E lb build

build-nochroot:
	make clean
	sudo -E lb build

throw:
	scp -r . media@media:Docker/hoarderMediaOS

packages: packages-list
