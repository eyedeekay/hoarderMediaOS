
proxy-setup:
	echo "Acquire::HTTP::Proxy $(proxy_addr);" | tee /etc/apt/apt.conf.d/01proxy
	echo 'Acquire::HTTPS::Proxy-Auto-Detect "/usr/bin/auto-apt-proxy";' | tee -a /etc/apt/apt.conf.d/01proxy
	echo 'Acquire::http::Proxy-Auto-Detect "/usr/bin/auto-apt-proxy";' | tee -a /etc/apt/apt.conf.d/auto-apt-proxy.conf


devuan-key:
	echo "deb $(proxy_addr)us.mirror.devuan.org/merged ceres main" | tee config/archives/devuan.list.chroot
	echo "deb-src http://us.mirror.devuan.org/merged ceres main" | tee -a config/archives/devuan.list.chroot
	echo "deb $(proxy_addr)us.mirror.devuan.org/devuan ceres main" | tee -a config/archives/devuan.list.chroot
	echo "deb-src http://us.mirror.devuan.org/devuan ceres main" | tee -a config/archives/devuan.list.chroot
	cd config/archives/ \
		&& ln -sf nonfree.list.chroot nonfree.list.binary
	gpg --keyserver $(keyserver) --recv-keys 94532124541922FB; \
	gpg -a --export 94532124541922FB | tee config/archives/devuan.list.key.chroot
	cd config/archives/ \
		&& ln -sf devuan.list.key.chroot devuan.list.key.binary
	#echo "deb $(proxy_addr)ftp.us.debian.org/debian/ sid main" | tee config/archives/sid.list.chroot
	gpg --keyserver $(keyserver) --recv-keys EF0F382A1A7B6500; \
	gpg -a --export EF0F382A1A7B6500 | tee config/archives/sid.list.key.chroot
	cd config/archives/ \
		&& ln -sf sid.list.key.chroot sid.list.key.binary
	@echo "Package: *" | tee config/archives/debdev.pref
	@echo "Pin: release a=ceres" | tee -a config/archives/debdev.pref
	@echo "Pin-Priority: 999" | tee -a config/archives/debdev.pref
	@echo "Package: *" | tee -a config/archives/debdev.pref
	@echo "Pin: release a=sid" | tee -a config/archives/debdev.pref
	@echo "Pin-Priority: 990" | tee -a config/archives/debdev.pref
	cd config/archives/ \
		&& ln -sf debdev.pref debdev.pref.chroot
	cp config/archives/debdev.pref config/apt/preferences


apt-now-repo:
	echo "deb $(proxy_addr)eyedeekay.github.io/apt-now/deb-pkg rolling main" | tee config/archives/apt-now.list.chroot
	echo "deb-src http://eyedeekay.github.io/apt-now/deb-pkg rolling main" | tee -a config/archives/apt-now.list.chroot
	curl -s https://eyedeekay.github.io/apt-now/eyedeekay.github.io.gpg.key | tee config/archives/apt-now.list.key.chroot
	cd config/archives/ \
		&& ln -sf apt-now.list.chroot apt-now.list.binary \
		&& ln -sf apt-now.list.key.chroot apt-now.list.key.binary

lair-game-repo:
	echo "deb $(proxy_addr)eyedeekay.github.io/lair-web/lair-deb/debian rolling main" | tee config/archives/lair.list.chroot
	echo "deb-src http://eyedeekay.github.io/lair-web/lair-deb/debian rolling main" | tee -a config/archives/lair.list.chroot
	curl -s https://eyedeekay.github.io/lair-web/lair-deb/cmotc.github.io.lair-web.lair-deb.gpg.key | tee -a config/archives/lair.list.key.chroot
	cd config/archives/ \
		&& ln -sf lair.list.chroot lair.list.binary \
		&& ln -sf lair.list.key.chroot lair.list.key.binary

