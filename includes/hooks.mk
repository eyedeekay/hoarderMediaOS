define DOCKER_HOOKS
	docker pull debian:sid
	docker pull debitux/devuan:unstable
	docker pull alpine:3.6
	#docker pull eyedeekay/osint_complex:nmap
	#docker pull eyedeekay/osint_complex:OSRFramework
	#docker pull eyedeekay/osint_complex:theHarvester
	#docker pull hoardermediaos/lb-build-$(distro)
	#docker pull nagev/tor
endef

export DOCKER_HOOKS

docker-hooks:
	echo "$$DOCKER_HOOKS" config/hooks/docker.hook.binary

docker-commands:
	echo 'docker run -d --name tor_instance -p 127.0.1.1:9150:9150 nagev/tor'
