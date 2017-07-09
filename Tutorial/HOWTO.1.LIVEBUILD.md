Step Zero: A crash course in live-build
=======================================

[Standalone Chapter](https://github.com/cmotc/hoarderMediaOS/blob/master/Tutorial/HOWTO.1.LIVEBUILD.md)

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
