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
	lb config -k grsec-amd64

config-nonfree:
	lb config --archive-areas "main contrib nonfree" \
		--source false

syncthing-repo:
	echo "deb http://apt.syncthing.net/ syncthing release" | tee config/archives/syncthing.list.chroot
	curl -s https://syncthing.net/release-key.txt > config/archives/syncthing.list.key.chroot
	cd config/archives/ \
		&& ln -s syncthing.list.chroot syncthing.list.binary \
		&& ln -s syncthing.list.key.chroot syncthing.list.key.binary

i2pd-repo:
	echo "deb http://repo.lngserv.ru/debian jessie main" | tee config/archives/i2pd.list.chroot
	echo "deb-src http://repo.lngserv.ru/debian jessie main" | tee -a config/archives/i2pd.list.chroot
	gpg --keyserver keys.gnupg.net --recv-keys 98EBCFE2; \
	gpg -a --export 98EBCFE2 | tee config/archives/i2pd.list.key.chroot
	cd config/archives/ \
		&& ln -s i2pd.list.chroot i2pd.list.binary \
		&& ln -s i2pd.list.key.chroot i2pd.list.key.binary


skel:
	mkdir -p config/includes.chroot/etc/skel/Documents/Books/; \
	mkdir -p config/includes.chroot/etc/skel/Documents/Slideshows/; \
	mkdir -p config/includes.chroot/etc/skel/Documents/Papers/; \
	mkdir -p config/includes.chroot/etc/skel/Documents/Stories/; \
	mkdir -p config/includes.chroot/etc/skel/Documents/Letters/; \
	mkdir -p config/includes.chroot/etc/skel/Audio/Books/; \
	mkdir -p config/includes.chroot/etc/skel/Audio/Theatre/; \
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
	echo "#bash aliases" | tee config/includes.binary/etc/skel/.bash_aliases;


packages:
	cd config/package-lists/ && \
	rm build.list.chroot build.list.binary 2> /dev/null ; \
	echo "awesome" >> build.list.chroot && \
	echo "awesome-extra" >> build.list.chroot && \
	echo "coreutils" >> build.list.chroot && \
	echo "openrc" >> build.list.chroot && \
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
	echo "mc" >> build.list.chroot && \
	echo "apt-build" >> build.list.chroot && \
	echo "pandoc" >> build.list.chroot && \
	echo "python-vte" >> build.list.chroot && \
	echo "syncthing" >> build.list.chroot && \
	echo "mutt" >> build.list.chroot && \
	echo "lftp" >> build.list.chroot && \
	echo "rtl-sdr" >> build.list.chroot && \
	echo "vlc" >> build.list.chroot && \
	echo "keychain" >> build.list.chroot && \
	echo "sen" >> build.list.chroot && \
	echo "sakura" >> build.list.chroot && \
	echo "uzbl" >> build.list.chroot && \
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
	echo "xserver-xorg" >> build.list.chroot && \
	echo "xserver-common" >> build.list.chroot && \
	echo "xserver-xorg-core" >> build.list.chroot && \
	echo "xserver-xorg-input-all" >> build.list.chroot && \
	echo "xserver-xorg-legacy" >> build.list.chroot && \
	echo "xserver-xorg-video-all" >> build.list.chroot && \
	ln -s build.list.chroot build.list.binary

build:
	make packages
	sudo lb build

all:
	make clean ; \
	make config ; \
	make syncthing-repo; \
	make i2pd-repo; \
	make skel; \
	make packages ; \
	make build

all-nonfree:
	make clean ; \
	make config-nonfree ; \
	make syncthing-repo; \
	make i2pd-repo; \
	make skel; \
	make packages ; \
	make build
