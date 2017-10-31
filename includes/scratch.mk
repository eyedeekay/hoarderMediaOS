
docker-base-debian:
	docker build --force-rm --build-arg "CACHING_PROXY=$(proxy_addr)" -t $(image_prename)-build-debian -f Dockerfiles/Dockerfile.live-build.debian .

docker-base-ubuntu:
	docker build --force-rm --build-arg "CACHING_PROXY=$(proxy_addr)" -t $(image_prename)-build-ubuntu -f Dockerfiles/Dockerfile.live-build.ubuntu .

docker-base-devuan:
	docker build --force-rm --build-arg "CACHING_PROXY=$(proxy_addr)" -t $(image_prename)-build-devuan -f Dockerfiles/Dockerfile.live-build.devuan .

docker-debian:
	docker build --force-rm -t $(image_prename)-debian \
		--build-arg "nonfree=$(nonfree)" \
		--build-arg "customize=$(custom)" \
		--build-arg "hardened=$(hardened)" \
		-f Dockerfiles/Dockerfile.debian .

docker-ubuntu:
	docker build --force-rm -t $(image_prename)-ubuntu \
		--build-arg "nonfree=$(nonfree)" \
		--build-arg "customize=$(custom)" \
		--build-arg "hardened=$(hardened)" \
		-f Dockerfiles/Dockerfile.ubuntu .

docker-devuan:
	docker build --force-rm -t $(image_prename)-devuan \
		--build-arg "nonfree=$(nonfree)" \
		--build-arg "customize=$(custom)" \
		--build-arg "hardened=$(hardened)" \
		-f Dockerfiles/Dockerfile.devuan .

docker-base-all:
	make docker-base-debian
	make docker-base-ubuntu
	make docker-base-devuan

docker-all:
	make docker-debian
	make docker-ubuntu
	make docker-devuan
