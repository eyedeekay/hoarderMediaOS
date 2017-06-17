expose:
	echo "clean = sudo lb clean"
	echo "config = lb config"
	echo "build =sudo lb build"
	echo "all = clean; config; build"
	echo "packages = echo \"package list\""
	cat config/package-lists/build.list.chroot

clean:
	sudo lb clean; echo "cleaned"
	make clean-cache
	make clean-config

clean-cache:
	sudo lb clean --cache
	sudo \rm -rf cache
	sudo \rm -rf chroot

clean-config:
	rm -rf config; \

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

config-nonfree:
	export nonfree="true"; \
	lb config --archive-areas "main contrib nonfree" \
		--apt-source-archives false \
		--firmware-chroot true \
		--image-name tv-nonfree

config-nonfree-hardened:
	export nonfree="true"; \
	lb config -k grsec-amd64 \
		--archive-areas "main contrib nonfree" \
		--apt-source-archives false \
		--firmware-chroot true \
		--image-name tv-nonfree-hardened

config-nonfree-custom:
	export nonfree="true"; \
	lb config --archive-areas "main contrib nonfree" \
		--apt-source-archives false \
		--firmware-chroot true \
		--image-name tv-nonfree-custom

config-nonfree-hardened-custom:
	export nonfree="true"; \
	lb config -k grsec-amd64 \
		--archive-areas "main contrib nonfree" \
		--apt-source-archives false \
		--firmware-chroot true \
		--image-name tv-nonfree-hardened-custom

nonfree-repo:
	echo "deb http://ftp.us.debian.org/debian/ sid contrib nonfree" | tee config/archives/nonfree.list.chroot
	cd config/archives/ \
		&& ln -sf nonfree.list.chroot nonfree.list.binary
	echo "deb http://ftp.us.debian.org/debian/ jessie contrib nonfree" | tee config/archives/nonfree-jessie.list.chroot
	cd config/archives/ \
		&& ln -sf nonfree.list.chroot nonfree.list.binary

playdeb-repo:
	echo "deb http://archive.getdeb.net/ubuntu xenial-getdeb games" | tee config/archives/playdeb.list.chroot
	echo "deb-src http://archive.getdeb.net/ubuntu xenial-getdeb games" | tee -a config/archives/playdeb.list.chroot
	wget -q -O- http://archive.getdeb.net/getdeb-archive.key > config/archives/playdeb.list.key.chroot
	cd config/archives/ \
		&& ln -sf playdeb.list.chroot playdeb.list.binary \
		&& ln -sf playdeb.list.key.chroot playdeb.list.key.binary

plex-repo:
	echo "deb http://downloads.plex.tv/repo/deb/ public main" | tee config/archives/plex.list.chroot
	curl https://downloads.plex.tv/plex-keys/PlexSign.key > config/archives/plex.list.key.chroot
	cd config/archives/ \
		&& ln -sf plex.list.chroot plex.list.binary \
		&& ln -sf plex.list.key.chroot plex.list.key.binary

unfree:
	make playdeb-repo; \
	make plex-repo; \
	#make nonfree-repo; \

old-repo:
	echo "deb http://ftp.us.debian.org/debian/ jessie main " | tee config/archives/jessie.list.chroot
	cd config/archives/ \
		&& ln -sf jessie.list.chroot jessie.list.binary \


syncthing-repo:
	echo "deb http://apt.syncthing.net/ syncthing release" | tee config/archives/syncthing.list.chroot
	curl -s https://syncthing.net/release-key.txt | tee config/archives/syncthing.list.key.chroot
	cd config/archives/ \
		&& ln -sf syncthing.list.chroot syncthing.list.binary \
		&& ln -sf syncthing.list.key.chroot syncthing.list.key.binary

emby-repo:
	echo "deb http://download.opensuse.org/repositories/home:/emby/Debian_Next/ /" | tee config/archives/emby.list.chroot
	curl -s https://download.opensuse.org/repositories/home:/emby/Debian_Next/Release.key | tee config/archives/emby.list.key.chroot
	cd config/archives/ \
		&& ln -sf emby.list.chroot emby.list.binary \
		&& ln -sf emby.list.key.chroot emby.list.key.binary

