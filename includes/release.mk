sum:
	sha256sum tv-amd64.hybrid.iso > \
		tv-amd64.hybrid.iso.sha256sum || \
		rm tv-amd64.hybrid.iso.sha256sum; \
	sha256sum tv-custom-amd64.hybrid.iso > \
		tv-custom-amd64.hybrid.iso.sha256sum || \
		rm tv-custom-amd64.hybrid.iso.sha256sum; \
	sha256sum tv-hardened-amd64.hybrid.iso > \
		tv-hardened-amd64.hybrid.iso.sha256sum || \
		rm tv-hardened-amd64.hybrid.iso.sha256sum; \
	sha256sum tv-hardened-custom-amd64.hybrid.iso > \
		tv-hardened-custom-amd64.hybrid.iso.sha256sum || \
		rm tv-hardened-custom-amd64.hybrid.iso.sha256sum; \
	sha256sum tv-nonfree-amd64.hybrid.iso > \
		tv-nonfree-amd64.hybrid.iso.sha256sum || \
		rm tv-nonfree-amd64.hybrid.iso.sha256sum; \
	sha256sum tv-nonfree-custom-amd64.hybrid.iso > \
		tv-nonfree-custom-amd64.hybrid.iso.sha256sum || \
		rm tv-nonfree-custom-amd64.hybrid.iso.sha256sum; \
	sha256sum tv-nonfree-hardened-amd64.hybrid.iso > \
		tv-nonfree-hardened-amd64.hybrid.iso.sha256sum || \
		rm tv-nonfree-hardened-amd64.hybrid.iso.sha256sum; \
	sha256sum tv-nonfree-hardened-custom-amd64.hybrid.iso > \
		tv-nonfree-hardened-custom-amd64.hybrid.iso.sha256sum || \
		rm tv-nonfree-hardened-custom-amd64.hybrid.iso.sha256sum; \
	echo sums computed

sig:
	gpg --batch --yes --clear-sign -u "$(SIGNING_KEY)" \
		tv-amd64.hybrid.iso.sha256sum ; \
	gpg --batch --yes --clear-sign -u "$(SIGNING_KEY)" \
		tv-custom-amd64.hybrid.iso.sha256sum ; \
	gpg --batch --yes --clear-sign -u "$(SIGNING_KEY)" \
		tv-hardened-amd64.hybrid.iso.sha256sum ; \
	gpg --batch --yes --clear-sign -u "$(SIGNING_KEY)" \
		tv-hardened-custom-amd64.hybrid.iso.sha256sum ; \
	gpg --batch --yes --clear-sign -u "$(SIGNING_KEY)" \
		tv-nonfree-amd64.hybrid.iso.sha256sum ; \
	gpg --batch --yes --clear-sign -u "$(SIGNING_KEY)" \
		tv-nonfree-custom-amd64.hybrid.iso.sha256sum ; \
	gpg --batch --yes --clear-sign -u "$(SIGNING_KEY)" \
		tv-nonfree-hardened-amd64.hybrid.iso.sha256sum ; \
	gpg --batch --yes --clear-sign -u "$(SIGNING_KEY)" \
		tv-nonfree-hardened-custom-amd64.hybrid.iso.sha256sum ; \
	echo images signed

sigsum:
	make sum
	make sig

torrent:
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
		-w https://github.com/cmotc/hoarderMediaOS/releases/download/$(shell date +'%y.%m.%d')/tv.iso \
		tv-amd64.hybrid.iso; \
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
		-a "http://bttrack.9you.com/announce" \
		-w https://github.com/cmotc/hoarderMediaOS/releases/download/$(shell date +'%y.%m.%d')/tv-custom.iso \
		tv-custom-amd64.hybrid.iso; \
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
		-a "http://bttrack.9you.com/announce" \
		-w https://github.com/cmotc/hoarderMediaOS/releases/download/$(shell date +'%y.%m.%d')/tv-hardened.iso \
		tv-hardened-amd64.hybrid.iso; \
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
		-a "http://bttrack.9you.com/announce" \
		-w https://github.com/cmotc/hoarderMediaOS/releases/download/$(shell date +'%y.%m.%d')/tv-hardened-custom.iso \
		tv-hardened-custom-amd64.hybrid.iso; \
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
		-a "http://bttrack.9you.com/announce" \
		-w https://github.com/cmotc/hoarderMediaOS/releases/download/$(shell date +'%y.%m.%d')/tv-nonfree.iso \
		tv-nonfree-amd64.hybrid.iso; \
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
		-a "http://bttrack.9you.com/announce" \
		-w https://github.com/cmotc/hoarderMediaOS/releases/download/$(shell date +'%y.%m.%d')/tv-nonfree-custom.iso \
		tv-nonfree-custom-amd64.hybrid.iso; \
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
		-w https://github.com/cmotc/hoarderMediaOS/releases/download/$(shell date +'%y.%m.%d')/tv-nonfree-hardened.iso \
		tv-nonfree-hardened-amd64.hybrid.iso; \
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
		-a "http://bttrack.9you.com/announce" \
		-w https://github.com/cmotc/hoarderMediaOS/releases/download/$(shell date +'%y.%m.%d')/tv-nonfree-hardened-custom.iso \
		tv-nonfree-hardened-custom-amd64.hybrid.iso ; \
	@echo torrents created

