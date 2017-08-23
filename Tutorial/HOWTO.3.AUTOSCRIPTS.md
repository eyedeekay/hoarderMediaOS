Step One: Auto Scripts
======================

[Standalone Chapter](https://github.com/cmotc/hoarderMediaOS/blob/master/Tutorial/HOWTO.2.AUTOSCRIPTS.md)

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
