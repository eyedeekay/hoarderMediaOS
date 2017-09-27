hoarderMediaOS
==============

This readme previously contained a tutorial. It is now found
[at TUTORIAL.md](https://github.com/cmotc/hoarderMediaOS/blob/master/TUTORIAL.md)
While it's content is largely still relevant, the version of this project it
refers to has now changed. Look into the includes/*.mk files for more examples.

Usage: There's a config.mk file in the folder. You can edit it to build
different variants. Right now debian and devuan based distros can be built.
Ubuntu based variants will be buildable soon. You can edit the
includes/packages.mk to change the default installed packages. It fully
regenerates the config directory every time you build.

