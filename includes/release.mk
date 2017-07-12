sum:
	sha256sum $(image_prename)-amd64.hybrid.iso > \
		$(image_prename)-amd64.hybrid.iso.sha256sum || \
		rm $(image_prename)-amd64.hybrid.iso.sha256sum; \
	sha256sum $(image_prename)-custom-amd64.hybrid.iso > \
		$(image_prename)-custom-amd64.hybrid.iso.sha256sum || \
		rm $(image_prename)-custom-amd64.hybrid.iso.sha256sum; \
	sha256sum $(image_prename)-hardened-amd64.hybrid.iso > \
		$(image_prename)-hardened-amd64.hybrid.iso.sha256sum || \
		rm $(image_prename)-hardened-amd64.hybrid.iso.sha256sum; \
	sha256sum $(image_prename)-hardened-custom-amd64.hybrid.iso > \
		$(image_prename)-hardened-custom-amd64.hybrid.iso.sha256sum || \
		rm $(image_prename)-hardened-custom-amd64.hybrid.iso.sha256sum; \
	sha256sum $(image_prename)-nonfree-amd64.hybrid.iso > \
		$(image_prename)-nonfree-amd64.hybrid.iso.sha256sum || \
		rm $(image_prename)-nonfree-amd64.hybrid.iso.sha256sum; \
	sha256sum $(image_prename)-nonfree-custom-amd64.hybrid.iso > \
		$(image_prename)-nonfree-custom-amd64.hybrid.iso.sha256sum || \
		rm $(image_prename)-nonfree-custom-amd64.hybrid.iso.sha256sum; \
	sha256sum $(image_prename)-nonfree-hardened-amd64.hybrid.iso > \
		$(image_prename)-nonfree-hardened-amd64.hybrid.iso.sha256sum || \
		rm $(image_prename)-nonfree-hardened-amd64.hybrid.iso.sha256sum; \
	sha256sum $(image_prename)-nonfree-hardened-custom-amd64.hybrid.iso > \
		$(image_prename)-nonfree-hardened-custom-amd64.hybrid.iso.sha256sum || \
		rm $(image_prename)-nonfree-hardened-custom-amd64.hybrid.iso.sha256sum; \
	echo sums computed

