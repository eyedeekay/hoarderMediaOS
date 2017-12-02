
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
	echo "#!/bin/sh -e" | tee config/includes.chroot/etc/rc.local
	echo "exit 0" | tee -a config/includes.chroot/etc/rc.local
	echo "#!/bin/sh -e" | tee config/includes.binary/etc/rc.local
	echo "exit 0" | tee -a config/includes.binary/etc/rc.local
	mkdir -p config/includes.chroot/etc/live/config/
	echo 'LIVE_USER_DEFAULT_GROUPS="audio cdrom dip floppy video plugdev netdev powerdev scanner bluetooth fuse docker"' | tee config/includes.chroot/etc/live/config/user-setup.conf
	make preseed-install

permissive-user:
	mkdir -p config/includes.chroot/etc/apt/preferences.d/ \
		config/includes.binary/etc/apt/preferences.d/
	echo "#!/bin/sh -e" | tee config/includes.chroot/etc/rc.local
	echo "exit 0" | tee -a config/includes.chroot/etc/rc.local
	echo "#!/bin/sh -e" | tee config/includes.binary/etc/rc.local
	echo "exit 0" | tee -a config/includes.binary/etc/rc.local
	mkdir -p config/includes.chroot/etc/live/config/
	echo 'LIVE_USER_DEFAULT_GROUPS="audio cdrom dip floppy video plugdev netdev powerdev scanner bluetooth fuse docker grsec-tpe"' | tee config/includes.chroot/etc/live/config/user-setup.conf
	make preseed-install

preseed-install:
	echo "d-i passwd/user-default-groups cdrom floppy audio dip video plugdev netdev scanner bluetooth wireshark docker lpadmin" | tee config/preseed/preseed.cfg.chroot
	echo "d-i partman-auto/choose_recipe select atomic" | tee -a config/preseed/preseed.cfg.chroot
	echo "d-i partman-basicfilesystems/no_swap boolean false" | tee -a config/preseed/preseed.cfg.chroot
	echo 'd-i partman-auto/expert_recipe string boot-root : \' | tee -a config/preseed/preseed.cfg.chroot
	echo '5120 1 -1 btrfs \' | tee -a config/preseed/preseed.cfg.chroot
	echo '$$primary{ } $$bootable{ } \' | tee -a config/preseed/preseed.cfg.chroot
	echo 'method{ format } format{ } \' | tee -a config/preseed/preseed.cfg.chroot
	echo 'use_filesystem{ } filesystem{ btrfs } \' | tee -a config/preseed/preseed.cfg.chroot
	echo "label { root } mountpoint{ / } ." | tee -a config/preseed/preseed.cfg.chroot
	echo "d-i passwd/user-default-groups cdrom floppy audio dip video plugdev netdev scanner bluetooth wireshark docker lpadmin" | tee config/preseed/preseed.cfg.binary
	echo "d-i partman-auto/choose_recipe select atomic" | tee -a config/preseed/preseed.cfg.binary
	echo "d-i partman-basicfilesystems/no_swap boolean false" | tee -a config/preseed/preseed.cfg.binary
	echo 'd-i partman-auto/expert_recipe string boot-root : \' | tee -a config/preseed/preseed.cfg.binary
	echo '5120 1 -1 btrfs \' | tee -a config/preseed/preseed.cfg.binary
	echo '$$primary{ } $$bootable{ } \' | tee -a config/preseed/preseed.cfg.binary
	echo 'method{ format } format{ } \' | tee -a config/preseed/preseed.cfg.binary
	echo 'use_filesystem{ } filesystem{ btrfs } \' | tee -a config/preseed/preseed.cfg.binary
	echo "label { root } mountpoint{ / } ." | tee -a config/preseed/preseed.cfg.binary
