hoarderMediaOS
==============

or...

How I decided to continuously remaster my own Debian Variant without, like, totally meaning to.
===============================================================================================

OK, this thing is a work in progress, so bear with me while I do it, but here's
what I'm attempting. I have spent alot of time refining my home PC's
configuration based on defaults in the Debian installer, and the packages
themselves, and I've been pretty successful at it. But it's an ongoing process,
and sometimes, you bork something and you've got to reinstall. Which means that
you've got to reproduce all that configuration and start over, which kind of
sucks. There are many ways to approach this, and what this readme is going to
amount to is simply an example of but one way of doing things(With some
variations, because some of the things that Docker can allow you to do are
awesome). I wanted a lightweight media-center OS for retro gaming that could
double as a Media Server, I totally uncreatively called it hoarderMediaOS, and
now it's a reasonably easy to reproduce procedure and I hope it's helpful. It's
based on Unstable, though, so it's might become outdated at any moment. I'm
going to keep doing it though, so I'll probably notice if it stops working.

Who this tutorial is targeted at
--------------------------------

Enthusiastic Amateurs! People who like Debian/Ubuntu based distributions for
their excellent stability and diligent community, but who don't necessarily
want to use one of the regular desktop environments in the default
configuration. Ricers, datahoarders, and hobbyists who would rather use Debian
than Arch or Gentoo. Anyone who uses their home computer for experimentation.
The point of this tutorial is that **anyone** can learn to continuously
customize their Linux configuration if they wish to, **anyone**, even a solitary
hobbyist with no significant organizational resources.

**Is it a distro?**

**God I hope not.** I'm not a person who really likes to deal in opinion. I
deleted my whole blog because I felt obligated to be personal. Unfortunately,
I have an opinion. I'm opinionated. And it's my opinion that it's too easy for
people to consider any installable media that gets redistributed equal to a
recognizable distro. It's just not. Tiny distros can be **amazing**, I loved
CrunchBang and felt genuine sadness when corenominal gave it up, and genuine
excitement for BunsenLabs and Crunchbang++. I love Linux Mint and think
Cinnamon will ease many people's Dad's transition into using GNU/Linux from
Windows when they start to get pissed off about Windows 10 serving them ads
all the damn time. But there are caveats to using these tiny niche distros. You
have to take matters into your own hands at times, even things that are second
nature to you or me, might not be obvious to a first-time Mint user, even things
as simple as being able to use AskUbuntu to get help.

Depending on their complexity, they may also configure 3rd-party repositorys.
**Please consider that in the most serious of terms**. If they configured a
third-party repository, they have probably used it to install something. That
application was installed from that third-party repository because it's probably
experimental and **not ready to be held to the standards of an official Debian**
**package**. That doesn't mean it's bad. Lots of software from third-party
repositories is **awesome** but using third party software is kind of a big
decision.

It is my opinion that there ought to be a clearer way to consider these two
types of distros specifically. Maybe something like "Upstream Distro" and
"Enthusiast Distro" as a place to instigate a lexical split, and make clear the
advantages, disadvantages, and implications of each. Using an "Enthusiast
Distro" is fun, and creating one is fun. Sharing them ought to be fun, too.
I would be more comfortable sharing my own "Enthusiast Distro" if I were sure
people understood, I'm just one guy, depending on the work of thousands, I think
building riced install media is fun, and that's **it**.

What am I actually going to talk about?
---------------------------------------

live-build, docker, sid, make. Specifically, I'm going to teach you how to use
these tools to continuously package your own personal configuration of Debian
as an iso that can be used to create install media, just like the regular Debian
LiveCD's.

What are you going to need?
---------------------------

Either Debian unstable(sid), Devuan unstable(ceres) or any distribution
supporting Docker and coming configured with the Docker Hub.

**On that note, Dependencies**

        Debian Sid/Devuan Ceres
        =======================
        sudo apt-get install live-build debootstrap make
        optionally,
        sudo apt-get install git docker.io

or install docker per your distribution's instructions or from source. Docker
will use the debian:sid container as a base. A git repository or a git hosting
service will also be helpful if you want to backup and share your configuration.

Step Zero: A crash course in live-build
=======================================

