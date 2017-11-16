hoarderMediaOS
==============

This readme previously contained a tutorial. It is now found
[at TUTORIAL.md](https://github.com/cmotc/hoarderMediaOS/blob/master/TUTORIAL.md)
While it's content is largely still relevant, the version of this project it
refers to has now changed. Look into the includes/*.mk files for more examples.

This wholly unnecessary and abusive concoction of Docker containers, Makefiles,
and so-called "auto" scripts is the latest and most successful of my attempts to
create my own custom Debian-based Live Media. At this point I basically have to
acknowledge, it's been pretty much entirely for the hell of it. But it's been
educational too. I suppose that was a little by accident, thus the tone of the
tutorial linked above.

So, basically what I did was treated make like a control panel, in order to bend
docker to do my bidding, which happened to be running the priveleged operation
of building an iso with Debian's live-build inside of a container. The overall
rationale for this choice is mostly covered in the tutorial. There has, however
emerged some errata as this configuration has come to do more things.

There is a couple of configuration files you need to pay attention to.
----------------------------------------------------------------------

The first of which is paths.sh. This is just a place to store information that
helps retrieve copies of the built iso from a remote build server.

In this repository, auto/ doesn't just house auto scripts anymore.
------------------------------------------------------------------

In addition to the actual auto scripts, several new scripts have been added.
They are only related insofar as the exist to bridge gaps between the Docker
parts of the build and the machine hosting it, and to automate retrieval from
the remote build server.

Part of this is about getting computers on and off my network to communicate efficiently.
-----------------------------------------------------------------------------------------

Continuing in the spirit of "Anyone can do it, if they want to," my laptop is
not new or fast. It's actually pretty old and slow.
