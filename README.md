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

There are a couple of configuration files you need to pay attention to.
-----------------------------------------------------------------------

The first of which is paths.sh. This is just a place to store information that
helps retrieve copies of the built iso from a remote build server, specifically
the ssh username/hostname to use, and the folder from which to retrieve the
completed images. An example paths.sh might be

        export user_name="dev"
        export host_name="dev"
        export dev_path="/home/$user_name/Projects/hoardermediaos"

The next new configuration file is auto/common. As it's name suggests, it's a
set of global variables used by the other scripts in auto/. It is generated
inside the container, so changing it outside the container will have no effect,
instead it exists to ensure that some static settings generated inside the
container can be used by the parts that happen outside the container,
specifically auto/copy, auto/pull, and auto/release. Speaking of which...

In this repository, auto/ doesn't just house auto scripts anymore.
------------------------------------------------------------------

In addition to the actual auto scripts, several new scripts have been added.
They are only related insofar as the exist to bridge gaps between the Docker
parts of the build and the machine hosting it, and to automate retrieval from
the remote build server. I guess I'm also planning on one that may be used to
set up an encrypted persistence volume as well, resulting in a LiveUSB-only
edition which would be pretty cool too. But focusing on the ones that exist so
far:

  * auto/copy: triggered by running make docker-copy. This is used to copy the
   finished images and accompanying metadata from the build container to the
   host machine for further processing. It copies the newly-generated
   auto/common file, from the build container reads in it's contents, and copies
   the images.
  * auto/pull: triggered by running make pull. allows you to pre-configure the
   system to retrieve build artifacts from a build server located elsewhere.
   If you're building locally, you will not need this. It's configured using a
   paths.sh file in the project folder's root, which it loads before anything
   else. Then it loads auto/common by retrieving it from the build server,
   overriding local defaults, and finally copies the build artifacts.
  * auto/release: triggered by running make release. generates the necessary
   files to make a release of the images available for download via github
   releases. In order to feel less like a jerk about uploading a bunch of 1.3gb
   images to a website I use for free, it also generates a torrent file.
   **USE THE TORRENT TO DOWNLOAD THE IMAGE**. It is a web-seeded torrent, if no
    torrent peers are available it will be able to use the web source to
    download instead.

Planned:

  * auto/persistence: triggered by running make persistence. This will configure
   a persistence partition on your LiveUSB with appropriate encryption.
  * auto/download: triggered by running make download. This will start a torrent
   client to download the image in the background, wait for the image to be
   downloaded, verify it's signature and sum, and display readable results.

Part of this is about getting computers on and off my network to communicate efficiently.
-----------------------------------------------------------------------------------------

Continuing in the spirit of "Anyone can do it, if they want to," my laptop is
not new or fast. It's actually pretty old and slow, hence the wierd mix of
software I prefer. But my desktop can build this LiveCD in about 35 minutes.
So when I push something from my laptop, the desktop picks up the change and
builds it, I retrieve it, and sign it on my laptop. This process still has room
for improvement but it's getting to the point where it's downright sensible.
Eventually, I shall start tying together all the little, apparently disparate
hobby projects I've been working on, when enough of them are in the CI to make
the point. Anybody can start customizing their OS install media with a little
effort.

To help paint a picture, here are the most significant of the repositories
related to my home networking project:

  * Router OS [lede-docker](https://github.com/eyedeekay/lede-docker)
  * Xen Dom0 [kloster](https://github.com/eyedeekay/kloster)
  * Desktop/P2P OS [hoardermediaos](https://github.com/eyedeekay/hoardermediaos)
  * Containerized apt-cacher-ng [hoardercache-docker](https://github.com/eyedeekay/hoardercache-docker)
  * Repository frontend creator for static web hosts [apt-now](https://github.com/eyedeekay/apt-now)
  * Tablet OS image Configuration [imgmaker](https://github.com/eyedeekay/imgmaker)
