Step Two: Makefile
==================

[Standalone Chapter](https://github.com/cmotc/hoarderMediaOS/blob/master/Tutorial/HOWTO.3.MAKEFILE.md)

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