i2pd-repo:
	echo "deb http://repo.lngserv.ru/debian jessie main" | tee config/archives/i2pd.list.chroot
	echo "deb-src http://repo.lngserv.ru/debian jessie main" | tee -a config/archives/i2pd.list.chroot
	gpg --keyserver keys.gnupg.net --recv-keys 98EBCFE2; \
	gpg -a --export 98EBCFE2 | tee config/archives/i2pd.list.key.chroot
	cd config/archives/ \
		&& ln -sf i2pd.list.chroot i2pd.list.binary \
		&& ln -sf i2pd.list.key.chroot i2pd.list.key.binary

tor-repo:
	echo "deb http://deb.torproject.org/torproject.org stretch main" | tee config/archives/tor.list.chroot
	echo "deb-src http://deb.torproject.org/torproject.org stretch main" | tee -a config/archives/tor.list.chroot
	gpg --keyserver keys.gnupg.net --recv-keys A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89; \
	gpg -a --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | tee config/archives/tor.list.key.chroot
	cd config/archives/ \
		&& ln -sf tor.list.chroot tor.list.binary \
		&& ln -sf tor.list.key.chroot tor.list.key.binary

tox-repo:
	echo "deb http://pkg.tox.chat/debian stable sid" | tee config/archives/tox.list.chroot
	curl -s https://pkg.tox.chat/debian/pkg.gpg.key | tee config/archives/tox.list.key.chroot
	cd config/archives/ \
		&& ln -sf tox.list.chroot tox.list.binary \
		&& ln -sf tox.list.key.chroot tox.list.key.binary

palemoon-repo:
	echo 'deb http://download.opensuse.org/repositories/home:/stevenpusser/Debian_9.0/ /' | tee config/archives/palemoon.list.chroot
	curl -s http://download.opensuse.org/repositories/home:/stevenpusser/Debian_9.0/Release.key | tee config/archives/palemoon.list.key.chroot
	cd config/archives/ \
		&& ln -sf palemoon.list.chroot palemoon.list.binary \
		&& ln -sf palemoon.list.key.chroot palemoon.list.key.binary

libre:
	make old-repo; \
	make syncthing-repo; \
	make emby-repo; \
	make i2pd-repo; \
	make tor-repo; \
	make palemoon-repo; \
	make tox-repo; \

apt-now-repo:
	echo "deb http://cmotc.github.io/apt-now/deb-pkg rolling main" | tee config/archives/apt-now.list.chroot
	echo "deb-src http://cmotc.github.io/apt-now/deb-pkg rolling main" | tee -a config/archives/apt-now.list.chroot
	curl -s https://cmotc.github.io/apt-now/cmotc.github.io.gpg.key | tee config/archives/apt-now.list.key.chroot
	cd config/archives/ \
		&& ln -sf apt-now.list.chroot apt-now.list.binary \
		&& ln -sf apt-now.list.key.chroot apt-now.list.key.binary

lair-game-repo:
	echo "deb http://cmotc.github.io/lair-web/lair-deb/debian rolling main" | tee config/archives/lair.list.chroot
	echo "deb-src http://cmotc.github.io/lair-web/lair-deb/debian rolling main" | tee -a config/archives/lair.list.chroot
	curl -s https://cmotc.github.io/lair-web/lair-deb/cmotc.github.io.lair-web.lair-deb.gpg.key | tee -a config/archives/lair.list.key.chroot
	cd config/archives/ \
		&& ln -sf lair.list.chroot lair.list.binary \
		&& ln -sf lair.list.key.chroot lair.list.key.binary

custom:
	make apt-now-repo; \
	make lair-game-repo

