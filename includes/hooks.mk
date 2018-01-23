define DOCKER_HOOKS
	docker pull debian:sid
	docker pull debitux/devuan:unstable
	docker pull alpine:3.6
	#docker pull hoardermediaos/lb-build-$(distro)
	#docker pull nagev/tor
endef

export DOCKER_HOOKS

define OSINT_HOOKS
	docker pull eyedeekay/osint_complex:nmap-vulners
	docker pull eyedeekay/osint_complex:OSRFramework
	docker pull eyedeekay/osint_complex:theHarvester

endef

export OSINT_HOOKS

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

all-hooks: docker-hooks playdeb-hooks


docker-commands:
	echo 'docker run -d --name tor_instance -p 127.0.1.1:9150:9150 nagev/tor'
