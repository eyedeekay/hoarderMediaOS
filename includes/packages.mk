packages:
	cd config/package-lists/ && \
	echo "awesome" | tee -a build.list.chroot && \
	echo "awesome-extra" | tee -a build.list.chroot && \
	echo "auto-apt-proxy" | tee -a build.list.chroot && \
	echo "apt-transport-tor" | tee -a build.list.chroot && \
	echo "apt-transport-https" | tee -a build.list.chroot && \
	echo "ca-certificates" | tee -a build.list.chroot && \
	echo "coreutils" | tee -a build.list.chroot && \
	echo "openrc" | tee -a build.list.chroot && \
	echo "adduser" | tee -a build.list.chroot && \
	echo "apparmor" | tee -a build.list.chroot && \
	echo "apparmor-easyprof" | tee -a build.list.chroot && \
	echo "apparmor-notify" | tee -a build.list.chroot && \
	echo "apparmor-profiles" | tee -a build.list.chroot && \
	echo "apparmor-profiles-extra" | tee -a build.list.chroot && \
	echo "minidlna" | tee -a build.list.chroot && \
	echo "openssh-server" | tee -a build.list.chroot && \
	echo "pcmanfm" | tee -a build.list.chroot && \
	echo "secure-delete" | tee -a build.list.chroot && \
	echo "iproute2" | tee -a build.list.chroot && \
	echo "stterm" | tee -a build.list.chroot && \
	echo "suckless-tools" | tee -a build.list.chroot && \
	echo "menu-xdg" | tee -a build.list.chroot && \
	echo "xdg-utils" | tee -a build.list.chroot && \
	echo "xdg-user-dirs" | tee -a build.list.chroot && \
	echo "git" | tee -a build.list.chroot && \
	echo "tig" | tee -a build.list.chroot && \
	echo "sddm" | tee -a build.list.chroot && \
	echo "wicd-curses" | tee -a build.list.chroot && \
	echo "docker.io" | tee -a build.list.chroot && \
	echo "medit" | tee -a build.list.chroot && \
	echo "nano" | tee -a build.list.chroot && \
	echo "firejail" | tee -a build.list.chroot && \
	echo "gocryptfs" | tee -a build.list.chroot && \
	echo "jackd2" | tee -a build.list.chroot && \
	echo "alsaplayer-jack" | tee -a build.list.chroot && \
	echo "pulseaudio-module-jack" | tee -a build.list.chroot && \
	echo "tshark" | tee -a build.list.chroot && \
	echo "mc" | tee -a build.list.chroot && \
	echo "wget" | tee -a build.list.chroot && \
	echo "pax-utils" | tee -a build.list.chroot && \
	echo "paxtest" | tee -a build.list.chroot && \
	echo "paxctld" | tee -a build.list.chroot && \
	echo "gradm2" | tee -a build.list.chroot && \
	echo "apt-build" | tee -a build.list.chroot && \
	echo "pandoc" | tee -a build.list.chroot && \
	echo "python-vte" | tee -a build.list.chroot && \
	echo "syncthing" | tee -a build.list.chroot && \
	echo "mosh" | tee -a build.list.chroot && \
	echo "mutt" | tee -a build.list.chroot && \
	echo "lftp" | tee -a build.list.chroot && \
	echo "rtl-sdr" | tee -a build.list.chroot && \
	echo "vlc" | tee -a build.list.chroot && \
	echo "tor" | tee -a build.list.chroot && \
	echo "tor-arm" | tee -a build.list.chroot && \
	echo "keychain" | tee -a build.list.chroot && \
	echo "sen" | tee -a build.list.chroot && \
	echo "stterm" | tee -a build.list.chroot && \
	echo "surf" | tee -a build.list.chroot && \
	echo "surfraw" | tee -a build.list.chroot && \
	echo "surfraw-extra" | tee -a build.list.chroot && \
	echo "tmux" | tee -a build.list.chroot && \
	echo "rclone" | tee -a build.list.chroot && \
	echo "sshfs" | tee -a build.list.chroot && \
	echo "plowshare" | tee -a build.list.chroot && \
	echo "plowshare-modules" | tee -a build.list.chroot && \
	echo "megatools" | tee -a build.list.chroot && \
	echo "youtube-dl" | tee -a build.list.chroot && \
	echo "newsbeuter" | tee -a build.list.chroot && \
	echo "wikipedia2text" | tee -a build.list.chroot && \
	echo "libgnutls30" | tee -a build.list.chroot && \
	echo "owncloud-client-cmd" | tee -a build.list.chroot && \
	echo "gnutls-bin" | tee -a build.list.chroot && \
	echo "firmware-ath9k-htc" | tee -a build.list.chroot && \
	echo "firmware-linux-free" | tee -a nonfree.list.chroot && \
	echo "xwayland" | tee -a build.list.chroot && \
	echo "xserver-xorg" | tee -a build.list.chroot && \
	echo "xserver-common" | tee -a build.list.chroot && \
	echo "xserver-xorg-core" | tee -a build.list.chroot && \
	echo "xserver-xorg-input-all" | tee -a build.list.chroot && \
	echo "xserver-xorg-legacy" | tee -a build.list.chroot && \
	echo "xserver-xorg-video-all" | tee -a build.list.chroot && \
	ln -sf build.list.chroot build.list.binary

nonfree-firmware:
	cd config/package-lists/ && \
	echo "b43-fwcutter" | tee -a nonfree.list.chroot && \
	echo "firmware-b43-installer" | tee -a nonfree.list.chroot && \
	echo "firmware-b43legacy-installer" | tee -a nonfree.list.chroot && \
	ln -sf nonfree.list.chroot nonfree.list.binary