skel:
	mkdir -p config/includes.chroot/etc/skel/Documents/Books/; \
	mkdir -p config/includes.chroot/etc/skel/Documents/Slideshows/; \
	mkdir -p config/includes.chroot/etc/skel/Documents/Papers/; \
	mkdir -p config/includes.chroot/etc/skel/Documents/Stories/; \
	mkdir -p config/includes.chroot/etc/skel/Documents/Letters/; \
	mkdir -p config/includes.chroot/etc/skel/Audio/Books/; \
	mkdir -p config/includes.chroot/etc/skel/Audio/Theatre/; \
	mkdir -p config/includes.chroot/etc/skel/Audio/Comedy/; \
	mkdir -p config/includes.chroot/etc/skel/Audio/Music/; \
	mkdir -p config/includes.chroot/etc/skel/Audio/Music/Rock/; \
	mkdir -p config/includes.chroot/etc/skel/Audio/Music/Rap/; \
	mkdir -p config/includes.chroot/etc/skel/Audio/Music/Alternative/; \
	mkdir -p config/includes.chroot/etc/skel/Audio/Music/Classical/; \
	mkdir -p config/includes.chroot/etc/skel/Audio/Music/Jazz/; \
	mkdir -p config/includes.chroot/etc/skel/Audio/Music/Blues/; \
	mkdir -p config/includes.chroot/etc/skel/Video/Movies/; \
	mkdir -p config/includes.chroot/etc/skel/Video/Television/; \
	mkdir -p config/includes.chroot/etc/skel/Video/Presentations/; \
	mkdir -p config/includes.chroot/etc/skel/Video/Classes/; \
	mkdir -p config/includes.chroot/etc/skel/ControlPanel/; \
	mkdir -p config/includes.chroot/etc/skel/Projects/; \
	mkdir -p config/includes.binary/etc/skel/Documents/Books/; \
	mkdir -p config/includes.binary/etc/skel/Documents/Slideshows/; \
	mkdir -p config/includes.binary/etc/skel/Documents/Papers/; \
	mkdir -p config/includes.binary/etc/skel/Documents/Stories/; \
	mkdir -p config/includes.binary/etc/skel/Documents/Letters/; \
	mkdir -p config/includes.binary/etc/skel/Audio/Books/; \
	mkdir -p config/includes.binary/etc/skel/Audio/Theatre/; \
	mkdir -p config/includes.binary/etc/skel/Audio/Comedy/; \
	mkdir -p config/includes.binary/etc/skel/Audio/Music/; \
	mkdir -p config/includes.binary/etc/skel/Audio/Music/Rock/; \
	mkdir -p config/includes.binary/etc/skel/Audio/Music/Rap/; \
	mkdir -p config/includes.binary/etc/skel/Audio/Music/Alternative/; \
	mkdir -p config/includes.binary/etc/skel/Audio/Music/Classical/; \
	mkdir -p config/includes.binary/etc/skel/Audio/Music/Jazz/; \
	mkdir -p config/includes.binary/etc/skel/Audio/Music/Blues/; \
	mkdir -p config/includes.binary/etc/skel/Video/Movies/; \
	mkdir -p config/includes.binary/etc/skel/Video/Television/; \
	mkdir -p config/includes.binary/etc/skel/Video/Presentations/; \
	mkdir -p config/includes.binary/etc/skel/Video/Classes/; \
	mkdir -p config/includes.binary/etc/skel/ControlPanel/; \
	mkdir -p config/includes.binary/etc/skel/Projects/; \
	echo "#bash aliases" | tee config/includes.chroot/etc/skel/.bash_aliases; \
	echo "#bash aliases" | tee config/includes.binary/etc/skel/.bash_aliases; \
	mkdir -p config/includes.chroot/etc/grsec; \
	mkdir -p config/includes.binary/etc/grsec; \
	mkdir -p config/includes.chroot/etc/grsec2; \
	mkdir -p config/includes.binary/etc/grsec2; \
	touch config/includes.chroot/etc/grsec2/pw; \
	touch config/includes.binary/etc/grsec2/pw; \
	echo "sudo gradm2 -P shutdown" | tee config/includes.chroot/etc/skel/grsec-firstrun.sh; \
	echo "sudo gradm2 -P admin" | tee -a config/includes.chroot/etc/skel/grsec-firstrun.sh; \
	echo "sudo gradm2 -P" | tee -a config/includes.chroot/etc/skel/grsec-firstrun.sh; \
	echo "sudo gradm2 -F -L /etc/grsec/learning.logs" | tee -a config/includes.chroot/etc/skel/grsec-firstrun.sh; \
	echo "sudo gradm2 -a admin" | tee -a config/includes.chroot/etc/skel/grsec-firstrun.sh; \
	echo "sudo gradm2 -P shutdown" | tee config/includes.binary/etc/skel/grsec-firstrun.sh; \
	echo "sudo gradm2 -P admin" | tee -a config/includes.binary/etc/skel/grsec-firstrun.sh; \
	echo "sudo gradm2 -P" | tee -a config/includes.binary/etc/skel/grsec-firstrun.sh; \
	echo "sudo gradm2 -a admin" | tee -a config/includes.binary/etc/skel/grsec-firstrun.sh; \
	echo "sudo gradm2 -F -L /etc/grsec/learning.logs" | tee -a config/includes.binary/etc/skel/grsec-firstrun.sh; \
	echo "sudo mv /etc/rc.local /etc/rc.local.bak \\ " | tee config/includes.chroot/etc/skel/grsec-firstshutdown.sh; \
	echo "	&& grep -v \"gradm2 -F -L /etc/grsec/learning.logs\" \"/etc/rc.local.bak\" > /etc/rc.local" | tee -a config/includes.chroot/etc/skel/grsec-firstshutdown.sh; \
	echo "sudo mv /etc/rc.local /etc/rc.local.bak \\ " | tee config/includes.binary/etc/skel/grsec-firstshutdown.sh; \
	echo "	&& grep -v \"gradm2 -F -L /etc/grsec/learning.logs\" \"/etc/rc.local.bak\" > /etc/rc.local" | tee -a config/includes.binary/etc/skel/grsec-firstshutdown.sh; \
	echo "sudo gradm2 -F -L /etc/grsec/learning.logs -O /etc/grsec/policy" | tee config/includes.chroot/etc/skel/grsec-learn.sh; \
	echo "sudo gradm2 -F -L /etc/grsec/learning.logs -O /etc/grsec/policy" | tee config/includes.binary/etc/skel/grsec-learn.sh; \


