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

define sudo_wrap
#!/bin/bash
timeout=10 #seconds
set -m
echoerr() { echo "$@" 1>&2; }
keep_eye_on() {
    pid=$1
    time_passed=0
    while kill -0 $pid &> /dev/null; do
        sleep 1
        let time_passed=time_passed+1
        if [ $time_passed -ge $timeout ]; then
            echoerr "Timeout reached."
            kill -9 $pid
            exit 1
        fi
    done
}
if [ -z "$1" ]; then
    echoerr "Please specify a process to run!"
    exit 1
fi;
sudo $@ &
pid=$!
keep_eye_on $pid &
while true; do
    if kill -0 $pid &> /dev/null; then
        fg sudo > /dev/null; [ $? == 1 ] && break;
    else
        break
    fi
done

endef

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
