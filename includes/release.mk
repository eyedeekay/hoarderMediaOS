
export GITHUB_RELEASE_PATH = "$(HOME)/.go/bin/github-release"

release:
	./auto/release

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
