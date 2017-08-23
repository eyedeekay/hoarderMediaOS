Step 5: Create torrents and Release
===================================

[Standalone Chapter](https://github.com/cmotc/hoarderMediaOS/blob/master/Tutorial/HOWTO.6.RELEASE.md)

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
