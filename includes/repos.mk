
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
	curl -s https://download.opensuse.org/repositories/home:/stevenpusser/Debian_9.0/Release.key | tee config/archives/palemoon.list.key.chroot
	cd config/archives/ \
		&& ln -sf palemoon.list.chroot palemoon.list.binary \
		&& ln -sf palemoon.list.key.chroot palemoon.list.key.binary

##Nonfree or Uncertain-status repos

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
