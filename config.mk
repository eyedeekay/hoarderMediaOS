export image_prename ?= tv
export KEY ?= "70D2060738BEF80523ACAFF7D75C03B39B5E14E1"

export proxy_host ?= 192.168.1.98
export proxy_port ?= 3142

export proxy_addr ?= http://$(proxy_host):$(proxy_port)"/"

#export distro ?= debian
# Only Ever
#export distro ?= ubuntu
# export one
export distro ?= devuan
# of these.

#These must equal "yes" all lower case to be selected
#export hardened ?= yes
export custom ?= yes
#export nonfree ?= yes
#export server ?= yes
export mirror_debian ?= http://$(proxy_host):$(proxy_port)ftp.us.debian.org/debian
export mirror_devuan ?= http://$(proxy_host):$(proxy_port)us.mirror.devuan.org/merged
export mirror_ubuntu ?= http://$(proxy_host):$(proxy_port)archive.ubuntu.com/ubuntu

getname:
	@echo "$(image_prename)-$(distro)"

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

