
define EARLY_DOCKER_HOOKS
	wget -O /usr/local/bin/dind "https://raw.githubusercontent.com/docker/docker/master/hack/dind"
	chmod +x /usr/local/bin/dind
	wget -O /usr/local/bin/dockerd-entrypoint "https://github.com/docker-library/docker/raw/master/18.01/docker-entrypoint.sh"
	chmod +x /usr/local/bin/docker-entrypoint.sh
	wget -O /usr/local/bin/dockerd-entrypoint "https://github.com/docker-library/docker/raw/master/18.01/dind/dockerd-entrypoint.sh"
	chmod +x /usr/local/bin/dockerd-entrypoint
	wget -O /usr/local/bin/modprobe.sh "https://github.com/docker-library/docker/raw/master/18.01/dind/modprobe.sh"
	chmod +x /usr/local/bin/modprobe.sh
	wget -O /usr/local/bin/cgroupfs-mount https://github.com/tianon/cgroupfs-mount/raw/master/cgroupfs-mount
	chmod +x /usr/local/bin/cgroupfs-mount
	cgroupfs-mount
endef

export EARLY_DOCKER_HOOKS

define DOCKER_HOOKS
	dockerd-entrypoint &
	sleep 20
	docker pull debian:sid
	docker pull debitux/devuan:unstable
	docker pull alpine:3.6
	killall dockerd-entrypoint
endef

export DOCKER_HOOKS

define OSINT_HOOKS
	dockerd-entrypoint &
	sleep 20
	docker pull eyedeekay/osint_complex:nmap-vulners
	docker pull eyedeekay/osint_complex:OSRFramework
	docker pull eyedeekay/osint_complex:theHarvester
	killall dockerd-entrypoint
endef

export OSINT_HOOKS

define TOR_HOOKS
	dockerd-entrypoint &
	sleep 20
	#docker pull nagev/tor
	killall dockerd-entrypoint
endef

export TOR_HOOKS

define I2PD_HOOKS
	dockerd-entrypoint &
	sleep 20
	#docker pull purplei2p/i2pd
	killall dockerd-entrypoint
endef

export I2PD_HOOKS

define PLAYDEB_HOOKS
	dockerd-entrypoint &
	sleep 20
	git clone https://github.com/eyedeekay/playdeb.git
	cd playdeb; make install
	rm -rf playdeb
	killall dockerd-entrypoint
endef

export PLAYDEB_HOOKS

early-docker-hooks:
	echo "$$EARLY_DOCKER_HOOKS" | tee config/hooks/00adocker.hook.binary
	echo "$$EARLY_DOCKER_HOOKS" | tee config/hooks/00adocker.hook.chroot

docker-hooks:
	echo "$$DOCKER_HOOKS" | tee config/hooks/docker.hook.binary
	echo "$$DOCKER_HOOKS" | tee config/hooks/docker.hook.chroot

playdeb-hooks:
	echo "$$PLAYDEB_HOOKS" | tee config/hooks/playdeb.hook.binary
	echo "$$PLAYDEB_HOOKS" | tee config/hooks/playdeb.hook.chroot

osint-hooks:
	echo "$$OSINT_HOOKS" | tee config/hooks/osint.hook.binary
	echo "$$OSINT_HOOKS" | tee config/hooks/osint.hook.chroot

tor-hooks:
	echo "$$TOR_HOOKS" | tee config/hooks/tor.hook.binary
	echo "$$TOR_HOOKS" | tee config/hooks/tor.hook.chroot

i2ps-hooks:
	echo "$$I2PD_HOOKS" | tee config/hooks/i2pd.hook.binary
	echo "$$I2PD_HOOKS" | tee config/hooks/i2pd.hook.chroot

free-hooks: early-docker-hooks docker-hooks playdeb-hooks tor-hooks i2p-hooks osint-hooks

all-hooks: docker-hooks playdeb-hooks


docker-commands:
	echo 'docker run -d --name tor_instance -p 127.0.1.1:9150:9150 nagev/tor'
