Step Three: Dockerfile
======================

[Standalone Chapter](https://github.com/cmotc/hoarderMediaOS/blob/master/Tutorial/HOWTO.4.DOCKERFILE.md)

Now let's make it even easier, and, as a bonus, make our install media easy to
bootstrap from any distribution where Docker can readily be installed. Docker is
a container engine and it's just a hair shy of perfect for generating and
re-generating LiveCD's. Unfortunately, it's not possible to do the very last
step with a simple "docker build" so instead we'll do everything up to that
point. Also, live-build create a number of large build artifacts, that you
probably don't want to accidentally commit and then have the hassle of cleaning
out of your git history. Docker will build all this in a container leaving your
configuration directory neat and clean. Docker is also really easy to learn to
use for simple things, at least so let's look at it in chunks.

Install Dependencies:
---------------------

Docker containers are a kind of virtual machine-ish thing, which is awesome
because we can pare it down to pretty much exactly the stuff we need to build
the liveCD on a highly consistent environment. Docker's got a pretty simple sort
of language to it's Dockerfiles, you inherit from an existing container with
FROM, you run commands in the container with RUN. So to create a Debian Sid
container and install live-build and our supplemental software in it, start your
Dockerfile like this:

**Example Dockerfile: install dependencies**

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
                curl
        RUN apt-get dist-upgrade -yq #I like to do this just to be sure. BTW, this is a comment in a Dockerfile

Recreate Users and Working Directory
------------------------------------

Next, since live-build requires us to run commands as both a user and the root,
we need create a user to run commans as, a home directory, and a working
directory for our configuration. To create a user with an empty home directory
and a default bash shell, add the following line to the Dockerfile.

        RUN useradd -ms /bin/bash livebuilder

Now, use the ADD Dockerfile command to create the working directory you will use
to create the iso.

        ADD . /home/livebuilder/tv-live

Transfer ownership of the directory to the new user before doing anything else

        RUN chown -R livebuilder:livebuilder /home/livebuilder/tv-live

Become the new user

        USER livebuilder

And establish the working directory.

        WORKDIR /home/livebuilder/tv-live

Now, all commands will be run as the user livebuilder in the directory
/home/livebuilder/tv-live

**Example Dockerfile: set up work area**

        RUN useradd -ms /bin/bash livebuilder
        ADD . /home/livebuilder/tv-live
        RUN chown -R livebuilder:livebuilder /home/livebuilder/tv-live
        USER livebuilder
        WORKDIR /home/livebuilder/tv-live

Copy the Configuration Files
----------------------------

Now that our working area is ready, we need to copy our configuration files into
the new working directory. In dockerese, copying a folder and a file works the
same way. You just use the COPY command and specify what you wish to copy. So
to copy our auto folder in it's entirity, just do:

        COPY auto /home/livebuilder/tv-live/auto

Now, for some reason I'm not entirely sure of, lb init doesn't work in the
Docker container. But it seems like all lb init does, at least the way I've been
using it, is create a folder called '.build' owned by root. So instead, I just
add another little helper to the Makefile to do just that at build time.

**Example Makefile Fragment: make docker-init**

        docker-init:
                mkdir -p .build

and to copy the Makefile, just do:

        COPY Makefile /home/livebuilder/tv-live/Makefile

and add the new init helper as root and switch back to the livebuilder user.

        USER root
        RUN make docker-init
        USER livebuilder

**Example Dockerfile: copy build files**

        COPY Makefile /home/livebuilder/tv-live/Makefile
        USER root
        RUN make docker-init
        USER livebuilder

Run the Pre-Build Configuration
-------------------------------

Now, run your custom make commands to prepare the configuration folder and build
directory.

**Example Dockerfile: fine-tune configuration**

        RUN make config-hardened
        RUN make syncthing-repo
        RUN make i2pd-repo
        RUN make skel
        RUN make packages

and you're almost done!

Build the Container
-------------------

Now you run the commands in your Dockerfile by running docker build in the
current directory

        docker build -t tv-build .

Just because I can, I keep this in the Makefile under 'make docker'

Run the Priveleged Part of the Build and Extract the Artifacts
--------------------------------------------------------------

Finally, in order to mount /proc in our container, we must run a command as a
priveleged user in the container. That command is lb build:

        docker run -i --name "tv-build" --privileged -t tv-build lb build

Specifying the --name of the container you want to run the command in will keep
you from losing track of the build artifacts when you copy them to the host
machine later.

**Example auto/build Figure 2:**

        #! /usr/bin/env bash
        lb build noauto \
            "$@"
        bash

From the prompt, you can inspect the results of the build, and extract the build
artifacts using docker cp:

        docker cp tv-build:/home/livebuilder/tv-live/tv-* .

and you now have, what I think, is a pretty great way to remaster your own live
install media.

Unfortunately, because this depends on using chroots as they function in a
regular GNU/Linux distributio, this means that we won't be able to run our
build in Docker on our hardened-kernel system. We can work around this, however
imperfectly, by allowing mounts in chroots

        sudo sysctl -w kernel.grsecurity.chroot_caps=0
        sudo sysctl -w kernel.grsecurity.chroot_deny_chmod=0
        sudo sysctl -w kernel.grsecurity.chroot_deny_mknod=0
        sudo sysctl -w kernel.grsecurity.chroot_deny_mount=0
        sudo sysctl -p
        docker run -i --privileged -t hoarder-build make build
        sudo sysctl -w kernel.grsecurity.chroot_caps=0
        sudo sysctl -w kernel.grsecurity.chroot_deny_chmod=1
        sudo sysctl -w kernel.grsecurity.chroot_deny_mknod=1
        sudo sysctl -w kernel.grsecurity.chroot_deny_mount=1
        sudo sysctl -p
