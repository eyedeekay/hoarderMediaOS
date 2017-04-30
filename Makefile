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

packages:
	cd config/package-lists/ && \
	rm build.list.chroot build.list.binary 2> /dev/null ; \
	echo "openbox" >> build.list.chroot && \
	echo "openbox-menu" >> build.list.chroot && \
	echo "obmenu" >> build.list.chroot && \
	echo "obconf" >> build.list.chroot && \
	echo "tint2" >> build.list.chroot && \
	echo "xdm" >> build.list.chroot && \
	echo "wicd-gtk" >> build.list.chroot && \
	echo "vlc" >> build.list.chroot && \
	echo "youtube-dl" >> build.list.chroot && \
	echo "wikipedia2text" >> build.list.chroot && \
	ln -s build.list.chroot build.list.binary

build:
	sudo lb build

all:
	make clean ; \
	make config ; \
	make packages ; \
	make build

