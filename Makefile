expose:
	echo "clean = sudo lb clean"
	echo "config = lb config"
	echo "build =sudo lb build"
	echo "all = clean; config; build"
	echo "packages = echo \"package list\""
	cat config/package-lists/build.list.chroot

clean:
	sudo lb clean; echo "cleaned"

config:
	lb config

config-nonfree:
	lb config --archive-areas "main contrib nonfree" \
		--source false

packages:
	cd config/package-lists/ && \
	rm build.list.chroot build.list.binary 2> /dev/null ; \
	echo "openbox" >> build.list.chroot && \
	echo "openbox-menu" >> build.list.chroot && \
	echo "obmenu" >> build.list.chroot && \
	echo "obconf" >> build.list.chroot && \
	echo "openrc" >> build.list.chroot && \
	echo "apparmor" >> build.list.chroot && \
	echo "apparmor-easyprof" >> build.list.chroot && \
	echo "apparmor-notify" >> build.list.chroot && \
	echo "apparmor-profiles" >> build.list.chroot && \
	echo "apparmor-profiles-extra" >> build.list.chroot && \
	echo "minidlna" >> build.list.chroot && \
	echo "openssh-server" >> build.list.chroot && \
	echo "tint2" >> build.list.chroot && \
	echo "secure-delete" >> build.list.chroot && \
	echo "suckless-tools" >> build.list.chroot && \
	echo "git" >> build.list.chroot && \
	echo "tig" >> build.list.chroot && \
	echo "lightdm" >> build.list.chroot && \
	echo "wicd-gtk" >> build.list.chroot && \
	echo "docker.io" >> build.list.chroot && \
	echo "vlc" >> build.list.chroot && \
	echo "sakura" >> build.list.chroot && \
	echo "uzbl" >> build.list.chroot && \
	echo "surfraw" >> build.list.chroot && \
	echo "surfraw-extra" >> build.list.chroot && \
	echo "rclone" >> build.list.chroot && \
	echo "sshfs" >> build.list.chroot && \
	echo "megatools" >> build.list.chroot && \
	echo "youtube-dl" >> build.list.chroot && \
	echo "wikipedia2text" >> build.list.chroot && \
	echo "xserver" >> build.list.chroot && \
	echo "xserver-common" >> build.list.chroot && \
	echo "xserver-xorg-*" >> build.list.chroot && \
	ln -s build.list.chroot build.list.binary

build:
	make packages
	sudo lb build

all:
	make clean ; \
	make config ; \
	make packages ; \
	make build

all-nonfree:
	make clean ; \
	make config-nonfree ; \
	make packages ; \
	make build
