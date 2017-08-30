export image_prename = tv
export KEY = "70D2060738BEF80523ACAFF7D75C03B39B5E14E1"

#export proxy_addr = 'http://127.0.0.1:3142'
export proxy_addr = http://172.17.0.2:3142
#export proxy_addr = 'http://apthoarder:3142/'
#export distro = debian
export distro = ubuntu
#export distro = devuan
#export hardened = yes

soften-container:
	sudo sysctl -w kernel.grsecurity.chroot_caps=0
	sudo sysctl -w kernel.grsecurity.chroot_deny_chmod=0
	sudo sysctl -w kernel.grsecurity.chroot_deny_mknod=0
	sudo sysctl -w kernel.grsecurity.chroot_deny_mount=0
	sudo sysctl -p
	sudo sysctl kernel.grsecurity.chroot_caps
	sudo sysctl kernel.grsecurity.chroot_deny_chmod
	sudo sysctl kernel.grsecurity.chroot_deny_mknod
	sudo sysctl kernel.grsecurity.chroot_deny_mount

harden-container:
	sudo sysctl -w kernel.grsecurity.chroot_caps=1
	sudo sysctl -w kernel.grsecurity.chroot_deny_chmod=1
	sudo sysctl -w kernel.grsecurity.chroot_deny_mknod=1
	sudo sysctl -w kernel.grsecurity.chroot_deny_mount=1
	sudo sysctl -p
	sudo sysctl kernel.grsecurity.chroot_caps
	sudo sysctl kernel.grsecurity.chroot_deny_chmod
	sudo sysctl kernel.grsecurity.chroot_deny_mknod
	sudo sysctl kernel.grsecurity.chroot_deny_mount

backup:
	scp $(image_prename)-*amd64.hybrid.iso media@media:os_backups/ ; \
	scp $(image_prename)-*amd64.hybrid.iso.sha256sum media@media:os_backups/ ; \
	scp $(image_prename)-*amd64.hybrid.iso.sha256sum.asc media@media:os_backups/ ; \
	scp $(image_prename)-*amd64.files media@media:os_backups/ ; \
	scp $(image_prename)-*amd64.contents media@media:os_backups/ ; \
	scp $(image_prename)-*amd64.hybrid.iso.zsync media@media:os_backups/ ; \
	scp $(image_prename)-*amd64.packages media@media:os_backups/ ;

get-backup:
	scp media@media:os_backups/$(image_prename)-*amd64.hybrid.iso . ; \
	make get-infos

get-infos:
	scp media@media:os_backups/$(image_prename)-*amd64.hybrid.iso.sha256sum . ; \
	scp media@media:os_backups/$(image_prename)-*amd64.hybrid.iso.sha256sum.asc . ; \
	scp media@media:os_backups/$(image_prename)-*amd64.files . ; \
	scp media@media:os_backups/$(image_prename)-*amd64.contents . ; \
	scp media@media:os_backups/$(image_prename)-*amd64.hybrid.iso.zsync . ; \
	scp media@media:os_backups/$(image_prename)-*amd64.packages . ;

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

