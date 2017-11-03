
export GITHUB_RELEASE_PATH = "$(HOME)/.go/bin/github-release"

sum:
	sha256sum "$(image_prename)-$(distro)-amd64.hybrid.iso" > \
		"$(image_prename)-$(distro)-amd64.hybrid.iso.sha256sum" || \
		rm $(image_prename)-$(distro)-amd64.hybrid.iso.sha256sum; \
	echo sums computed

sig:
	gpg --batch --yes --clear-sign -u "$(SIGNING_KEY)" \
		"$(image_prename)-$(distro)-amd64.hybrid.iso.sha256sum" ; \
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
		"$(image_prename)-$(distro)-amd64.hybrid.iso"; \
	@echo torrents created

release:
	make sigsum
	make torrent
	$(GITHUB_RELEASE_PATH) release \
		--user cmotc \
		--repo hoarderMediaOS \
		--tag $(shell date +'%y.%m.%d') \
		--name "hoarderMediaOS" \
		--description "A re-buildable OS for self-hosting. Please use the torrent if possible" \
	make upload

upload:
	$(GITHUB_RELEASE_PATH) upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "$(image_prename)-$(distro)-amd64.hybrid.iso.sha256sum" \
		--file "$(image_prename)-$(distro)-amd64.hybrid.iso.sha256sum"; \
	$(GITHUB_RELEASE_PATH) upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "$(image_prename)-$(distro)-amd64.hybrid.iso.sha256sum.asc" \
		--file "$(image_prename)-$(distro)-amd64.hybrid.iso.sha256sum.asc";\
	$(GITHUB_RELEASE_PATH) upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "$(image_prename)-$(distro)-amd64.hybrid.iso.torrent" \
		--file "$(image_prename)-$(distro)-amd64.hybrid.iso.torrent";\
	$(GITHUB_RELEASE_PATH) upload --user cmotc --repo hoarderMediaOS --tag $(shell date +'%y.%m.%d') \
		--name "$(image_prename)-$(distro)-amd64.hybrid.iso" \
		--file "$(image_prename)-$(distro)-amd64.hybrid.iso";\

soften-container:
	su_wrap sysctl -w kernel.grsecurity.chroot_caps=0
	su_wrap sysctl -w kernel.grsecurity.chroot_deny_chmod=0
	su_wrap sysctl -w kernel.grsecurity.chroot_deny_mknod=0
	su_wrap sysctl -w kernel.grsecurity.chroot_deny_mount=0
	su_wrap sysctl -p
	su_wrap sysctl kernel.grsecurity.chroot_caps
	su_wrap sysctl kernel.grsecurity.chroot_deny_chmod
	su_wrap sysctl kernel.grsecurity.chroot_deny_mknod
	su_wrap sysctl kernel.grsecurity.chroot_deny_mount

harden-container:
	su_wrap sysctl -w kernel.grsecurity.chroot_caps=1
	su_wrap sysctl -w kernel.grsecurity.chroot_deny_chmod=1
	su_wrap sysctl -w kernel.grsecurity.chroot_deny_mknod=1
	su_wrap sysctl -w kernel.grsecurity.chroot_deny_mount=1
	su_wrap sysctl -p
	su_wrap sysctl kernel.grsecurity.chroot_caps
	su_wrap sysctl kernel.grsecurity.chroot_deny_chmod
	su_wrap sysctl kernel.grsecurity.chroot_deny_mknod
	su_wrap sysctl kernel.grsecurity.chroot_deny_mount

backup:
	scp $(image_prename)-$(distro)-*amd64.hybrid.iso media@media:os_backups/ ; \
	scp $(image_prename)-$(distro)-*amd64.hybrid.iso.sha256sum media@media:os_backups/ ; \
	scp $(image_prename)-$(distro)-*amd64.hybrid.iso.sha256sum.asc media@media:os_backups/ ; \
	scp $(image_prename)-$(distro)-*amd64.files media@media:os_backups/ ; \
	scp $(image_prename)-$(distro)-*amd64.contents media@media:os_backups/ ; \
	scp $(image_prename)-$(distro)-*amd64.hybrid.iso.zsync media@media:os_backups/ ; \
	scp $(image_prename)-$(distro)-*amd64.packages media@media:os_backups/ ;

get-backup:
	scp media@media:os_backups/$(image_prename)-$(distro)-*amd64.hybrid.iso . ; \
	make get-infos

get-infos:
	scp media@media:os_backups/$(image_prename)-$(distro)-*amd64.hybrid.iso.sha256sum . ; \
	scp media@media:os_backups/$(image_prename)-$(distro)-*amd64.hybrid.iso.sha256sum.asc . ; \
	scp media@media:os_backups/$(image_prename)-$(distro)-*amd64.files . ; \
	scp media@media:os_backups/$(image_prename)-$(distro)-*amd64.contents . ; \
	scp media@media:os_backups/$(image_prename)-$(distro)-*amd64.hybrid.iso.zsync . ; \
	scp media@media:os_backups/$(image_prename)-$(distro)-*amd64.packages . ;

tutorial:
	rm -f TUTORIAL.md
	cat "Tutorial/HOWTO.0.INTRODUCTION.md" | tee -a TUTORIAL.md
	echo "" | tee -a TUTORIAL.md
	cat "Tutorial/HOWTO.1.LIVEBUILD.md" | tee -a TUTORIAL.md
	echo "" | tee -a TUTORIAL.md
	cat "Tutorial/HOWTO.2.APTCACHERNG.md" | tee -a TUTORIAL.md
	echo "" | tee -a TUTORIAL.md
	cat "Tutorial/HOWTO.3.AUTOSCRIPTS.md" | tee -a TUTORIAL.md
	echo "" | tee -a TUTORIAL.md
	cat "Tutorial/HOWTO.4.MAKEFILE.md" | tee -a TUTORIAL.md
	echo "" | tee -a TUTORIAL.md
	cat "Tutorial/HOWTO.5.DOCKERFILE.md" | tee -a TUTORIAL.md
	echo "" | tee -a TUTORIAL.md
	cat "Tutorial/HOWTO.6.AUTHENTICATE.md" | tee -a TUTORIAL.md
	echo "" | tee -a TUTORIAL.md
	cat "Tutorial/HOWTO.7.RELEASE.md" | tee -a TUTORIAL.md
	echo "" | tee -a TUTORIAL.md

getname:
	@echo "$(image_prename)-$(distro)"
