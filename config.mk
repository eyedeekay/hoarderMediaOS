export image_prename ?= tv
export KEY ?= "70D2060738BEF80523ACAFF7D75C03B39B5E14E1"

export proxy_host ?= 192.168.1.98
export proxy_port ?= 3142

export proxy_addr ?= http://$(proxy_host):$(proxy_port)

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
export mirror_debian ?= http://$(proxy_host):$(proxy_port)/ftp.us.debian.org/debian
export mirror_devuan ?= http://$(proxy_host):$(proxy_port)/us.mirror.devuan.org/merged
export mirror_ubuntu ?= http://$(proxy_host):$(proxy_port)/archive.ubuntu.com/ubuntu

getname:
	@echo "$(image_prename)-$(distro)"

