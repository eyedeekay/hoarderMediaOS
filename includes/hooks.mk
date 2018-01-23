define DOCKER_HOOKS
	service docker start
	docker pull debian:sid
	docker pull debitux/devuan:unstable
	docker pull alpine:3.6
	#docker pull hoardermediaos/lb-build-$(distro)
	service docker stop
endef

export DOCKER_HOOKS

define OSINT_HOOKS
	service docker start
	docker pull eyedeekay/osint_complex:nmap-vulners
	docker pull eyedeekay/osint_complex:OSRFramework
	docker pull eyedeekay/osint_complex:theHarvester
	service docker stop
endef

export OSINT_HOOKS

define TOR_HOOKS
	service docker start
	#docker pull nagev/tor
	service docker stop
endef

export TOR_HOOKS

define I2PD_HOOKS
	service docker start
	#docker pull purplei2p/i2pd
	service docker stop
endef

export I2PD_HOOKS

define PLAYDEB_HOOKS
	service docker start
	git clone https://github.com/eyedeekay/playdeb.git
	cd playdeb; make install
	rm -rf playdeb
	service docker stop
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

free-hooks: docker-hooks playdeb-hooks tor-hooks i2p-hooks osint-hooks

all-hooks: docker-hooks playdeb-hooks


docker-commands:
	echo 'docker run -d --name tor_instance -p 127.0.1.1:9150:9150 nagev/tor'
