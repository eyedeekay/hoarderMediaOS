define PACKAGE_LIST
awesome
awesome-extra
auto-apt-proxy
apt-transport-tor
apt-transport-https
ca-certificates
coreutils
openrc
adduser
apparmor
apparmor-easyprof
apparmor-notify
apparmor-profiles
apparmor-profiles-extra
minidlna
openssh-server
pcmanfm
secure-delete
iproute2
stterm
suckless-tools
menu-xdg
xdg-utils
xdg-user-dirs
git
tig
sddm
wicd-curses
docker.io
medit
nano
firejail
gocryptfs
jackd2
alsaplayer-jack
pulseaudio-module-jack
tshark
mc
wget
pax-utils
paxtest
paxctld
gradm2
apt-build
pandoc
python-vte
syncthing
mosh
mutt
lftp
rtl-sdr
vlc
tor
tor-arm
keychain
sen
stterm
surf
surfraw
surfraw-extra
tmux
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
xwayland
xserver-xorg
xserver-common
xserver-xorg-core
xserver-xorg-input-all
xserver-xorg-legacy
xserver-xorg-video-all
endef

export PACKAGE_LIST

packlist:
	@echo "$$PACKAGE_LIST"

packages:
	cd config/package-lists/ && \
	@echo "$$PACKAGE_LIST" tee -a build.list.chroot && \
	ln -sf build.list.chroot build.list.binary

nonfree-firmware:
	cd config/package-lists/ && \
	echo "b43-fwcutter" | tee -a nonfree.list.chroot && \
	echo "firmware-b43-installer" | tee -a nonfree.list.chroot && \
	echo "firmware-b43legacy-installer" | tee -a nonfree.list.chroot && \
	ln -sf nonfree.list.chroot nonfree.list.binary