release:
	make sigsum
	make torrent
	git tag $(shell date +'%y.%m.%d'); git push --tags github
	github-release release \
		--user cmotc \
		--repo hoarderMediaOS \
		--tag $(shell date +'%y.%m.%d') \
		--name "hoarderMediaOS" \
		--description "A re-buildable OS for self-hosting. Please use the torrent if possible" \
		--pre-release ; \
	make upload

upload:
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-amd64.hybrid.iso.sha256sum" \
		--file tv-amd64.hybrid.iso.sha256sum; \
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-amd64.hybrid.iso.sha256sum.asc" \
		--file tv-amd64.hybrid.iso.sha256sum.asc;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-amd64.hybrid.iso.torrent" \
		--file tv-amd64.hybrid.iso.torrent;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-amd64.hybrid.iso" \
		--file tv-amd64.hybrid.iso;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-hardened-amd64.hybrid.iso.sha256sum" \
		--file tv-hardened-amd64.hybrid.iso.sha256sum; \
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-hardened-amd64.hybrid.iso.sha256sum.asc" \
		--file tv-hardened-amd64.hybrid.iso.sha256sum.asc;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-hardened-amd64.hybrid.iso.torrent" \
		--file tv-hardened-amd64.hybrid.iso.torrent;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-hardened-amd64.hybrid.iso" \
		--file tv-hardened-amd64.hybrid.iso;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-custom-amd64.hybrid.iso.sha256sum" \
		--file tv-custom-amd64.hybrid.iso.sha256sum; \
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-custom-amd64.hybrid.iso.sha256sum.asc" \
		--file tv-custom-amd64.hybrid.iso.sha256sum.asc;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-custom-amd64.hybrid.iso.torrent" \
		--file tv-custom-amd64.hybrid.iso.torrent;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-custom-amd64.hybrid.iso" \
		--file tv-custom-amd64.hybrid.iso;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-hardened-custom-amd64.hybrid.iso.sha256sum" \
		--file tv-hardened-custom-amd64.hybrid.iso.sha256sum; \
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-hardened-custom-amd64.hybrid.iso.sha256sum.asc" \
		--file tv-hardened-custom-amd64.hybrid.iso.sha256sum.asc;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-hardened-custom-amd64.hybrid.iso.torrent" \
		--file tv-hardened-custom-amd64.hybrid.iso.torrent;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-hardened-custom-amd64.hybrid.iso" \
		--file tv-hardened-custom-amd64.hybrid.iso;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-nonfree-amd64.hybrid.iso.sha256sum" \
		--file tv-nonfree-amd64.hybrid.iso.sha256sum; \
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-nonfree-amd64.hybrid.iso.asc" \
		--file tv-nonfree-amd64.hybrid.iso.sha256sum.asc;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-nonfree-amd64.hybrid.iso.torrent" \
		--file tv-nonfree-amd64.hybrid.iso.torrent;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-nonfree-amd64.hybrid.iso" \
		--file tv-nonfree-amd64.hybrid.iso;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-nonfree-hardened-amd64.hybrid.iso.sha256sum" \
		--file tv-nonfree-hardened-amd64.hybrid.iso.sha256sum; \
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-nonfree-hardened-amd64.hybrid.iso.sha256sum.asc" \
		--file tv-nonfree-hardened-amd64.hybrid.iso.sha256sum.asc;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-nonfree-hardened-amd64.hybrid.iso.torrent" \
		--file tv-nonfree-hardened-amd64.hybrid.iso.torrent;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-nonfree-hardened-amd64.hybrid.iso" \
		--file tv-nonfree-hardened-amd64.hybrid.iso;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-nonfree-custom-amd64.hybrid.iso.sha256sum" \
		--file tv-nonfree-custom-amd64.hybrid.iso.sha256sum; \
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-nonfree-custom-amd64.hybrid.iso.sha256sum.asc" \
		--file tv-nonfree-custom-amd64.hybrid.iso.sha256sum.asc;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-nonfree-custom-amd64.hybrid.iso.torrent" \
		--file tv-nonfree-custom-amd64.hybrid.iso.torrent;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-nonfree-custom-amd64.hybrid.iso" \
		--file tv-nonfree-custom-amd64.hybrid.iso;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-nonfree-hardened-custom-amd64.hybrid.iso.sha256sum" \
		--file tv-nonfree-hardened-custom-amd64.hybrid.iso.sha256sum; \
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-nonfree-hardened-custom-amd64.hybrid.iso.sha256sum.asc" \
		--file tv-nonfree-hardened-custom-amd64.hybrid.iso.sha256sum.asc;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-nonfree-hardened-custom-amd64.hybrid.iso.torrent" \
		--file tv-nonfree-hardened-custom-amd64.hybrid.iso.torrent;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "tv-nonfree-hardened-custom-amd64.hybrid.iso" \
		--file tv-nonfree-hardened-custom-amd64.hybrid.iso;\