packages:
	cd config/package-lists/ && \
	rm build.list.chroot build.list.binary 2> /dev/null ; \
	echo "awesome" >> build.list.chroot && \
	echo "awesome-extra" >> build.list.chroot && \
	echo "coreutils" >> build.list.chroot && \
	echo "openrc" >> build.list.chroot && \
	echo "adduser" >> build.list.chroot && \
	echo "apparmor" >> build.list.chroot && \
	echo "apparmor-easyprof" >> build.list.chroot && \
	echo "apparmor-notify" >> build.list.chroot && \
	echo "apparmor-profiles" >> build.list.chroot && \
	echo "apparmor-profiles-extra" >> build.list.chroot && \
	echo "minidlna" >> build.list.chroot && \
	echo "openssh-server" >> build.list.chroot && \
	echo "pcmanfm" >> build.list.chroot && \
	echo "secure-delete" >> build.list.chroot && \
	echo "suckless-tools" >> build.list.chroot && \
	echo "menu-xdg" >> build.list.chroot && \
	echo "xdg-utils" >> build.list.chroot && \
	echo "xdg-user-dirs" >> build.list.chroot && \
	echo "git" >> build.list.chroot && \
	echo "tig" >> build.list.chroot && \
	echo "lightdm" >> build.list.chroot && \
	echo "wicd-curses" >> build.list.chroot && \
	echo "docker.io" >> build.list.chroot && \
	echo "medit" >> build.list.chroot && \
	echo "nano" >> build.list.chroot && \
	echo "jackd2" >> build.list.chroot && \
	echo "jack-mixer" >> build.list.chroot && \
	echo "alsaplayer-jack" >> build.list.chroot && \
	echo "pulseaudio-module-jack" >> build.list.chroot && \
	echo "tshark" >> build.list.chroot && \
	echo "mc" >> build.list.chroot && \
	echo "wget" >> build.list.chroot && \
	echo "pax-utils" >> build.list.chroot && \
	echo "paxtest" >> build.list.chroot && \
	echo "paxctld" >> build.list.chroot && \
	echo "gradm2" >> build.list.chroot && \
	echo "apt-build" >> build.list.chroot && \
	echo "pandoc" >> build.list.chroot && \
	echo "python-vte" >> build.list.chroot && \
	echo "syncthing" >> build.list.chroot && \
	echo "mutt" >> build.list.chroot && \
	echo "lftp" >> build.list.chroot && \
	echo "rtl-sdr" >> build.list.chroot && \
	echo "vlc" >> build.list.chroot && \
	echo "tor" >> build.list.chroot && \
	echo "tor-arm" >> build.list.chroot && \
	echo "keychain" >> build.list.chroot && \
	echo "sen" >> build.list.chroot && \
	echo "sakura" >> build.list.chroot && \
	echo "uzbl" >> build.list.chroot && \
	echo "ricin" >> build.list.chroot && \
	echo "surfraw" >> build.list.chroot && \
	echo "surfraw-extra" >> build.list.chroot && \
	echo "rclone" >> build.list.chroot && \
	echo "sshfs" >> build.list.chroot && \
	echo "megatools" >> build.list.chroot && \
	echo "youtube-dl" >> build.list.chroot && \
	echo "newsbeuter" >> build.list.chroot && \
	echo "wikipedia2text" >> build.list.chroot && \
	echo "libgnutls30" >> build.list.chroot && \
	echo "owncloud-client-cmd" >> build.list.chroot && \
	echo "gnutls-bin" >> build.list.chroot && \
	echo "firmware-ath9k-htc" >> build.list.chroot && \
	echo "firmware-linux-free" >> nonfree.list.chroot && \
	echo "xserver-xorg" >> build.list.chroot && \
	echo "xserver-common" >> build.list.chroot && \
	echo "xserver-xorg-core" >> build.list.chroot && \
	echo "xserver-xorg-input-all" >> build.list.chroot && \
	echo "xserver-xorg-legacy" >> build.list.chroot && \
	echo "xserver-xorg-video-all" >> build.list.chroot && \
	ln -sf build.list.chroot build.list.binary