See also:
---------

  * [Debian live systems manual, First Steps](https://debian-live.alioth.debian.org/live-manual/stable/manual/html/live-manual.en.html#178)

All in all, live-build is a pretty simple, straightforward, regular tool to use.
For most purposes, it will come down to the use of three commands. These
commands are:

  1. lb config
  2. lb build
  3. lb clean

If you wanted to create the absolute bare-minimum default liveCD that live-build
will generate, you could simply run

        lb config && sudo lb build

in an empty directory and in a few minutes, you'd have a basic liveCD. However,
it wouldn't be very useful. This CD won't have an X server, or many of the
applications desktop Linux users may have come to take for granted. Fortunately,
it's pretty easy to turn this into a base system. Just add a desktop metapackage
to the configuration, in between the two commands.

        lb config
        echo 'budgie-desktop' >> config/packages/live.list.chroot
        sudo lb build

This will get you a live system with the excellent budgie desktop. In doing so,
it will many packages on the liveCD that budgie-desktop depends on.

Step One: Auto Scripts
======================

See also:
---------

  * [Debian live systems manual, Dealing with Configuration Changes](https://debian-live.alioth.debian.org/live-manual/stable/manual/html/live-manual.en.html#334)

Directory Configuration
-----------------------

First, you'll need to create a new directory for your configuration and change
into it.

        mkdir -p hoarder-live && cd hoarder-live

Auto Scripts
------------

The live-build uses a set of configuration files called "auto scripts" which are
held under a a directory called "auto" in the configuration directory. Create
this directory as well, and the following files within, clean, config, and
build.

        mkdir -p auto && cd auto
        touch clean config build

The clean, config, and build files are in-and-of-themselves just shell scripts,
which are called by the lb script when you invoke the relevant command. So
'lb config' runs the configuration file auto/config, lb build does auto/build,
lb clean does auto/clean.

The noauto Option
-----------------

When you create an auto script, it runs the commands in the script *instead* of
the command. That means, in order to actually run the command with the auto
script, you have to run the command *in* the auto script, and if you run the
command in the auto script, it can't look for for the auto script again. So when
you write an auto script, you need to include the noauto option to make sure the
auto script works.

**Example auto/clean Figure 1:**

        #! /usr/bin/env bash
        lb clean noauto \
            "$@"

**Example auto/config Figure 1:**

        #! /usr/bin/env bash
        lb config noauto \
            "$@"

**Example auto/build Figure 1:**

        #! /usr/bin/env bash
        lb build noauto \
            "$@"

Simple as that!. And now we're ready to start doing more interesting stuff.

Setting Defaults
----------------

The basic purpose of using an auto script is to set arguments which will be
passed to the lb command. Now if, for example, you wanted to make sure that lb
never keeps a cache of the files it downloads, you could add --purge to the
auto/clean script, like so:

**Example auto/clean Figure 2:**

        #! /usr/bin/env bash
        lb clean noauto --purge

Most of the stuff auto scripts do, though, happens during the lb config command.
This command takes most of the options and sets up the configuration tree, so
it is the most detailed command. For example, to enable a live system and
installation from a live system, you should enable the options '-b iso-hybrid'
'--debian-installer live' and '--system live', or if you want to set the init
system you should use the '--initsystem' option. You can also set the options
of the programs that it live-build runs, like debootstrap, using
'--deboostrap-options'. For a complete list of options, you should see
'man lb_config'. An example of an auto script with alternate defaults to enable
installation from live media, sysv-based init, and a merged /usr/ would be:

**Example auto/config Figure 2:**

        #! /usr/bin/env bash
        lb config noauto \
            -b iso-hybrid \
            --debian-installer live \
            --system live \
            --debootstrap-options "--merged-usr --variant=minbase --include=busybox-syslogd,gnupg2,gpgv-static,gnutls-bin" \
            --initsystem sysvinit \
            "$@"

setting additional options for lb build in auto/build isn't necessary.

Pre-Process Scripting
---------------------

Besides setting options, since auto scripts are just shell scripts they can be
used to set things up in advance of the live-build steps. For example, the sid
version of live-build requires you to run 'sudo lb init $options' which will
create a directory called '.build'. In order to run this automatically, you
could add it to an auto script. Since it only needs to be run if it's artifacts
do not exist, I prefer to add it to the auto/clean script.

**Example auto/clean Figure 2:**

        #! /usr/bin/env bash
        #If .build doesn't exist        #create it
        [ ! -d .build ] &&              sudo lb init -t 3 4
        lb clean noauto --purge

Setting Options Conditionally
-----------------------------

Another thing you might be interested in doing, for example if you want to build
both a Free and Non-Free version of your iso, or both an Ubuntu and Debian based
version, or both only use a caching proxy when told to, you can set options in
auto scripts conditionally by representing them in environment variables. This
new example auto script conditionally applies settings that use contrib and
non-free, and conditionally sets a caching proxy by determining if a variable
in the outside environment has been set. For example, if $nonfree includes
anything, it will be adjudged "true" and $components will be set to contain the
value '--components=\"main,contrib,non-free\"'.


**Broken-down one-liner, pseudo-ternary if-else conditional:**

        set components to
        components=     evaluate this command
                        $(      if $nonfree is set  then
                                [ ! -z "$nonfree" ] &&
                                        echo to stdout(set variable content)          else
                                        echo "--components=\"main,contrib,non-free\"" ||
                                                set content to blank
                                                echo "" )

So in our new auto/config command, we conditionally set options according to
the environment like this:

**Example auto/config Figure 2:**

        #! /usr/bin/env bash
        components=$( [ ! -z "$nonfree" ] && echo "--components=\"main,contrib,non-free\"" || echo "" )
        use_proxy=$( [ ! -z "$proxy" ] && echo "--apt-http-proxy \"http://192.168.2.203\"" || echo "" )
        lb config noauto \
            "$use_proxy" \
            -b iso-hybrid \
            --debian-installer live \
            --system live \
            --debootstrap-options "--merged-usr --variant=minbase --include=busybox-syslogd,gnupg2,gpgv-static,gnutls-bin $components" \
            --initsystem sysvinit \
            "$@"

Step Two: Makefile
==================

Since the auto scripts are just shell scripts, it is absolutely possible to set
everything up within them and them alone. However, I think it's useful to add
a second layer of automation here, one that you can script in a little bit
different way, in order to help you automate the building of specific variants
of your liveCD. For example, I build a version of my liveCD which includes
non-free components for computers that need them, but only free components for
computers that don't. The non-free version installs a handful of additional
packages, and it would be a little bit more complicated to conditionally add
those packages in an auto script. Also, the use of a Makefile allows you to
create more generic auto scripts which can be used as the basis for a wider
variety of install media. Hopefully, this approach doesn't cause controversy.
After all, even though it's not strictly necessary with auto scripts, this is
pretty much the type of task that make is designed to automate.

Supplementing your auto scripts with Make
-----------------------------------------

See Also: [man lb_config](http://manpages.ubuntu.com/manpages/trusty/man1/lb_config.1.html)

So you've got your auto/config script which provides the defaults for lb config.
But now, you're building variations on the theme and you want to give each
variation it's own tame without setting it in the auto script or having to type
it out every single time. Let's do this by supplementing our auto/config script
with part of our Makefile:

**Example Makefile Fragment: make config**

        config:
                lb config --image-name tv

By following this example, we can automate the creation of more-or-less complex
variations of the lb config output. For example, to enable non-free packages,
set the '--archive-areas' option to '"main contrib nonfree"'.

        config-nonfree:
                lb config --image-name tv-nonfree \
                        --archive-areas "main contrib nonfree"


or, to use a hardened kernel, set the '-k' option to the desired flavor,
'grsec-amd64'.

        config-hardened:
                lb config --image-name tv-hardened \
                        -k grsec-amd64


Well that's considerable amount of typing saved, all told. And it's arguably a
bit easier to incorporate into something automatic. So let's keep this modular
automation via Make going and think of something else to automate.

Installing Packages
-------------------

See Also: [Customizing Package Installation](https://debian-live.alioth.debian.org/live-manual/stable/manual/html/live-manual.en.html#396)

Telling the live-build system which packages is also just a matter of creating
a text file, in config/packages/*.list.{chroot, binary}. Just add packages per
their name in the repository, one line at a time. So to add the Awesome Window
Manager, the Uzbl web browser, the Surfraw terminal web helper, and youtube-dl,

**Example Makefile Fragment: make packages**

        cd config/package-lists/ && \
        echo "awesome" >> build.list.chroot && \
        echo "awesome-extra" >> build.list.chroot && \
        echo "surfraw" >> build.list.chroot && \
        echo "surfraw-extra" >> build.list.chroot && \
        echo "uzbl" >> build.list.chroot && \
        echo "youtube-dl" >> build.list.chroot

After you've create build.list.chroot, link it to build.list.binary to make the
packages on the installed system as well as the live system.

        ln -sf build.list.chroot build.list.binary

All together, 'make packages' should look a little like this:

        packages:
                cd config/package-lists/ && \
                        echo "awesome" >> build.list.chroot && \
                        echo "awesome-extra" >> build.list.chroot && \
                        echo "surfraw" >> build.list.chroot && \
                        echo "surfraw-extra" >> build.list.chroot && \
                        echo "uzbl" >> build.list.chroot && \
                        echo "youtube-dl" >> build.list.chroot
                        ln -sf build.list.chroot build.list.binary

Adding Third-Party Repositories to your system
----------------------------------------------

See Also: [Package Sources](https://debian-live.alioth.debian.org/live-manual/stable/manual/html/live-manual.en.html#371)

One of the most common tasks with live-build is adding a third-party repository
from which to retrieve software that isn't ready to be a part of Debian for one
reason or another. For example, the i2p networking protocol and it's c++ client,
i2pd which are available from [i2pd.website](https://i2pd.website). In order to
add a repository, you need to add it's sources.list entry and public key to the
config/archives/ directory.

So, the i2pd repository is at [http://repo.lngserv.ru/debian](http://repo.lngserv.ru/debian)
and it distributes packages under the codename Jessie, corresponding to Debian
Jessie and distributing only main(free) packages. Let's use echo and tee to put
the i2pd.list.chroot file into place:

**Example Makefile Fragment: make i2pd-repo**

        echo "deb http://repo.lngserv.ru/debian jessie main" | tee config/archives/i2pd.list.chroot
        echo "deb-src http://repo.lngserv.ru/debian jessie main" | tee -a config/archives/i2pd.list.chroot

I like to do it this way because it also puts the output on stdout, so I can
capture it if I have a problem. Next, we need to add the GPG key for i2pd. i2pd
has a GPG key fingerprint corresponding to 98EBCFE2, which we will retrieve
using GPG.

        gpg --keyserver keys.gnupg.net --recv-keys 98EBCFE2

will put the key onto our keyring, but it's not in the live-build tree yet. To
do that, do

        gpg -a --export 98EBCFE2 | tee config/archives/i2pd.list.key.chroot

This will ensure that i2pd's repository is present in the liveCD, but not the
installed system. To put it in both, create a symlink *.list.binary and
*.list.key.binary

        cd config/archives/ \
                && ln -sf i2pd.list.chroot i2pd.list.binary \
                && ln -sf i2pd.list.key.chroot i2pd.list.key.binary

so, all together it looks like this:

        i2pd-repo:
                echo "deb http://repo.lngserv.ru/debian jessie main" | tee config/archives/i2pd.list.chroot
                echo "deb-src http://repo.lngserv.ru/debian jessie main" | tee -a config/archives/i2pd.list.chroot
                gpg --keyserver keys.gnupg.net --recv-keys 98EBCFE2; \
                gpg -a --export 98EBCFE2 | tee config/archives/i2pd.list.key.chroot
                cd config/archives/ \
                        && ln -sf i2pd.list.chroot i2pd.list.binary \
                        && ln -sf i2pd.list.key.chroot i2pd.list.key.binary

On occasion, you might need to get a GPG key in some way other than via a GPG
keyserver. If it's over HTTPS, for instance, you can use 'curl -s' to the same
effect. For example, to include SyncThing's repository, create the sources.list
entry:

**Example Makefile Fragment: make syncthing-repo**

        echo "deb http://apt.syncthing.net/ syncthing release" | tee config/archives/syncthing.list.chroot

and this time, replace 'gpg -a export $key' with 'curl -s $url'

        curl -s https://syncthing.net/release-key.txt | tee config/archives/syncthing.list.key.chroot

and make your symlinks. All together, it should look like this:

        syncthing-repo:
        echo "deb http://apt.syncthing.net/ syncthing release" | tee config/archives/syncthing.list.chroot
        curl -s https://syncthing.net/release-key.txt | tee config/archives/syncthing.list.key.chroot
        cd config/archives/ \
                && ln -sf syncthing.list.chroot syncthing.list.binary \
                && ln -sf syncthing.list.key.chroot syncthing.list.key.binary

Now, why do it this way? Well for one thing, that's pretty concise, but it's
also pretty obvious what it's doing. I think that's a pretty good idea. For
another thing, I might want to group these repositories categorially. Say I have
repositories for i2pd, tor, tox, PaleMoon, Plex, and Skype. Instead of typing
each out individually, I might put the first 4 in to "make libre" like so:

        libre:
                make i2pd-repo; \
                make tor-repo; \
                make palemoon-repo; \
                make tox-repo; \

and the last two in to "make unfree" like so:

        unfree:
                make playdeb-repo; \
                make plex-repo; \

Editing the Default Home Directory Template
-------------------------------------------

See Also: [Includes](https://debian-live.alioth.debian.org/live-manual/stable/manual/html/live-manual.en.html#500)

Another basic customization that you may want to do is to alter the default home
directory template, a.k.a. etc/skel. Adding files and folders to etc/skel is
easy, you just add them in 'config/includes.chroot/etc/skel/' and
'config/includes.binary/etc/skel/'. Since you're basically going to be adding
files and folders to this folder, everything is literally exactly the same as
using the terminal to manage files and folders in any other context.

To create a folder, something like:

        mkdir -p config/includes.chroot/etc/skel/Documents/Slideshows/

will do just fine.

Need to create a text file? How about a baseline .bash_aliases?

        echo "#/usr/bin/env bash" | tee config/includes.binary/etc/skel/.bash_aliases
        echo "echo hello, $(whoami)" | tee config/includes.binary/etc/skel/.bash_aliases

Want to create a shell script and set it's permissions?

        echo "#/usr/bin/env bash" | tee config/includes.binary/etc/skel/conky.sh; \
        echo "nohup bash -c 'sleep 2 && conky 2>1 /dev/null &'" | tee config/includes.binary/etc/skel/conky.sh
        chmod +x config/includes.binary/etc/skel/conky.sh

I mean, even being that explicit is drawing it out. It's just that easy. So, all
together it should look like:

**Example Makefile Fragment: make skel**

        skel:
                mkdir -p config/includes.chroot/etc/skel/Documents/Slideshows/
                echo "#/usr/bin/env bash" | tee config/includes.binary/etc/skel/.bash_aliases
                echo "echo hello, $(whoami)" | tee config/includes.binary/etc/skel/.bash_aliases
                echo "#/usr/bin/env bash" | tee config/includes.binary/etc/skel/conky.sh; \
                echo "nohup bash -c 'sleep 2 && conky 2>1 /dev/null &'" | tee config/includes.binary/etc/skel/conky.sh
                chmod +x config/includes.binary/etc/skel/conky.sh

Step Three: Dockerfile
======================

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

For some reason, when I run this command in a container, the files are built,
and then lost. To work around this difficulty, I modify the auto/build script
to launch directly into bash after completing the build process.

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
        sudo sysctl -w kernel.grsecurity.chroot_deny_chmod=0
        sudo sysctl -w kernel.grsecurity.chroot_deny_mknod=0
        sudo sysctl -w kernel.grsecurity.chroot_deny_mount=0
        sudo sysctl -p

Step 4: Provide a path to verify Authentic copies
=================================================

Like I said, we should all be careful about who we trust to assemble all our
software. Likewise, when you distribute it in binary form, it probably makes
sense to provide many ways to verify that the recipient of that copy has
obtained it authentically. To do this, you have many options, and you should
choose to use them all if possible.

Compute Hashes
--------------

The first step to helping your fellow enthusiast to verify the authenticity of
an image, you need to compute hashes of those images. A *hash function* takes
an arbitrary piece of data, any data will do, and creates a string of a fixed
size which is totally unique to the piece of data that was *hashed*. So when we
sha256sum our iso file, we will get a string that is unique to our iso file and
cannot be reproduced, without an exact copy of the original iso file. The tool
we should use for this is sha256sum, which computes hashes based on the Secure
Hashing Algorithm, the 256 bit version, which is used by many GNU/Linux
distributions to verify the authenticity of their distributed iso files.

In order to produce the sha256sum of the iso file, run the following command. It
make take a moment, especially if the file is large in size.

        sha256sum tv-amd64.hybrid.iso

Once the hash is computed, it will be emitted to stdout in the form

        86b70a74e30eec40bf129c44a8dd823c1320200825bc4222556ce1241d4863dd  tv-amd64.hybrid.iso

This can now be used to ensure that the file corresponds to the hash, which is
one half ot the authenticity puzzle. If you want to compute the hashes in your
Makefile, you could use something like the following snippet.

        **Example Makefile Fragment: hash, delete empty on failure**
        hash:
                sha256sum tv-amd64.hybrid.iso > \
                        tv-amd64.hybrid.iso.sha256sum || \
                        rm tv-amd64.hybrid.iso.sha256sum; \

Because piping the output of sha256sum will always produce a file, but if the
file to be hashed doesn't exist, the created file will be empty, we make sure
that sha256sum signals that it has completed *successfully* and if it fails, we
delete the created file.

Sign Hashes
-----------

Now we've got hashes to verify the iso's correspond to the hashes, but now we
need a way for the user to verify the provenance of the hashes themselves. In
order to do this, we need to sign them with a key that corresponds to some real
set of contact information. Traditionally, this has been an e-mail but maybe
something out there is better for you.

To get started, we need to generate a signing key. If you already have a signing
key you want to use, then you can skip this step.

[See Also: Key Generation/Distribution](https://wiki.debian.org/Keysigning#Step_1:_Create_a_RSA_keypair)

[Also See Also: Key Generation](https://keyring.debian.org/creating-key.html)

Before you do anything else, you should edit your $HOME/.gnupg/gpg.conf to not
use SHA1 as it's hashing algorithm.

        personal-digest-preferences SHA256
        cert-digest-algo SHA256
        default-preference-list SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 ZLIB BZIP2 ZIP Uncompressed

Now, you'll need to start the gpg key generation procedure:

        gpg --gen-key

You'll be prompted for whick key type you want to generate. RSA and RSA, the
default key type, is the one that we want. On the next prompt, you'll be
prompted to select a key size, and you should select 4096 for your signing key.
Then select a time frame for the key to be valid. For the sake of brevity, I
direct you to the second
[link at the top of this section](https://keyring.debian.org/creating-key.html).

Now that you're done with that, you've just got to get ready to share your key.
First, generate a key revocation certificate. Back it up someplace safe. You
will use it in case your private key is ever compromised to inform people that
they must disregard the compromised key and update to an uncompromised key.

        gpg --gen-revoke ${KEY_ID} > ~/.gnupg/revocation-${KEY_ID}.crt

Finally, share the **public** key with the world.

        gpg --send-key ${KEY_ID}

Now that we've got our signing key, let's use it to sign the files:

        gpg --batch --yes --clear-sign -u "$(SIGNING_KEY)" tv-amd64.hybrid.iso.sha256sum

After you're done, you'll have a signed copy of the hash file that looks like
this:

        -----BEGIN PGP SIGNED MESSAGE-----
        Hash: SHA256

        86b70a74e30eec40bf129c44a8dd823c1320200825bc4222556ce1241d4863dd  tv-amd64.hybrid.iso
        -----BEGIN PGP SIGNATURE-----

        iQEzBAEBCAAdFiEEwM7uKXtf5F/2EKrG8F+F+kRsBCsFAllIqBoACgkQ8F+F+kRs
        BCubMwgAuf81nTIcmM8COY7T7RGp51ApiAMETU1tuHQbOKBKDRemgml2UZ0DNVLZ
        wCtnfErsQD8getUSpqSk07e448sCbEUYeifH8xS/6uC3JbCkITt4bDl6UdU2BXm0
        I9IkweK3d0hp5TIjs4m9fA3qVTto1v9EaUxQhREB3/do2FhqP+60ehqR3dgqLzOr
        5ueXxXCeFAHJhyvQk0EvKwvWciabqj8gY2ra5aEXE+kAJWz8mrLyK/4Q0IBwXMYm
        xPiXNctlaldqDCjsF42ronHQlHK7pg0l58Pht/kSh8ERKPyhtLGeOOrNyjcbg8/t
        HE65ErJ7ArZZJQ7KBdxFr8lzkrPsEg==
        =PrNx
        -----END PGP SIGNATURE-----

and can be used by anyone with your public key to assure that the hash they
are using, and thus the iso it corresponds to, came from the owner of the
corresponding private key and them alone. In order to make the signatures with
the Makefile, a fragment like the following will work. Note that we don't have
to delete failed signatures, a nonexistent file will just not produce a
signature.

        **Example Makefile Fragment: sign the hash**
        sign:
                gpg --batch --yes --clear-sign -u "$(SIGNING_KEY)" \
                        tv-amd64.hybrid.iso.sha256sum ; \

Step 5: Create torrents and Release
===================================

Now we've got everything we need to responsibly share our configuration except
a means of sharing it. Fortunately, with a little trickery you can actually
reliably bootstrap some really good ways of distributing your iso file. I like
a combination of Github Releases and a cool feature of the Bittorrent protocol
known as "Web Seeds" that allow you to supplement a Peer-to-Peer swarm with an
HTTP or HTTPS source. Unfortunately, in order to make this automatic we have to
install an additional couple of dependencies. Fortunately for us, one of those
dependencies is in Go! Go is an awesome language that anyone can use.
Unfortunately for us, it's because the excellent Go software involved here isn't
quite available in Debian just yet.

Install Extra Dependencies
--------------------------

OK so first, we need to install the extra dependencies here. We'll be using the
terminal tool "mktorrent" to generate our torrent files, and we'll be using
golang to get the github-release package.

        sudo apt-get install mktorrent golang

Now, set the GOPATH and run 'go get' to retrieve the package

        export GOPATH="$HOME/.go"
        mkdir -p "$GOPATH"
        go get github.com/aktau/github-release

And include the GOPATH in your PATH

        export PATH="$GOPATH:$PATH"

Now, generate a torrent from the file. I just added a bunch of public annouce
URLS to it, these are open trackers anyone can use. Note that we also use a
Web Seed to supplement our torrent. This is very, very important, it'll provide
a consistent source for downloads until a large enough swarm exists that it is
no longer neccessary.

        mktorrent -a "udp://tracker.openbittorrent.com:80" \
		-a "udp://tracker.publicbt.com:80" \
		-a "udp://tracker.istole.it:80" \
		-a "udp://tracker.btzoo.eu:80/announce" \
		-a "http://opensharing.org:2710/announce" \
		-a "udp://open.demonii.com:1337/announce" \
		-a "http://announce.torrentsmd.com:8080/announce.php" \
		-a "http://announce.torrentsmd.com:6969/announce" \
		-a "http://bt.careland.com.cn:6969/announce" \
		-a "http://i.bandito.org/announce" \
		-a "http://bttrack.9you.com/announce" \
		-w https://github.com/"$(MY_ACCOUNT)"/"$(MY_ISO)"/releases/download/$(shell date +'%y.%m.%d')/tv.iso \
		tv-amd64.hybrid.iso; \

Awesome, now that the torrent is generated, generate a tag for the release on
github. I just use the date to tag the releases, as the point of this procedure
is to run builds frequently.

        git tag $(date +'%y.%m.%d'); git push --tags github

in a Makefile, the same command will need to look like this:

        git tag $(shell date +'%y.%m.%d'); git push --tags github

In order to create a Github release for that tag, you'll need to use the
program we downloaded with go get, github-release:

        github-release release \
		--user "$(MY_ACCOUNT)" \
		--repo "$(MY_ISO)" \
		--tag $(shell date +'%y.%m.%d') \
		--name "$(MY_ISO)" \
		--description "A re-buildable OS for self-hosting. Please use the torrent if possible" \
		--pre-release ; \

Now we're ready to upload our built images and verification materials to the
release page. I generally upload them from smallest to largest files so to
upload the sha256 hash:

        github-release upload --user "$(MY_ACCOUNT)" --repo "$(MY_ISO)" --tag $(shell date +'%y.%m.%d') \
                --name "$(MY_ISO)" \
                --file tv-amd64.hybrid.iso.sha256sum; \

And the signed sha256 hash:

        github-release upload --user "$(MY_ACCOUNT)" --repo "$(MY_ISO)" --tag $(shell date +'%y.%m.%d') \
                --name "$(MY_ISO)" \
                --file tv-amd64.hybrid.iso.sha256sum.asc;\

And the torrent file:

        github-release upload --user "$(MY_ACCOUNT)" --repo "$(MY_ISO)" --tag $(shell date +'%y.%m.%d') \
                --name "$(MY_ISO)" \
                --file tv-amd64.hybrid.iso.torrent;\

and finally, the bootable, Live ISO image.

        github-release upload --user "$(MY_ACCOUNT)" --repo "$(MY_ISO)" --tag $(shell date +'%y.%m.%d') \
                --name "$(MY_ISO)" \
                --file tv-amd64.hybrid.iso;\
