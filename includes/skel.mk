define TEA_CONFIG
[General]
additional_hl=0
editor_font_name=Monospace
editor_font_size=8
pos=@Point(0 15)
show_linenums=0
size=@Size(1366 738)
splitterSizes=@ByteArray(\0\0\0\xff\0\0\0\x1\0\0\0\x2\0\0\x1\xf6\0\0\0\xc0\x1\xff\xff\xff\xff\x1\0\0\0\x2\0)
word_wrap=2

endef

export TEA_CONFIG

skel:
	mkdir -p config/includes.chroot/etc/apt/preferences.d/ \
		config/includes.binary/etc/apt/preferences.d/ \
		config/includes.chroot/etc/skel/Documents/Books/ \
		config/includes.chroot/etc/skel/Documents/Slideshows/ \
		config/includes.chroot/etc/skel/Documents/Papers/ \
		config/includes.chroot/etc/skel/Documents/Stories/ \
		config/includes.chroot/etc/skel/Documents/Letters/ \
		config/includes.chroot/etc/skel/Audio/Books/ \
		config/includes.chroot/etc/skel/Audio/Theatre/ \
		config/includes.chroot/etc/skel/Audio/Comedy/ \
		config/includes.chroot/etc/skel/Audio/Music/ \
		config/includes.chroot/etc/skel/Audio/Music/Rock/ \
		config/includes.chroot/etc/skel/Audio/Music/Rap/ \
		config/includes.chroot/etc/skel/Audio/Music/Alternative/ \
		config/includes.chroot/etc/skel/Audio/Music/Classical/ \
		config/includes.chroot/etc/skel/Audio/Music/Jazz/ \
		config/includes.chroot/etc/skel/Audio/Music/Blues/ \
		config/includes.chroot/etc/skel/Video/Movies/ \
		config/includes.chroot/etc/skel/Video/Television/ \
		config/includes.chroot/etc/skel/Video/Presentations/ \
		config/includes.chroot/etc/skel/Video/Classes/ \
		config/includes.chroot/etc/skel/ControlPanel/ \
		config/includes.chroot/etc/skel/Projects/ \
		config/includes.binary/etc/skel/Documents/Books/ \
		config/includes.binary/etc/skel/Documents/Slideshows/ \
		config/includes.binary/etc/skel/Documents/Papers/ \
		config/includes.binary/etc/skel/Documents/Stories/ \
		config/includes.binary/etc/skel/Documents/Letters/ \
		config/includes.binary/etc/skel/Audio/Books/ \
		config/includes.binary/etc/skel/Audio/Theatre/ \
		config/includes.binary/etc/skel/Audio/Comedy/ \
		config/includes.binary/etc/skel/Audio/Music/ \
		config/includes.binary/etc/skel/Audio/Music/Rock/ \
		config/includes.binary/etc/skel/Audio/Music/Rap/ \
		config/includes.binary/etc/skel/Audio/Music/Alternative/ \
		config/includes.binary/etc/skel/Audio/Music/Classical/ \
		config/includes.binary/etc/skel/Audio/Music/Jazz/ \
		config/includes.binary/etc/skel/Audio/Music/Blues/ \
		config/includes.binary/etc/skel/Video/Movies/ \
		config/includes.binary/etc/skel/Video/Television/ \
		config/includes.binary/etc/skel/Video/Presentations/ \
		config/includes.binary/etc/skel/Video/Classes/ \
		config/includes.binary/etc/skel/ControlPanel/ \
		config/includes.binary/etc/skel/Projects/
	@echo "#bash aliases" | tee config/includes.chroot/etc/skel/.bash_aliases
	@echo "#bash aliases" | tee config/includes.binary/etc/skel/.bash_aliases

easy-user:
	mkdir -p config/includes.chroot/etc/apt/preferences.d/ \
		config/includes.binary/etc/apt/preferences.d/
	echo "#!/bin/sh -e" > config/includes.chroot/etc/rc.local
	echo "exit 0" >> config/includes.chroot/etc/rc.local
	echo "#!/bin/sh -e" > config/includes.binary/etc/rc.local
	echo "exit 0" >> config/includes.binary/etc/rc.local
	mkdir -p config/includes.chroot/etc/live/config/
	echo 'LIVE_USER_DEFAULT_GROUPS="audio cdrom dip floppy video plugdev netdev powerdev scanner bluetooth fuse docker"' > config/includes.chroot/etc/live/config/user-setup.conf
	make preseed-install

permissive-user:
	mkdir -p config/includes.chroot/etc/apt/preferences.d/ \
	config/includes.binary/etc/apt/preferences.d/
	echo "#!/bin/sh -e" > config/includes.chroot/etc/rc.local
	echo "exit 0" >> config/includes.chroot/etc/rc.local
	echo "#!/bin/sh -e" > config/includes.binary/etc/rc.local
	echo "exit 0" >> config/includes.binary/etc/rc.local
	mkdir -p config/includes.chroot/etc/live/config/
	echo 'LIVE_USER_DEFAULT_GROUPS="audio cdrom dip floppy video plugdev netdev powerdev scanner bluetooth fuse docker grsec-tpe"' > config/includes.chroot/etc/live/config/user-setup.conf
	make preseed-install

preseed-install:
	echo "d-i passwd/user-default-groups cdrom floppy audio dip video plugdev netdev scanner bluetooth wireshark docker lpadmin" > config/preseed/preseed.cfg.chroot
	echo "d-i partman-auto/choose_recipe select atomic" >> config/preseed/preseed.cfg.chroot
	echo "d-i partman-basicfilesystems/no_swap boolean false">> config/preseed/preseed.cfg.chroot
	echo 'd-i partman-auto/expert_recipe string boot-root : \'>> config/preseed/preseed.cfg.chroot
	echo '5120 1 -1 btrfs \'>> config/preseed/preseed.cfg.chroot
	echo '$$primary{ } $$bootable{ } \'>> config/preseed/preseed.cfg.chroot
	echo 'method{ format } format{ } \'>> config/preseed/preseed.cfg.chroot
	echo 'use_filesystem{ } filesystem{ btrfs } \'>> config/preseed/preseed.cfg.chroot
	echo "label { root } mountpoint{ / } .">> config/preseed/preseed.cfg.chroot
	echo "d-i passwd/user-default-groups cdrom floppy audio dip video plugdev netdev scanner bluetooth wireshark docker lpadmin" > config/preseed/preseed.cfg.binary
	echo "d-i partman-auto/choose_recipe select atomic" >> config/preseed/preseed.cfg.binary
	echo "d-i partman-basicfilesystems/no_swap boolean false">> config/preseed/preseed.cfg.binary
	echo 'd-i partman-auto/expert_recipe string boot-root : \'>> config/preseed/preseed.cfg.binary
	echo '5120 1 -1 btrfs \'>> config/preseed/preseed.cfg.binary
	echo '$$primary{ } $$bootable{ } \'>> config/preseed/preseed.cfg.binary
	echo 'method{ format } format{ } \'>> config/preseed/preseed.cfg.binary
	echo 'use_filesystem{ } filesystem{ btrfs } \'>> config/preseed/preseed.cfg.binary
	echo "label { root } mountpoint{ / } .">> config/preseed/preseed.cfg.binary
