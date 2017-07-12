export image_prename = tv
export KEY = "70D2060738BEF80523ACAFF7D75C03B39B5E14E1"
export proxy_addr = 'http://192.168.2.204:3142'
export distro = debian

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
	scp $(image_prename)-*amd64.hybrid.iso media@192.168.2.206:os_backups/ ; \
	scp $(image_prename)-*amd64.hybrid.iso.sha256sum media@192.168.2.206:os_backups/ ; \
	scp $(image_prename)-*amd64.hybrid.iso.sha256sum.asc media@192.168.2.206:os_backups/ ; \
	scp $(image_prename)-*amd64.files media@192.168.2.206:os_backups/ ; \
	scp $(image_prename)-*amd64.contents media@192.168.2.206:os_backups/ ; \
	scp $(image_prename)-*amd64.hybrid.iso.zsync media@192.168.2.206:os_backups/ ; \
	scp $(image_prename)-*amd64.packages media@192.168.2.206:os_backups/ ;

get-backup:
	scp media@192.168.2.206:os_backups/$(image_prename)-*amd64.hybrid.iso . ; \
	make get-infos

get-infos:
	scp media@192.168.2.206:os_backups/$(image_prename)-*amd64.hybrid.iso.sha256sum . ; \
	scp media@192.168.2.206:os_backups/$(image_prename)-*amd64.hybrid.iso.sha256sum.asc . ; \
	scp media@192.168.2.206:os_backups/$(image_prename)-*amd64.files . ; \
	scp media@192.168.2.206:os_backups/$(image_prename)-*amd64.contents . ; \
	scp media@192.168.2.206:os_backups/$(image_prename)-*amd64.hybrid.iso.zsync . ; \
	scp media@192.168.2.206:os_backups/$(image_prename)-*amd64.packages . ;

tutorial:
	rm -f TUTORIAL.md
	cat "Tutorial/HOWTO.0.INTRODUCTION.md" | tee -a TUTORIAL.md
	echo "" | tee -a TUTORIAL.md
	cat "Tutorial/HOWTO.1.LIVEBUILD.md" | tee -a TUTORIAL.md
	echo "" | tee -a TUTORIAL.md
	cat "Tutorial/HOWTO.2.AUTOSCRIPTS.md" | tee -a TUTORIAL.md
	echo "" | tee -a TUTORIAL.md
	cat "Tutorial/HOWTO.3.MAKEFILE.md" | tee -a TUTORIAL.md
	echo "" | tee -a TUTORIAL.md
	cat "Tutorial/HOWTO.4.DOCKERFILE.md" | tee -a TUTORIAL.md
	echo "" | tee -a TUTORIAL.md
	cat "Tutorial/HOWTO.5.AUTHENTICATE.md" | tee -a TUTORIAL.md
	echo "" | tee -a TUTORIAL.md
	cat "Tutorial/HOWTO.6.RELEASE.md" | tee -a TUTORIAL.md
	echo "" | tee -a TUTORIAL.md

get-keys:
	gpg --recv-keys 94532124541922FB; \
	gpg --armor --export 94532124541922FB --output keyrings/devuan.gpg; \
	gpg --recv-keys 7638D0442B90D010 ; \
	gpg --armor --export 7638D0442B90D010 --output keyrings/debian.gpg; \
	#gpg --recv-keys EDA0D2388AE22BA9
	#gpg --armor --export EDA0D2388AE22BA9 --output keyrings/debian.gpg
