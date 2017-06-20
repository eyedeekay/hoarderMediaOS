FROM debian:sid
RUN apt-get update
RUN apt-get install -yq \
                apt-transport-https \
                gpgv-static \
                gnupg2 \
                bash \
                apt-utils \
                live-build \
                debootstrap \
                make \
                curl \
                sudo \
                procps
RUN apt-get dist-upgrade -yq
RUN useradd -ms /bin/bash livebuilder && echo "livebuilder:liverbuilder" | chpasswd && adduser livebuilder sudo
ADD . /home/livebuilder/hoarder-live
RUN chown -R livebuilder:livebuilder /home/livebuilder/hoarder-live
USER livebuilder
WORKDIR /home/livebuilder/hoarder-live
COPY auto /home/livebuilder/hoarder-live/auto
COPY Makefile /home/livebuilder/hoarder-live/Makefile
USER root
RUN make docker-init
USER livebuilder
RUN make config-hardened-custom-proxy
RUN make libre
RUN make custom
RUN make skel
RUN make permissive-user
RUN make packages
USER root