syncthing-repo:
	echo "deb $(proxy_addr)apt.syncthing.net/ syncthing release" | tee config/archives/syncthing.list.chroot
	curl -s https://syncthing.net/release-key.txt | tee config/archives/syncthing.list.key.chroot
	cd config/archives/ \
		&& ln -sf syncthing.list.chroot syncthing.list.binary \
		&& ln -sf syncthing.list.key.chroot syncthing.list.key.binary

emby-repo:
	echo "deb $(proxy_addr)download.opensuse.org/repositories/home:/emby/Debian_Next/ /" | tee config/archives/emby.list.chroot
	curl -s https://download.opensuse.org/repositories/home:/emby/Debian_Next/Release.key | tee config/archives/emby.list.key.chroot
	cd config/archives/ \
		&& ln -sf emby.list.chroot emby.list.binary \
		&& ln -sf emby.list.key.chroot emby.list.key.binary

i2pd-repo:
	echo "deb $(proxy_addr)repo.lngserv.ru/debian jessie main" | tee config/archives/i2pd.list.chroot
	echo "deb-src http://repo.lngserv.ru/debian jessie main" | tee -a config/archives/i2pd.list.chroot
	echo "#deb $(proxy_addr)i2p.repo jessie main" | tee -a config/archives/i2pd.list.chroot
	echo "#deb-src http://i2p.repo jessie main" | tee -a config/archives/i2pd.list.chroot
	gpg --keyserver $(keyserver) --recv-keys 66F6C87B98EBCFE2; \
	gpg -a --export 66F6C87B98EBCFE2 | tee config/archives/i2pd.list.key.chroot
	cd config/archives/ \
		&& ln -sf i2pd.list.chroot i2pd.list.binary \
		&& ln -sf i2pd.list.key.chroot i2pd.list.key.binary

tor-repo:
	echo "deb $(proxy_addr)deb.torproject.org/torproject.org sid main" | tee config/archives/tor.list.chroot
	echo "deb-src http://deb.torproject.org/torproject.org sid main" | tee -a config/archives/tor.list.chroot
	gpg --keyserver $(keyserver) --recv-keys A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89; \
	gpg -a --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | tee config/archives/tor.list.key.chroot
	cd config/archives/ \
		&& ln -sf tor.list.chroot tor.list.binary \
		&& ln -sf tor.list.key.chroot tor.list.key.binary

tor-ubuntu-repo:
	echo "deb $(proxy_addr)deb.torproject.org/torproject.org zesty main" | tee config/archives/tor.list.chroot
	echo "deb-src http://deb.torproject.org/torproject.org zesty main" | tee -a config/archives/tor.list.chroot
	gpg --keyserver $(keyserver) --recv-keys A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89; \
	gpg -a --export A3C4F0F979CAA22CDBA8F512EE8CBC9E886DDD89 | tee config/archives/tor.list.key.chroot
	cd config/archives/ \
		&& ln -sf tor.list.chroot tor.list.binary \
		&& ln -sf tor.list.key.chroot tor.list.key.binary

tox-repo:
	echo "deb $(proxy_addr)pkg.tox.chat/debian stable sid" | tee config/archives/tox.list.chroot
	echo "#deb $(proxy_addr)tox.repo stable sid" | tee config/archives/tox.list.chroot
	curl -s https://pkg.tox.chat/debian/pkg.gpg.key | tee config/archives/tox.list.key.chroot
	cd config/archives/ \
		&& ln -sf tox.list.chroot tox.list.binary \
		&& ln -sf tox.list.key.chroot tox.list.key.binary

palemoon-repo:
	echo 'deb $(proxy_addr)download.opensuse.org/repositories/home:/stevenpusser/Debian_9.0/ /' | tee config/archives/palemoon.list.chroot
	curl -s https://download.opensuse.org/repositories/home:/stevenpusser/Debian_9.0/Release.key | tee config/archives/palemoon.list.key.chroot
	cd config/archives/ \
		&& ln -sf palemoon.list.chroot palemoon.list.binary \
		&& ln -sf palemoon.list.key.chroot palemoon.list.key.binary

##Nonfree or Uncertain-status repos

