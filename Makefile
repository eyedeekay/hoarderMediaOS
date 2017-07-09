dummy:
	make list

include config.mk
include includes/repos.mk
include includes/packages.mk
include includes/skel.mk

list:
	@echo "Available commands"
	@echo "=================="
	@echo "  These commands are available in this makefile. They should be pretty"
	@echo "  self explanatory."
	@echo ""
	@grep '^[^#[:space:]].*:' Makefile includes/*.mk

clean:
	sudo lb clean; echo "cleaned"
	make clean-artifacts
	make clean-cache
	make clean-config

clean-cache:
	sudo lb clean --purge

clean-config:
	rm -rf config; \

clean-artifacts:
	rm -f *.hybrid.iso
	rm -f *.hybrid.iso.sha256sum
	rm -f *.hybrid.iso.sha256sum.asc
	rm -f *.files
	rm -f *.contents
	rm -f *.hybrid.iso.zsync
	rm -f *.packages

config:
	lb config --firmware-chroot true \
		--image-name tv

config-hardened:
	lb config -k grsec-amd64 \
		--firmware-chroot true \
		--image-name tv-hardened

config-custom:
	lb config --firmware-chroot true \
		--image-name tv-custom

config-hardened-custom:
	lb config -k grsec-amd64 \
		--firmware-chroot true \
		--image-name tv-hardened-custom

config-proxy:
	export proxy_addr="http://192.168.2.203:3142"; \
	lb config --firmware-chroot true \
		--image-name tv

config-hardened-proxy:
	export proxy_addr="http://192.168.2.203:3142"; \
	lb config -k grsec-amd64 \
		--firmware-chroot true \
		--image-name tv-hardened

config-custom-proxy:
	export proxy_addr="http://192.168.2.203:3142"; \
	lb config --firmware-chroot true \
		--image-name tv-custom

config-hardened-custom-proxy:
	export proxy_addr="http://192.168.2.203:3142"; \
	lb config -k grsec-amd64 \
		--firmware-chroot true \
		--image-name tv-hardened-custom

config-nonfree:
	export nonfree="true"; \
	lb config --archive-areas "main contrib non-free" \
		--apt-source-archives false \
		--firmware-chroot true \
		--image-name tv-nonfree

config-nonfree-hardened:
	export nonfree="true"; \
	lb config -k grsec-amd64 \
		--archive-areas "main contrib non-free" \
		--apt-source-archives false \
		--firmware-chroot true \
		--image-name tv-nonfree-hardened

config-nonfree-custom:
	export nonfree="true"; \
	lb config --archive-areas "main contrib non-free" \
		--apt-source-archives false \
		--firmware-chroot true \
		--image-name tv-nonfree-custom

config-nonfree-hardened-custom:
	export nonfree="true"; \
	lb config -k grsec-amd64 \
		--archive-areas "main contrib non-free" \
		--apt-source-archives false \
		--firmware-chroot true \
		--image-name tv-nonfree-hardened-custom

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
	sudo sysctl -w kernel.grsecurity.chroot_caps=0
	sudo sysctl -w kernel.grsecurity.chroot_deny_chmod=0
	sudo sysctl -w kernel.grsecurity.chroot_deny_mknod=0
	sudo sysctl -w kernel.grsecurity.chroot_deny_mount=0
	sudo sysctl -p
	sudo sysctl kernel.grsecurity.chroot_caps
	sudo sysctl kernel.grsecurity.chroot_deny_chmod
	sudo sysctl kernel.grsecurity.chroot_deny_mknod
	sudo sysctl kernel.grsecurity.chroot_deny_mount
	make build
	sudo sysctl -w kernel.grsecurity.chroot_caps=1
	sudo sysctl -w kernel.grsecurity.chroot_deny_chmod=1
	sudo sysctl -w kernel.grsecurity.chroot_deny_mknod=1
	sudo sysctl -w kernel.grsecurity.chroot_deny_mount=1
	sudo sysctl -p
	sudo sysctl kernel.grsecurity.chroot_caps
	sudo sysctl kernel.grsecurity.chroot_deny_chmod
	sudo sysctl kernel.grsecurity.chroot_deny_mknod
	sudo sysctl kernel.grsecurity.chroot_deny_mount

allclean:
	make clean ; \
	make all-free

allclean-hardened:
	make clean ; \
	make all-hardened

allclean-nonfree:
	make clean ; \
	make all-nonfree

allclean-nonfree-hardened:
	make clean ; \
	make all-nonfree-hardened

allclean-custom:
	make clean ; \
	make all-custom

allclean-hardened-custom:
	make clean ; \
	make all-hardened-custom

allclean-nonfree-custom:
	make clean; \
	make all-nonfree-custom

allclean-nonfree-hardened-custom:
	make clean; \
	make all-nonfree-hardened-custom

all:
	echo "ATTN: Are you sure you don't want to use a container? if so, do make all-free."

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

sum:
	sha256sum tv-amd64.hybrid.iso > \
		tv-amd64.hybrid.iso.sha256sum || \
		rm tv-amd64.hybrid.iso.sha256sum; \
	sha256sum tv-custom-amd64.hybrid.iso > \
		tv-custom-amd64.hybrid.iso.sha256sum || \
		rm tv-custom-amd64.hybrid.iso.sha256sum; \
	sha256sum tv-hardened-amd64.hybrid.iso > \
		tv-hardened-amd64.hybrid.iso.sha256sum || \
		rm tv-hardened-amd64.hybrid.iso.sha256sum; \
	sha256sum tv-hardened-custom-amd64.hybrid.iso > \
		tv-hardened-custom-amd64.hybrid.iso.sha256sum || \
		rm tv-hardened-custom-amd64.hybrid.iso.sha256sum; \
	sha256sum tv-nonfree-amd64.hybrid.iso > \
		tv-nonfree-amd64.hybrid.iso.sha256sum || \
		rm tv-nonfree-amd64.hybrid.iso.sha256sum; \
	sha256sum tv-nonfree-custom-amd64.hybrid.iso > \
		tv-nonfree-custom-amd64.hybrid.iso.sha256sum || \
		rm tv-nonfree-custom-amd64.hybrid.iso.sha256sum; \
	sha256sum tv-nonfree-hardened-amd64.hybrid.iso > \
		tv-nonfree-hardened-amd64.hybrid.iso.sha256sum || \
		rm tv-nonfree-hardened-amd64.hybrid.iso.sha256sum; \
	sha256sum tv-nonfree-hardened-custom-amd64.hybrid.iso > \
		tv-nonfree-hardened-custom-amd64.hybrid.iso.sha256sum || \
		rm tv-nonfree-hardened-custom-amd64.hybrid.iso.sha256sum; \
	echo sums computed

sig:
	gpg --batch --yes --clear-sign -u "$(SIGNING_KEY)" \
		tv-amd64.hybrid.iso.sha256sum ; \
	gpg --batch --yes --clear-sign -u "$(SIGNING_KEY)" \
		tv-custom-amd64.hybrid.iso.sha256sum ; \
	gpg --batch --yes --clear-sign -u "$(SIGNING_KEY)" \
		tv-hardened-amd64.hybrid.iso.sha256sum ; \
	gpg --batch --yes --clear-sign -u "$(SIGNING_KEY)" \
		tv-hardened-custom-amd64.hybrid.iso.sha256sum ; \
	gpg --batch --yes --clear-sign -u "$(SIGNING_KEY)" \
		tv-nonfree-amd64.hybrid.iso.sha256sum ; \
	gpg --batch --yes --clear-sign -u "$(SIGNING_KEY)" \
		tv-nonfree-custom-amd64.hybrid.iso.sha256sum ; \
	gpg --batch --yes --clear-sign -u "$(SIGNING_KEY)" \
		tv-nonfree-hardened-amd64.hybrid.iso.sha256sum ; \
	gpg --batch --yes --clear-sign -u "$(SIGNING_KEY)" \
		tv-nonfree-hardened-custom-amd64.hybrid.iso.sha256sum ; \
	echo images signed

sigsum:
	make sum
	make sig

torrent:
	mktorrent -a "udp://tracker.openbittorrent.com:80" \
		-a "udp://tracker.publicbt.com:80" \
		-a "udp://tracker.istole.it:80" \
		-a "udp://tracker.btzoo.eu:80/announce" \
		-a "http://opensharing.org:2710/announce" \
		-a "udp://open.demonii.com:1337/announce" \
		-a "http://announce.torrentsmd.com:8080/announce.php" \
		-a "http://announce.torrentsmd.com:6969/announce" \
		-a "http://bt.careland.com.cn:6969/announce" \
		-a "http://i.bandito.org/announce" \
		-a "http://bttrack.9you.com/announce" \
		-w https://github.com/cmotc/hoarderMediaOS/releases/download/$(shell date +'%y.%m.%d')/tv.iso \
		tv-amd64.hybrid.iso; \
	mktorrent -a "udp://tracker.openbittorrent.com:80" \
		-a "udp://tracker.publicbt.com:80" \
		-a "udp://tracker.istole.it:80" \
		-a "udp://tracker.btzoo.eu:80/announce" \
		-a "http://opensharing.org:2710/announce" \
		-a "udp://open.demonii.com:1337/announce" \
		-a "http://announce.torrentsmd.com:8080/announce.php" \
		-a "http://announce.torrentsmd.com:6969/announce" \
		-a "http://bt.careland.com.cn:6969/announce" \
		-a "http://i.bandito.org/announce" \
		-a "http://bttrack.9you.com/announce" \
		-a "http://bttrack.9you.com/announce" \
		-w https://github.com/cmotc/hoarderMediaOS/releases/download/$(shell date +'%y.%m.%d')/tv-custom.iso \
		tv-custom-amd64.hybrid.iso; \
	mktorrent -a "udp://tracker.openbittorrent.com:80" \
		-a "udp://tracker.publicbt.com:80" \
		-a "udp://tracker.istole.it:80" \
		-a "udp://tracker.btzoo.eu:80/announce" \
		-a "http://opensharing.org:2710/announce" \
		-a "udp://open.demonii.com:1337/announce" \
		-a "http://announce.torrentsmd.com:8080/announce.php" \
		-a "http://announce.torrentsmd.com:6969/announce" \
		-a "http://bt.careland.com.cn:6969/announce" \
		-a "http://i.bandito.org/announce" \
		-a "http://bttrack.9you.com/announce" \
		-a "http://bttrack.9you.com/announce" \
		-w https://github.com/cmotc/hoarderMediaOS/releases/download/$(shell date +'%y.%m.%d')/tv-hardened.iso \
		tv-hardened-amd64.hybrid.iso; \
	mktorrent -a "udp://tracker.openbittorrent.com:80" \
		-a "udp://tracker.publicbt.com:80" \
		-a "udp://tracker.istole.it:80" \
		-a "udp://tracker.btzoo.eu:80/announce" \
		-a "http://opensharing.org:2710/announce" \
		-a "udp://open.demonii.com:1337/announce" \
		-a "http://announce.torrentsmd.com:8080/announce.php" \
		-a "http://announce.torrentsmd.com:6969/announce" \
		-a "http://bt.careland.com.cn:6969/announce" \
		-a "http://i.bandito.org/announce" \
		-a "http://bttrack.9you.com/announce" \
		-a "http://bttrack.9you.com/announce" \
		-w https://github.com/cmotc/hoarderMediaOS/releases/download/$(shell date +'%y.%m.%d')/tv-hardened-custom.iso \
		tv-hardened-custom-amd64.hybrid.iso; \
	mktorrent -a "udp://tracker.openbittorrent.com:80" \
		-a "udp://tracker.publicbt.com:80" \
		-a "udp://tracker.istole.it:80" \
		-a "udp://tracker.btzoo.eu:80/announce" \
		-a "http://opensharing.org:2710/announce" \
		-a "udp://open.demonii.com:1337/announce" \
		-a "http://announce.torrentsmd.com:8080/announce.php" \
		-a "http://announce.torrentsmd.com:6969/announce" \
		-a "http://bt.careland.com.cn:6969/announce" \
		-a "http://i.bandito.org/announce" \
		-a "http://bttrack.9you.com/announce" \
		-a "http://bttrack.9you.com/announce" \
		-w https://github.com/cmotc/hoarderMediaOS/releases/download/$(shell date +'%y.%m.%d')/tv-nonfree.iso \
		tv-nonfree-amd64.hybrid.iso; \
	mktorrent -a "udp://tracker.openbittorrent.com:80" \
		-a "udp://tracker.publicbt.com:80" \
		-a "udp://tracker.istole.it:80" \
		-a "udp://tracker.btzoo.eu:80/announce" \
		-a "http://opensharing.org:2710/announce" \
		-a "udp://open.demonii.com:1337/announce" \
		-a "http://announce.torrentsmd.com:8080/announce.php" \
		-a "http://announce.torrentsmd.com:6969/announce" \
		-a "http://bt.careland.com.cn:6969/announce" \
		-a "http://i.bandito.org/announce" \
		-a "http://bttrack.9you.com/announce" \
		-a "http://bttrack.9you.com/announce" \
		-w https://github.com/cmotc/hoarderMediaOS/releases/download/$(shell date +'%y.%m.%d')/tv-nonfree-custom.iso \
		tv-nonfree-custom-amd64.hybrid.iso; \
	mktorrent -a "udp://tracker.openbittorrent.com:80" \
		-a "udp://tracker.publicbt.com:80" \
		-a "udp://tracker.istole.it:80" \
		-a "udp://tracker.btzoo.eu:80/announce" \
		-a "http://opensharing.org:2710/announce" \
		-a "udp://open.demonii.com:1337/announce" \
		-a "http://announce.torrentsmd.com:8080/announce.php" \
		-a "http://announce.torrentsmd.com:6969/announce" \
		-a "http://bt.careland.com.cn:6969/announce" \
		-a "http://i.bandito.org/announce" \
		-a "http://bttrack.9you.com/announce" \
		-w https://github.com/cmotc/hoarderMediaOS/releases/download/$(shell date +'%y.%m.%d')/tv-nonfree-hardened.iso \
		tv-nonfree-hardened-amd64.hybrid.iso; \
	mktorrent -a "udp://tracker.openbittorrent.com:80" \
		-a "udp://tracker.publicbt.com:80" \
		-a "udp://tracker.istole.it:80" \
		-a "udp://tracker.btzoo.eu:80/announce" \
		-a "http://opensharing.org:2710/announce" \
		-a "udp://open.demonii.com:1337/announce" \
		-a "http://announce.torrentsmd.com:8080/announce.php" \
		-a "http://announce.torrentsmd.com:6969/announce" \
		-a "http://bt.careland.com.cn:6969/announce" \
		-a "http://i.bandito.org/announce" \
		-a "http://bttrack.9you.com/announce" \
		-a "http://bttrack.9you.com/announce" \
		-w https://github.com/cmotc/hoarderMediaOS/releases/download/$(shell date +'%y.%m.%d')/tv-nonfree-hardened-custom.iso \
		tv-nonfree-hardened-custom-amd64.hybrid.iso ; \
	echo torrents created

backup:
	scp tv-*amd64.hybrid.iso media@192.168.2.206:os_backups/ ; \
	scp tv-*amd64.hybrid.iso.sha256sum media@192.168.2.206:os_backups/ ; \
	scp tv-*amd64.hybrid.iso.sha256sum.asc media@192.168.2.206:os_backups/ ; \
	scp tv-*amd64.files media@192.168.2.206:os_backups/ ; \
	scp tv-*amd64.contents media@192.168.2.206:os_backups/ ; \
	scp tv-*amd64.hybrid.iso.zsync media@192.168.2.206:os_backups/ ; \
	scp tv-*amd64.packages media@192.168.2.206:os_backups/ ;

get-backup:
	scp media@192.168.2.206:os_backups/tv-*amd64.hybrid.iso . ; \
	make get-infos

get-infos:
	scp media@192.168.2.206:os_backups/tv-*amd64.hybrid.iso.sha256sum . ; \
	scp media@192.168.2.206:os_backups/tv-*amd64.hybrid.iso.sha256sum.asc . ; \
	scp media@192.168.2.206:os_backups/tv-*amd64.files . ; \
	scp media@192.168.2.206:os_backups/tv-*amd64.contents . ; \
	scp media@192.168.2.206:os_backups/tv-*amd64.hybrid.iso.zsync . ; \
	scp media@192.168.2.206:os_backups/tv-*amd64.packages . ;

release:
	make sigsum
	make torrent
	git tag $(shell date +'%y.%m.%d'); git push --tags github
	github-release release \
		--user cmotc \
		--repo hoarderMediaOS \
		--tag $(shell date +'%y.%m.%d') \
		--name "hoarderMediaOS" \
		--description "A re-buildable OS for self-hosting. Please use the torrent if possible" \
		--pre-release ; \
	make upload

upload:
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-amd64.hybrid.iso.sha256sum" \
		--file tv-amd64.hybrid.iso.sha256sum; \
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-amd64.hybrid.iso.sha256sum.asc" \
		--file tv-amd64.hybrid.iso.sha256sum.asc;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-amd64.hybrid.iso.torrent" \
		--file tv-amd64.hybrid.iso.torrent;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-amd64.hybrid.iso" \
		--file tv-amd64.hybrid.iso;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-hardened-amd64.hybrid.iso.sha256sum" \
		--file tv-hardened-amd64.hybrid.iso.sha256sum; \
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-hardened-amd64.hybrid.iso.sha256sum.asc" \
		--file tv-hardened-amd64.hybrid.iso.sha256sum.asc;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-hardened-amd64.hybrid.iso.torrent" \
		--file tv-hardened-amd64.hybrid.iso.torrent;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-hardened-amd64.hybrid.iso" \
		--file tv-hardened-amd64.hybrid.iso;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-custom-amd64.hybrid.iso.sha256sum" \
		--file tv-custom-amd64.hybrid.iso.sha256sum; \
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-custom-amd64.hybrid.iso.sha256sum.asc" \
		--file tv-custom-amd64.hybrid.iso.sha256sum.asc;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-custom-amd64.hybrid.iso.torrent" \
		--file tv-custom-amd64.hybrid.iso.torrent;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-custom-amd64.hybrid.iso" \
		--file tv-custom-amd64.hybrid.iso;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-hardened-custom-amd64.hybrid.iso.sha256sum" \
		--file tv-hardened-custom-amd64.hybrid.iso.sha256sum; \
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-hardened-custom-amd64.hybrid.iso.sha256sum.asc" \
		--file tv-hardened-custom-amd64.hybrid.iso.sha256sum.asc;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-hardened-custom-amd64.hybrid.iso.torrent" \
		--file tv-hardened-custom-amd64.hybrid.iso.torrent;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-hardened-custom-amd64.hybrid.iso" \
		--file tv-hardened-custom-amd64.hybrid.iso;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-nonfree-amd64.hybrid.iso.sha256sum" \
		--file tv-nonfree-amd64.hybrid.iso.sha256sum; \
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-nonfree-amd64.hybrid.iso.asc" \
		--file tv-nonfree-amd64.hybrid.iso.sha256sum.asc;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-nonfree-amd64.hybrid.iso.torrent" \
		--file tv-nonfree-amd64.hybrid.iso.torrent;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-nonfree-amd64.hybrid.iso" \
		--file tv-nonfree-amd64.hybrid.iso;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-nonfree-hardened-amd64.hybrid.iso.sha256sum" \
		--file tv-nonfree-hardened-amd64.hybrid.iso.sha256sum; \
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-nonfree-hardened-amd64.hybrid.iso.sha256sum.asc" \
		--file tv-nonfree-hardened-amd64.hybrid.iso.sha256sum.asc;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-nonfree-hardened-amd64.hybrid.iso.torrent" \
		--file tv-nonfree-hardened-amd64.hybrid.iso.torrent;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-nonfree-hardened-amd64.hybrid.iso" \
		--file tv-nonfree-hardened-amd64.hybrid.iso;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-nonfree-custom-amd64.hybrid.iso.sha256sum" \
		--file tv-nonfree-custom-amd64.hybrid.iso.sha256sum; \
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-nonfree-custom-amd64.hybrid.iso.sha256sum.asc" \
		--file tv-nonfree-custom-amd64.hybrid.iso.sha256sum.asc;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-nonfree-custom-amd64.hybrid.iso.torrent" \
		--file tv-nonfree-custom-amd64.hybrid.iso.torrent;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-nonfree-custom-amd64.hybrid.iso" \
		--file tv-nonfree-custom-amd64.hybrid.iso;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-nonfree-hardened-custom-amd64.hybrid.iso.sha256sum" \
		--file tv-nonfree-hardened-custom-amd64.hybrid.iso.sha256sum; \
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-nonfree-hardened-custom-amd64.hybrid.iso.sha256sum.asc" \
		--file tv-nonfree-hardened-custom-amd64.hybrid.iso.sha256sum.asc;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-nonfree-hardened-custom-amd64.hybrid.iso.torrent" \
		--file tv-nonfree-hardened-custom-amd64.hybrid.iso.torrent;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-nonfree-hardened-custom-amd64.hybrid.iso" \
		--file tv-nonfree-hardened-custom-amd64.hybrid.iso;\

garbage-collect:
	export DEV_MESSAGE="garbage-collected repository" ; \
		git commit -am "$(DEV_MESSAGE)"
	git filter-branch --tag-name-filter cat --index-filter 'git rm -r --cached --ignore-unmatch binary' --prune-empty -f -- --all
	rm -rf .git/refs/original/
	git reflog expire --all --expire=now
	git gc --prune=now
	git gc --aggressive --prune=now
	git repack -Ad
	export DEV_MESSAGE="garbage-collected repository" ; \
		gpg --batch --yes --clear-sign -u "$(SIGNING_KEY)" \
			README.md; \
		git commit -am "$(DEV_MESSAGE)"
	git push github --force --all
	git push github --force --tags
	yes | docker system prune

push:
	git add .
	gpg --batch --yes --clear-sign -u "$(SIGNING_KEY)" \
		README.md
	git commit -am "$(DEV_MESSAGE)"
	git push github master

docker:
	make docker-debian

docker-debian:
	docker build -t live-build-debian -f Dockerfiles/Dockerfile.live-build.Debian .
	docker build -t hoarder-build-debian -f Dockerfiles/Dockerfile.Debian .

docker-ubuntu:
	docker build -t live-build-ubuntu -f Dockerfiles/Dockerfile.live-build.Ubuntu .
	docker build -t hoarder-build-ubuntu -f Dockerfiles/Dockerfile.Ubuntu .

docker-devuan:
	docker build -t live-build-devuan -f Dockerfiles/Dockerfile.live-build.Devuan .
	docker build -t hoarder-build-devuan -f Dockerfiles/Dockerfile.Devuan .

docker-all:
	make docker
	make docker-ubuntu
	make docker-devuan

docker-update:
	git pull
	make docker-all

docker-enter:
	docker run -i -t hoarder-build bash

docker-copy:
	docker cp tv-live-build:/home/livebuilder/hoarder-live/*-amd64.hybrid.iso . ; \
	docker cp tv-live-build:/home/livebuilder/hoarder-live/*-amd64.hybrid.iso.sha256sum . ; \
	docker cp tv-live-build:/home/livebuilder/hoarder-live/*-amd64.hybrid.iso.sha256sum.asc . ; \
	docker cp tv-live-build:/home/livebuilder/hoarder-live/*-amd64.files . ; \
	docker cp tv-live-build:/home/livebuilder/hoarder-live/*-amd64.contents . ; \
	docker cp tv-live-build:/home/livebuilder/hoarder-live/*-amd64.hybrid.iso.zsync . ; \
	docker cp tv-live-build:/home/livebuilder/hoarder-live/*-amd64.packages . ;

docker-init:
	mkdir -p .build

docker-clean:
	docker run -i --privileged -t hoarder-build make clean

docker-build:
	docker run -i --name "tv-live-build" --privileged -t hoarder-build make build

docker-build-hardened-on-hardened:
	sudo sysctl -w kernel.grsecurity.chroot_caps=0
	sudo sysctl -w kernel.grsecurity.chroot_deny_chmod=0
	sudo sysctl -w kernel.grsecurity.chroot_deny_mknod=0
	sudo sysctl -w kernel.grsecurity.chroot_deny_mount=0
	sudo sysctl -p
	sudo sysctl kernel.grsecurity.chroot_caps
	sudo sysctl kernel.grsecurity.chroot_deny_chmod
	sudo sysctl kernel.grsecurity.chroot_deny_mknod
	sudo sysctl kernel.grsecurity.chroot_deny_mount
	docker run -i --name "tv-live-build" --privileged -t hoarder-build make build-hardened-on-hardened
	sudo sysctl -w kernel.grsecurity.chroot_caps=1
	sudo sysctl -w kernel.grsecurity.chroot_deny_chmod=1
	sudo sysctl -w kernel.grsecurity.chroot_deny_mknod=1
	sudo sysctl -w kernel.grsecurity.chroot_deny_mount=1
	sudo sysctl -p
	sudo sysctl kernel.grsecurity.chroot_caps
	sudo sysctl kernel.grsecurity.chroot_deny_chmod
	sudo sysctl kernel.grsecurity.chroot_deny_mknod
	sudo sysctl kernel.grsecurity.chroot_deny_mount

tutorial:
	rm -f TUTORIAL.md
	cat "Tutorial/HOWTO.0.INTRODUCTION.md" | tee -a TUTORIAL.md
	echo "" | tee -a TUTORIAL.md
	cat "Tutorial/HOWTO.1.LIVEBUILD.md" | tee -a TUTORIAL.md
	echo "" | tee -a TUTORIAL.md
	cat "Tutorial/HOWTO.2.AUTOSCRIPTS.md" | tee -a TUTORIAL.md
	echo "" | tee -a TUTORIAL.md
	cat "Tutorial/HOWTO.3.MAKEFILE.md" | tee -a TUTORIAL.md
	echo "" | tee -a TUTORIAL.md
	cat "Tutorial/HOWTO.4.DOCKERFILE.md" | tee -a TUTORIAL.md
	echo "" | tee -a TUTORIAL.md
	cat "Tutorial/HOWTO.5.AUTHENTICATE.md" | tee -a TUTORIAL.md
	echo "" | tee -a TUTORIAL.md
	cat "Tutorial/HOWTO.6.RELEASE.md" | tee -a TUTORIAL.md
	echo "" | tee -a TUTORIAL.md
