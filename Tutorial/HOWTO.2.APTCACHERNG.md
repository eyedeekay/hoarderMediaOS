Step One: Set up your own caching proxy for apt(You'll be much better off)
==========================================================================

[Standalone Chapter](https://github.com/cmotc/hoarderMediaOS/blob/master/Tutorial/HOWTO.2.APTCACHERNG.md)

See-also:
---------

  * [apt-cacher-ng Homepage and Configuration Instructions](https://www.unix-ag.uni-kl.de/~bloch/acng/)
  * [apt-cacher-ng dockerized](https://docs.docker.com/engine/examples/apt-cacher-ng/)

After running debootstrap fourty or fifty times, you might be thinking "This
wasn't so bad the first time, but this is definitely not an instantaneous thing.
Sure would be nice to mirror these somewhere immediately nearby." And you might
try and search for how to set up a mirror and get discouraged by how large it
is. That's what apt-cacher-ng is for. apt-cacher-ng is a caching proxy that
is used to cache packages downloaded by package managers in your Linux
distributions. It will only cache the packages you request from it, so it's only
as big as it needs to be, and it can be used to bootstrap your live disk and
your installation, which will save you much bandwidth. And it's super easy to
configure, too. If you're using only the main Debian repositories especially,
it should just work, right out of the box, and if all your third-party
repositories are using plain http, they can be used through apt-cacher-ng
transparently, although it will not cache those packages unless it is configured
to. It seems like there are three main situations where you might want to make a
change to how apt-cacher-ng works by default.

###Allow https repositories to CONNECT through apt-cacher-ng

Increasingly, some software sources are making their repositories available only
by way of https. This is probably not like, super necessary, as it will do
little to obscure the nature of the traffic, but I think it's nice in general.
But it presents a problem if you use apt-cacher-ng. It will not connect to https
repositories by default. In order to allow it to, you can simply uncomment this
line:

        # PassThroughPattern: .* # this would allow CONNECT to everything

so it looks like this.

        PassThroughPattern: .* # this would allow CONNECT to everything

and voila! You can now use https repositories through your apt-cacher-ng
instance, however it will not cache those packages yet.

###Third-party Repository using plain http

If you want to cache packages from a thrid-party repository using apt-cacher-ng,
such as the Devuan repository, then you will need to create a backend for that
package and then make apt-cacher-ng aware of that backend. A backend is simply
a file containing the url of the repository you want to use. So to create a
backend for Devuan or any other repository available over plain http, one need
only:

        echo "http://packages.devuan.org/merged" | sudo tee /etc/apt-cacher-ng/backends_devuan

Then, in order to make apt-cacher-ng aware of it's existence, you need to
configure is in /etc/apt-cacher-ng/acng.conf. In this configuration line, you'll
remap the Devuan mirror to a new name and tell it to use the backends_devuan
file.

        Remap-devrep: file:devuan_mirror /merged ; file:backends_devuan # Devuan Archives

Next time you start your apt-cacher-ng instance, it will know to cache Devuan
packages.

###Third-party Repository caching using https

It would also be nice to cache https repositories, and you can do just that with
apt-cacher-ng. It's pretty similar to using it with plain http, a backend is
still just as mu

        echo "https://repo.lngserv.ru/debian" | tee /etc/apt-cacher-ng/backends_i2pd

and make apt-cacher-ng aware of it in /etc/apt-cacher-ng/acng.conf

        Remap-i2pd: http://i2p.repo ; file:backends_i2pd

###Configuring apt to use your caching proxy

Finally, you'll need to make your applications aware of apt-cacher-ng. To make
your host machine's apt aware of your proxy, you need to create a file
in /etc/apt/apt.conf.d/ that tells apt to look for it.

        echo "Acquire::http { Proxy \"http://127.0.0.1:3142\"; };" | tee /etc/apt/apt.conf.d/02proxy

But to make live-build use it, add the proxy's address to your options in your
auto/config file.

        lb config noauto --apt-http-proxy http://127.0.0.1:3142