nonfree-repo:
	echo "deb $(proxy_addr)ftp.us.debian.org/debian/ sid contrib nonfree" | tee config/archives/nonfree.list.chroot
	cd config/archives/ \
		&& ln -sf nonfree.list.chroot nonfree.list.binary
	echo "deb $(proxy_addr)ftp.us.debian.org/debian/ jessie contrib nonfree" | tee config/archives/nonfree-jessie.list.chroot
	cd config/archives/ \
		&& ln -sf nonfree.list.chroot nonfree.list.binary
	#echo "deb $(mirror) unstable contrib nonfree" | tee config/archives/nonfree.list.chroot
	#cd config/archives/ \
		#&& ln -sf nonfree.list.chroot nonfree.list.binary
	#echo "deb $(mirror) jessie contrib nonfree" | tee config/archives/nonfree-jessie.list.chroot
	#cd config/archives/ \
		#&& ln -sf nonfree.list.chroot nonfree.list.binary

nonfree-ubuntu-repo:
	echo "deb $(proxy_addr)archive.ubuntu.com/ubuntu/ artful restricted universe multiverse partner" | tee config/archives/nonfree.list.chroot
	cd config/archives/ \
		&& ln -sf nonfree.list.chroot nonfree.list.binary
	echo "deb $(proxy_addr)archive.ubuntu.com/ubuntu/ artful-updates restricted universe multiverse partner" | tee config/archives/nonfree-updates.list.chroot
	cd config/archives/ \
		&& ln -sf nonfree.list.chroot nonfree.list.binary

playdeb-repo:
	echo "deb $(proxy_addr)archive.getdeb.net/ubuntu xenial-getdeb games" | tee config/archives/playdeb.list.chroot
	echo "deb-src http://archive.getdeb.net/ubuntu xenial-getdeb games" | tee -a config/archives/playdeb.list.chroot
	curl -s http://archive.getdeb.net/getdeb-archive.key > config/archives/playdeb.list.key.chroot
	cd config/archives/ \
		&& ln -sf playdeb.list.chroot playdeb.list.binary \
		&& ln -sf playdeb.list.key.chroot playdeb.list.key.binary

plex-repo:
	echo "deb $(proxy_addr)downloads.plex.tv/repo/deb/ public main" | tee config/archives/plex.list.chroot
	curl https://downloads.plex.tv/plex-keys/PlexSign.key > config/archives/plex.list.key.chroot
	cd config/archives/ \
		&& ln -sf plex.list.chroot plex.list.binary \
		&& ln -sf plex.list.key.chroot plex.list.key.binary

get-keys:
	gpg --keyserver $(keyserver) --no-default-keyring --keyring repokeys.gpg --recv-keys 94532124541922FB
	yes | gpg --keyserver $(keyserver) --no-default-keyring --keyring repokeys.gpg  --armor --export 94532124541922FB > keyrings/devuan.asc
	yes | gpg --keyserver $(keyserver) --no-default-keyring --keyring repokeys.gpg  --export 94532124541922FB > keyrings/devuan.gpg
	gpg --keyserver $(keyserver) --no-default-keyring --keyring repokeys.gpg --recv-keys 7638D0442B90D010
	yes | gpg --keyserver $(keyserver) --no-default-keyring --keyring repokeys.gpg --armor --export 7638D0442B90D010 > keyrings/debian.asc
	yes | gpg --keyserver $(keyserver) --no-default-keyring --keyring repokeys.gpg  --export 7638D0442B90D010 > keyrings/debian.gpg
	apt-key exportall | tee keyrings/local.asc; \
	cp /usr/share/keyrings/*-archive-keyring.gpg keyrings

import-keys:
	gpg --keyserver $(keyserver) --no-default-keyring --keyring repokeys.gpg --import keyrings/*.gpg
	gpg --keyserver $(keyserver) --no-default-keyring --keyring repokeys.gpg --import keyrings/*.asc
	gpg --keyserver $(keyserver) --no-default-keyring --keyring repokeys.gpg --import /usr/share/keyrings/*-archive-keyring.gpg
	true

export-keys:
	gpg --export --no-default-keyring --keyring repokeys.gpg > keyrings/repokeys.gpg
