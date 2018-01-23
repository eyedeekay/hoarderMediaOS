define DOCKER_HOOKS
	docker pull debian:sid
	docker pull debitux/devuan:unstable
	docker pull alpine:3.6
	#docker pull hoardermediaos/lb-build-$(distro)
endef

export DOCKER_HOOKS

define OSINT_HOOKS
	docker pull eyedeekay/osint_complex:nmap-vulners
	docker pull eyedeekay/osint_complex:OSRFramework
	docker pull eyedeekay/osint_complex:theHarvester
endef

export OSINT_HOOKS

define TOR_HOOKS
	#docker pull nagev/tor
endef

export TOR_HOOKS

define I2PD_HOOKS
	#docker pull purplei2p/i2pd
endef

export I2PD_HOOKS

define PLAYDEB_HOOKS
	git clone https://github.com/eyedeekay/playdeb.git
	cd playdeb; make install
	rm -rf playdeb
endef

export PLAYDEB_HOOKS

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

all-hooks: docker-hooks playdeb-hooks


docker-commands:
	echo 'docker run -d --name tor_instance -p 127.0.1.1:9150:9150 nagev/tor'