nonfree-firmware:
	cd config/package-lists/ && \
	rm nonfree.list.chroot nonfree.list.binary 2> /dev/null ; \
	echo "b43-fwcutter" >> nonfree.list.chroot && \
	echo "firmware-b43-installer" >> nonfree.list.chroot && \
	echo "firmware-b43legacy-installer" >> nonfree.list.chroot && \
	ln -sf nonfree.list.chroot nonfree.list.binary

easy-user:
	echo "#!/bin/sh -e" > config/includes.chroot/etc/rc.local
	echo "exit 0" >> config/includes.chroot/etc/rc.local
	echo "#!/bin/sh -e" > config/includes.binary/etc/rc.local
	echo "exit 0" >> config/includes.binary/etc/rc.local
	mkdir -p config/includes.chroot/etc/live/config/
	echo 'LIVE_USER_DEFAULT_GROUPS="audio cdrom dip floppy video plugdev netdev powerdev scanner bluetooth fuse docker"' > config/includes.chroot/etc/live/config/user-setup.conf
	echo "d-i passwd/user-default-groups cdrom floppy audio dip video plugdev netdev scanner bluetooth wireshark docker lpadmin" > config/preseed/preseed.cfg.chroot
	echo "d-i partman-auto/choose_recipe select atomic" >> config/preseed/preseed.cfg.chroot
	echo "d-i partman-basicfilesystems/no_swap boolean false">> config/preseed/preseed.cfg.chroot
	echo 'd-i partman-auto/expert_recipe string boot-root : \'>> config/preseed/preseed.cfg.chroot
	echo '5120 1 -1 btrfs \'>> config/preseed/preseed.cfg.chroot
	echo '\$primary{ } \$bootable{ } \>> config/preseed/preseed.cfg.chroot
	echo 'method{ format } format{ } \'>> config/preseed/preseed.cfg.chroot
	echo 'use_filesystem{ } filesystem{ btrfs } \'>> config/preseed/preseed.cfg.chroot
	echo "label { root } mountpoint{ / } .">> config/preseed/preseed.cfg.chroot
	echo "d-i passwd/user-default-groups cdrom floppy audio dip video plugdev netdev scanner bluetooth wireshark docker lpadmin" > config/preseed/preseed.cfg.binary
	echo "d-i partman-auto/choose_recipe select atomic" >> config/preseed/preseed.cfg.binary
	echo "d-i partman-basicfilesystems/no_swap boolean false">> config/preseed/preseed.cfg.binary
	echo 'd-i partman-auto/expert_recipe string boot-root : \'>> config/preseed/preseed.cfg.binary
	echo '5120 1 -1 btrfs \'>> config/preseed/preseed.cfg.binary
	echo '\$primary{ } \$bootable{ } \'>> config/preseed/preseed.cfg.binary
	echo 'method{ format } format{ } \'>> config/preseed/preseed.cfg.binary
	echo 'use_filesystem{ } filesystem{ btrfs } \'>> config/preseed/preseed.cfg.binary
	echo "label { root } mountpoint{ / } .">> config/preseed/preseed.cfg.binary

