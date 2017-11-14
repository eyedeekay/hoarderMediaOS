define PACKAGE_LIST
awesome
awesome-extra
sddm
stterm
tmux
surf
surfraw
surfraw-extra
dpkg
apt-file
apt-transport-tor
apt-transport-https
apt-utils
ca-certificates
coreutils
moreutils
dpkg
adduser
apparmor
apparmor-easyprof
apparmor-notify
apparmor-profiles
apparmor-profiles-extra
bubblewrap
firejail
pcmanfm
secure-delete
ifupdown
iproute2
stterm
suckless-tools
menu-xdg
xdg-utils
xdg-user-dirs
git
wget
curl
tig
wicd-curses
docker.io
medit
nano
gocryptfs
jackd2
alsaplayer-jack
pulseaudio-module-jack
tshark
mc
pax-utils
paxtest
paxctld
pandoc
syncthing
procps
mosh
mutt
lftp
rtl-sdr
vlc
tor
tor-arm
keychain
sen
rclone
sshfs
plowshare
plowshare-modules
megatools
youtube-dl
newsbeuter
wikipedia2text
libgnutls30
owncloud-client-cmd
gnutls-bin
firmware-ath9k-htc
firmware-linux-free
udev
dbus
util-linux
default-dbus-session-bus
xwayland
xserver-xorg
xserver-common
xserver-xorg-core
xserver-xorg-input-all
xserver-xorg-legacy
xserver-xorg-video-all

endef

export PACKAGE_LIST

define INIT_SYSTEM
live-boot
live-config
live-config-sysvinit
sysvinit-core
openrc
initscripts
endef

export INIT_SYSTEM

define SERVER_PACKAGE_LIST
openssh-server
mosh
minidlna

endef

export SERVER_PACKAGE_LIST

packlist:
	@echo "$(PACKAGE_LIST)"

init-system:
	cd config/package-lists/ && \
	echo "$(INIT_SYSTEM)" | tee live.list.chroot && \
	ln -sf live.list.chroot live.list.binary

packages-list: init-system
	cd config/package-lists/ && \
	echo "$(PACKAGE_LIST)" | tee build.list.chroot && \
	ln -sf build.list.chroot build.list.binary

server-packages:
	cd config/package-lists/ && \
	echo "$(SERVER_PACKAGE_LIST)" | tee server.list.chroot && \
	ln -sf server.list.chroot server.list.binary

nonfree-firmware:
	cd config/package-lists/ && \
	echo "b43-fwcutter" | tee nonfree.list.chroot && \
	echo "firmware-b43-installer" | tee -a nonfree.list.chroot && \
	echo "firmware-b43legacy-installer" | tee -a nonfree.list.chroot && \
	ln -sf nonfree.list.chroot nonfree.list.binary
