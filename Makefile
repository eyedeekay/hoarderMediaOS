dummy:
	make list | less

include config.mk
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
	@echo " Proxy: $(proxy_addr)"
	@echo ""
	@echo " Signing Key $(KEY)"
	@echo ""
	@echo "  These commands are available in this makefile. They should be pretty"
	@echo "  self explanatory."
	@echo ""
	@grep '^[^#[:space:]].*:' Makefile includes/*.mk

sudo_wrap:
	@echo $(su_wrap) > /usr/bin/su_wrap
	chmod +x /usr/bin/su_wrap

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
	lb build

throw:
	scp -r . media@media:Docker/hoarderMediaOS

logs:
	docker exec -t $(image_prename)-build-$(distro) tail -f log

errs:
	docker logs -f $(image_prename)-build-$(distro)

ls:
	docker exec -t $(image_prename)-build-$(distro) ls
