packages:
	cd config/package-lists/ && \
	echo "awesome" >> build.list.chroot && \
	echo "awesome-extra" >> build.list.chroot && \
	echo "apt-transport-tor" >> build.list.chroot && \
	echo "apt-transport-https" >> build.list.chroot && \
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
	echo "firejail" >> build.list.chroot && \
	echo "gocryptfs" >> build.list.chroot && \
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