permissive-user:
	echo "#!/bin/sh -e" > config/includes.chroot/etc/rc.local
	echo "exit 0" >> config/includes.chroot/etc/rc.local
	echo "#!/bin/sh -e" > config/includes.binary/etc/rc.local
	echo "gradm2 -F -L /etc/grsec/learning.logs &" >> config/includes.binary/etc/rc.local
	echo "exit 0" >> config/includes.binary/etc/rc.local
	mkdir -p config/includes.chroot/etc/live/config/
	echo 'LIVE_USER_DEFAULT_GROUPS="audio cdrom dip floppy video plugdev netdev powerdev scanner bluetooth fuse docker grsec-tpe"' > config/includes.chroot/etc/live/config/user-setup.conf
	echo "d-i passwd/user-default-groups cdrom floppy audio dip video plugdev netdev scanner bluetooth wireshark docker grsec-tpe lpadmin" > config/preseed/preseed.cfg.chroot
	echo "d-i partman-auto/choose_recipe select atomic" >> config/preseed/preseed.cfg.chroot
	echo "d-i partman-basicfilesystems/no_swap boolean false">> config/preseed/preseed.cfg.chroot
	echo 'd-i partman-auto/expert_recipe string boot-root : \'>> config/preseed/preseed.cfg.chroot
	echo '5120 1 -1 btrfs \'>> config/preseed/preseed.cfg.chroot
	echo '\$primary{ } \$bootable{ } \'>> config/preseed/preseed.cfg.chroot
	echo 'method{ format } format{ } \'>> config/preseed/preseed.cfg.chroot
	echo 'use_filesystem{ } filesystem{ btrfs } \'>> config/preseed/preseed.cfg.chroot
	echo "label { root } mountpoint{ / } .">> config/preseed/preseed.cfg.chroot
	echo "d-i passwd/user-default-groups cdrom floppy audio dip video plugdev netdev scanner bluetooth wireshark docker grsec-tpe lpadmin" > config/preseed/preseed.cfg.binary
	echo "d-i partman-auto/choose_recipe select atomic" >> config/preseed/preseed.cfg.binary
	echo "d-i partman-basicfilesystems/no_swap boolean false">> config/preseed/preseed.cfg.binary
	echo 'd-i partman-auto/expert_recipe string boot-root : \'>> config/preseed/preseed.cfg.binary
	echo '5120 1 -1 btrfs \'>> config/preseed/preseed.cfg.binary
	echo '\$primary{ } \$bootable{ } \'>> config/preseed/preseed.cfg.binary
	echo 'method{ format } format{ } \'>> config/preseed/preseed.cfg.binary
	echo 'use_filesystem{ } filesystem{ btrfs } \'>> config/preseed/preseed.cfg.binary
	echo "label { root } mountpoint{ / } .">> config/preseed/preseed.cfg.binary


