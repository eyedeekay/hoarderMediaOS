Appendix One: Create torrents and Release
=====================================

[Standalone Chapter](https://github.com/cmotc/hoarderMediaOS/blob/master/Tutorial/HOWTO.8.HOOKS.md)

So far, we've mostly focused on customizing what repositories are available and
what packages are installed by default. With the exception of customizing
/etc/skel, none of the customizations have been more granular than the package
manager defaults. That's great, but sometimes it's still not enough. Sometimes
you want to do something very specific, in a specific order, which may not be
accomodated by the package manager. "Hooks," which are really just scripts, are
a convenient way to gain this type of granularity during various phases of the
build process.