sig:
	gpg --batch --yes --clear-sign -u "$(SIGNING_KEY)" \
		$(image_prename)-amd64.hybrid.iso.sha256sum ; \
	gpg --batch --yes --clear-sign -u "$(SIGNING_KEY)" \
		$(image_prename)-custom-amd64.hybrid.iso.sha256sum ; \
	gpg --batch --yes --clear-sign -u "$(SIGNING_KEY)" \
		$(image_prename)-hardened-amd64.hybrid.iso.sha256sum ; \
	gpg --batch --yes --clear-sign -u "$(SIGNING_KEY)" \
		$(image_prename)-hardened-custom-amd64.hybrid.iso.sha256sum ; \
	gpg --batch --yes --clear-sign -u "$(SIGNING_KEY)" \
		$(image_prename)-nonfree-amd64.hybrid.iso.sha256sum ; \
	gpg --batch --yes --clear-sign -u "$(SIGNING_KEY)" \
		$(image_prename)-nonfree-custom-amd64.hybrid.iso.sha256sum ; \
	gpg --batch --yes --clear-sign -u "$(SIGNING_KEY)" \
		$(image_prename)-nonfree-hardened-amd64.hybrid.iso.sha256sum ; \
	gpg --batch --yes --clear-sign -u "$(SIGNING_KEY)" \
		$(image_prename)-nonfree-hardened-custom-amd64.hybrid.iso.sha256sum ; \
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
		$(image_prename)-amd64.hybrid.iso; \
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
		-w https://github.com/cmotc/hoarderMediaOS/releases/download/$(shell date +'%y.%m.%d')/$(image_prename)-custom.iso \
		$(image_prename)-custom-amd64.hybrid.iso; \
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
		-w https://github.com/cmotc/hoarderMediaOS/releases/download/$(shell date +'%y.%m.%d')/$(image_prename)-hardened.iso \
		$(image_prename)-hardened-amd64.hybrid.iso; \
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
		-w https://github.com/cmotc/hoarderMediaOS/releases/download/$(shell date +'%y.%m.%d')/$(image_prename)-hardened-custom.iso \
		$(image_prename)-hardened-custom-amd64.hybrid.iso; \
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
		-w https://github.com/cmotc/hoarderMediaOS/releases/download/$(shell date +'%y.%m.%d')/$(image_prename)-nonfree.iso \
		$(image_prename)-nonfree-amd64.hybrid.iso; \
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
		-w https://github.com/cmotc/hoarderMediaOS/releases/download/$(shell date +'%y.%m.%d')/$(image_prename)-nonfree-custom.iso \
		$(image_prename)-nonfree-custom-amd64.hybrid.iso; \
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
		-w https://github.com/cmotc/hoarderMediaOS/releases/download/$(shell date +'%y.%m.%d')/$(image_prename)-nonfree-hardened.iso \
		$(image_prename)-nonfree-hardened-amd64.hybrid.iso; \
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
		-w https://github.com/cmotc/hoarderMediaOS/releases/download/$(shell date +'%y.%m.%d')/$(image_prename)-nonfree-hardened-custom.iso \
		$(image_prename)-nonfree-hardened-custom-amd64.hybrid.iso ; \
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
		--name "$(image_prename)-amd64.hybrid.iso.sha256sum" \
		--file $(image_prename)-amd64.hybrid.iso.sha256sum; \
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "$(image_prename)-amd64.hybrid.iso.sha256sum.asc" \
		--file $(image_prename)-amd64.hybrid.iso.sha256sum.asc;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "$(image_prename)-amd64.hybrid.iso.torrent" \
		--file $(image_prename)-amd64.hybrid.iso.torrent;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "$(image_prename)-amd64.hybrid.iso" \
		--file $(image_prename)-amd64.hybrid.iso;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "$(image_prename)-hardened-amd64.hybrid.iso.sha256sum" \
		--file $(image_prename)-hardened-amd64.hybrid.iso.sha256sum; \
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "$(image_prename)-hardened-amd64.hybrid.iso.sha256sum.asc" \
		--file $(image_prename)-hardened-amd64.hybrid.iso.sha256sum.asc;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "$(image_prename)-hardened-amd64.hybrid.iso.torrent" \
		--file $(image_prename)-hardened-amd64.hybrid.iso.torrent;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "$(image_prename)-hardened-amd64.hybrid.iso" \
		--file $(image_prename)-hardened-amd64.hybrid.iso;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "$(image_prename)-custom-amd64.hybrid.iso.sha256sum" \
		--file $(image_prename)-custom-amd64.hybrid.iso.sha256sum; \
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "$(image_prename)-custom-amd64.hybrid.iso.sha256sum.asc" \
		--file $(image_prename)-custom-amd64.hybrid.iso.sha256sum.asc;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "$(image_prename)-custom-amd64.hybrid.iso.torrent" \
		--file $(image_prename)-custom-amd64.hybrid.iso.torrent;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "$(image_prename)-custom-amd64.hybrid.iso" \
		--file $(image_prename)-custom-amd64.hybrid.iso;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "$(image_prename)-hardened-custom-amd64.hybrid.iso.sha256sum" \
		--file $(image_prename)-hardened-custom-amd64.hybrid.iso.sha256sum; \
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "$(image_prename)-hardened-custom-amd64.hybrid.iso.sha256sum.asc" \
		--file $(image_prename)-hardened-custom-amd64.hybrid.iso.sha256sum.asc;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "$(image_prename)-hardened-custom-amd64.hybrid.iso.torrent" \
		--file $(image_prename)-hardened-custom-amd64.hybrid.iso.torrent;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "$(image_prename)-hardened-custom-amd64.hybrid.iso" \
		--file $(image_prename)-hardened-custom-amd64.hybrid.iso;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "$(image_prename)-nonfree-amd64.hybrid.iso.sha256sum" \
		--file $(image_prename)-nonfree-amd64.hybrid.iso.sha256sum; \
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "$(image_prename)-nonfree-amd64.hybrid.iso.asc" \
		--file $(image_prename)-nonfree-amd64.hybrid.iso.sha256sum.asc;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "$(image_prename)-nonfree-amd64.hybrid.iso.torrent" \
		--file $(image_prename)-nonfree-amd64.hybrid.iso.torrent;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "$(image_prename)-nonfree-amd64.hybrid.iso" \
		--file $(image_prename)-nonfree-amd64.hybrid.iso;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "$(image_prename)-nonfree-hardened-amd64.hybrid.iso.sha256sum" \
		--file $(image_prename)-nonfree-hardened-amd64.hybrid.iso.sha256sum; \
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "$(image_prename)-nonfree-hardened-amd64.hybrid.iso.sha256sum.asc" \
		--file $(image_prename)-nonfree-hardened-amd64.hybrid.iso.sha256sum.asc;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "$(image_prename)-nonfree-hardened-amd64.hybrid.iso.torrent" \
		--file $(image_prename)-nonfree-hardened-amd64.hybrid.iso.torrent;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "$(image_prename)-nonfree-hardened-amd64.hybrid.iso" \
		--file $(image_prename)-nonfree-hardened-amd64.hybrid.iso;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "$(image_prename)-nonfree-custom-amd64.hybrid.iso.sha256sum" \
		--file $(image_prename)-nonfree-custom-amd64.hybrid.iso.sha256sum; \
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "$(image_prename)-nonfree-custom-amd64.hybrid.iso.sha256sum.asc" \
		--file $(image_prename)-nonfree-custom-amd64.hybrid.iso.sha256sum.asc;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "$(image_prename)-nonfree-custom-amd64.hybrid.iso.torrent" \
		--file $(image_prename)-nonfree-custom-amd64.hybrid.iso.torrent;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "$(image_prename)-nonfree-custom-amd64.hybrid.iso" \
		--file $(image_prename)-nonfree-custom-amd64.hybrid.iso;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "$(image_prename)-nonfree-hardened-custom-amd64.hybrid.iso.sha256sum" \
		--file $(image_prename)-nonfree-hardened-custom-amd64.hybrid.iso.sha256sum; \
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "$(image_prename)-nonfree-hardened-custom-amd64.hybrid.iso.sha256sum.asc" \
		--file $(image_prename)-nonfree-hardened-custom-amd64.hybrid.iso.sha256sum.asc;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "$(image_prename)-nonfree-hardened-custom-amd64.hybrid.iso.torrent" \
		--file $(image_prename)-nonfree-hardened-custom-amd64.hybrid.iso.torrent;\
	github-release upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "$(image_prename)-nonfree-hardened-custom-amd64.hybrid.iso" \
		--file $(image_prename)-nonfree-hardened-custom-amd64.hybrid.iso;\