build:
	make packages
	sudo lb build

docker-init:
	mkdir -p .build

docker:
	docker build -t hoarder-build .

docker-build:
	docker run --privileged -t hoarder-build lb build

allclean:
	make clean ; \
	make all

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

backup:
	scp tv-amd64.hybrid.iso media@192.168.2.206:os_backups/
	scp tv-amd64.files media@192.168.2.206:os_backups/
	scp tv-amd64.contents media@192.168.2.206:os_backups/
	scp tv-amd64.hybrid.iso.zsync media@192.168.2.206:os_backups/
	scp tv-amd64.packages media@192.168.2.206:os_backups/

backup-custom:
	scp tv-amd64.hybrid.iso media@192.168.2.206:os_backups/
	scp tv-amd64.files media@192.168.2.206:os_backups/
	scp tv-amd64.contents media@192.168.2.206:os_backups/
	scp tv-amd64.hybrid.iso.zsync media@192.168.2.206:os_backups/
	scp tv-amd64.packages media@192.168.2.206:os_backups/

backup-hardened:
	scp tv-hardened-amd64.hybrid.iso media@192.168.2.206:os_backups/
	scp tv-hardened-amd64.files media@192.168.2.206:os_backups/
	scp tv-hardened-amd64.contents media@192.168.2.206:os_backups/
	scp tv-hardened-amd64.hybrid.iso.zsync media@192.168.2.206:os_backups/
	scp tv-hardened-amd64.packages media@192.168.2.206:os_backups/

backup-hardened-custom:
	scp tv-hardened-amd64.hybrid.iso media@192.168.2.206:os_backups/
	scp tv-hardened-amd64.files media@192.168.2.206:os_backups/
	scp tv-hardened-amd64.contents media@192.168.2.206:os_backups/
	scp tv-hardened-amd64.hybrid.iso.zsync media@192.168.2.206:os_backups/
	scp tv-hardened-amd64.packages media@192.168.2.206:os_backups/

backup-nonfree:
	scp tv-nonfree-amd64.hybrid.iso media@192.168.2.206:os_backups/
	scp tv-nonfree-amd64.files media@192.168.2.206:os_backups/
	scp tv-nonfree-amd64.contents media@192.168.2.206:os_backups/
	scp tv-nonfree-amd64.hybrid.iso.zsync media@192.168.2.206:os_backups/
	scp tv-nonfree-amd64.packages media@192.168.2.206:os_backups/

backup-nonfree-custom:
	scp tv-nonfree-amd64.hybrid.iso media@192.168.2.206:os_backups/
	scp tv-nonfree-amd64.files media@192.168.2.206:os_backups/
	scp tv-nonfree-amd64.contents media@192.168.2.206:os_backups/
	scp tv-nonfree-amd64.hybrid.iso.zsync media@192.168.2.206:os_backups/
	scp tv-nonfree-amd64.packages media@192.168.2.206:os_backups/

backup-nonfree-hardened-custom:
	scp tv-nonfree-hardened-amd64.hybrid.iso media@192.168.2.206:os_backups/
	scp tv-nonfree-hardened-amd64.files media@192.168.2.206:os_backups/
	scp tv-nonfree-hardened-amd64.contents media@192.168.2.206:os_backups/
	scp tv-nonfree-hardened-amd64.hybrid.iso.zsync media@192.168.2.206:os_backups/
	scp tv-nonfree-hardened-amd64.packages media@192.168.2.206:os_backups/
