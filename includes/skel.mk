skel:
	mkdir -p config/includes.chroot/etc/skel/Documents/Books/; \
	mkdir -p config/includes.chroot/etc/skel/Documents/Slideshows/; \
	mkdir -p config/includes.chroot/etc/skel/Documents/Papers/; \
	mkdir -p config/includes.chroot/etc/skel/Documents/Stories/; \
	mkdir -p config/includes.chroot/etc/skel/Documents/Letters/; \
	mkdir -p config/includes.chroot/etc/skel/Audio/Books/; \
	mkdir -p config/includes.chroot/etc/skel/Audio/Theatre/; \
	mkdir -p config/includes.chroot/etc/skel/Audio/Comedy/; \
	mkdir -p config/includes.chroot/etc/skel/Audio/Music/; \
	mkdir -p config/includes.chroot/etc/skel/Audio/Music/Rock/; \
	mkdir -p config/includes.chroot/etc/skel/Audio/Music/Rap/; \
	mkdir -p config/includes.chroot/etc/skel/Audio/Music/Alternative/; \
	mkdir -p config/includes.chroot/etc/skel/Audio/Music/Classical/; \
	mkdir -p config/includes.chroot/etc/skel/Audio/Music/Jazz/; \
	mkdir -p config/includes.chroot/etc/skel/Audio/Music/Blues/; \
	mkdir -p config/includes.chroot/etc/skel/Video/Movies/; \
	mkdir -p config/includes.chroot/etc/skel/Video/Television/; \
	mkdir -p config/includes.chroot/etc/skel/Video/Presentations/; \
	mkdir -p config/includes.chroot/etc/skel/Video/Classes/; \
	mkdir -p config/includes.chroot/etc/skel/ControlPanel/; \
	mkdir -p config/includes.chroot/etc/skel/Projects/; \
	mkdir -p config/includes.binary/etc/skel/Documents/Books/; \
	mkdir -p config/includes.binary/etc/skel/Documents/Slideshows/; \
	mkdir -p config/includes.binary/etc/skel/Documents/Papers/; \
	mkdir -p config/includes.binary/etc/skel/Documents/Stories/; \
	mkdir -p config/includes.binary/etc/skel/Documents/Letters/; \
	mkdir -p config/includes.binary/etc/skel/Audio/Books/; \
	mkdir -p config/includes.binary/etc/skel/Audio/Theatre/; \
	mkdir -p config/includes.binary/etc/skel/Audio/Comedy/; \
	mkdir -p config/includes.binary/etc/skel/Audio/Music/; \
	mkdir -p config/includes.binary/etc/skel/Audio/Music/Rock/; \
	mkdir -p config/includes.binary/etc/skel/Audio/Music/Rap/; \
	mkdir -p config/includes.binary/etc/skel/Audio/Music/Alternative/; \
	mkdir -p config/includes.binary/etc/skel/Audio/Music/Classical/; \
	mkdir -p config/includes.binary/etc/skel/Audio/Music/Jazz/; \
	mkdir -p config/includes.binary/etc/skel/Audio/Music/Blues/; \
	mkdir -p config/includes.binary/etc/skel/Video/Movies/; \
	mkdir -p config/includes.binary/etc/skel/Video/Television/; \
	mkdir -p config/includes.binary/etc/skel/Video/Presentations/; \
	mkdir -p config/includes.binary/etc/skel/Video/Classes/; \
	mkdir -p config/includes.binary/etc/skel/ControlPanel/; \
	mkdir -p config/includes.binary/etc/skel/Projects/; \
	echo "#bash aliases" | tee config/includes.chroot/etc/skel/.bash_aliases; \
	echo "#bash aliases" | tee config/includes.binary/etc/skel/.bash_aliases; \
	mkdir -p config/includes.chroot/etc/grsec; \
	mkdir -p config/includes.binary/etc/grsec; \
	mkdir -p config/includes.chroot/etc/grsec2; \
	mkdir -p config/includes.binary/etc/grsec2; \
	touch config/includes.chroot/etc/grsec2/pw; \
	touch config/includes.binary/etc/grsec2/pw; \
	echo "sudo gradm2 -P shutdown" | tee config/includes.chroot/etc/skel/grsec-firstrun.sh; \
	echo "sudo gradm2 -P admin" | tee -a config/includes.chroot/etc/skel/grsec-firstrun.sh; \
	echo "sudo gradm2 -P" | tee -a config/includes.chroot/etc/skel/grsec-firstrun.sh; \
	echo "sudo gradm2 -F -L /etc/grsec/learning.logs" | tee -a config/includes.chroot/etc/skel/grsec-firstrun.sh; \
	echo "sudo gradm2 -a admin" | tee -a config/includes.chroot/etc/skel/grsec-firstrun.sh; \
	echo "sudo gradm2 -P shutdown" | tee config/includes.binary/etc/skel/grsec-firstrun.sh; \
	echo "sudo gradm2 -P admin" | tee -a config/includes.binary/etc/skel/grsec-firstrun.sh; \
	echo "sudo gradm2 -P" | tee -a config/includes.binary/etc/skel/grsec-firstrun.sh; \
	echo "sudo gradm2 -a admin" | tee -a config/includes.binary/etc/skel/grsec-firstrun.sh; \
	echo "sudo gradm2 -F -L /etc/grsec/learning.logs" | tee -a config/includes.binary/etc/skel/grsec-firstrun.sh; \
	echo "sudo mv /etc/rc.local /etc/rc.local.bak \\ " | tee config/includes.chroot/etc/skel/grsec-firstshutdown.sh; \
	echo "	&& grep -v \"gradm2 -F -L /etc/grsec/learning.logs\" \"/etc/rc.local.bak\" > /etc/rc.local" | tee -a config/includes.chroot/etc/skel/grsec-firstshutdown.sh; \
	echo "sudo mv /etc/rc.local /etc/rc.local.bak \\ " | tee config/includes.binary/etc/skel/grsec-firstshutdown.sh; \
	echo "	&& grep -v \"gradm2 -F -L /etc/grsec/learning.logs\" \"/etc/rc.local.bak\" > /etc/rc.local" | tee -a config/includes.binary/etc/skel/grsec-firstshutdown.sh; \
	echo "sudo gradm2 -F -L /etc/grsec/learning.logs -O /etc/grsec/policy" | tee config/includes.chroot/etc/skel/grsec-learn.sh; \
	echo "sudo gradm2 -F -L /etc/grsec/learning.logs -O /etc/grsec/policy" | tee config/includes.binary/etc/skel/grsec-learn.sh; \

easy-user:
	echo "#!/bin/sh -e" > config/includes.chroot/etc/rc.local
	echo "exit 0" >> config/includes.chroot/etc/rc.local
	echo "#!/bin/sh -e" > config/includes.binary/etc/rc.local
	echo "exit 0" >> config/includes.binary/etc/rc.local
	mkdir -p config/includes.chroot/etc/live/config/
	echo 'LIVE_USER_DEFAULT_GROUPS="audio cdrom dip floppy video plugdev netdev powerdev scanner bluetooth fuse docker"' > config/includes.chroot/etc/live/config/user-setup.conf
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

permissive-user:
	echo "#!/bin/sh -e" > config/includes.chroot/etc/rc.local
	echo "exit 0" >> config/includes.chroot/etc/rc.local
	echo "#!/bin/sh -e" > config/includes.binary/etc/rc.local
	echo "gradm2 -F -L /etc/grsec/learning.logs &" >> config/includes.binary/etc/rc.local
	echo "exit 0" >> config/includes.binary/etc/rc.local
	mkdir -p config/includes.chroot/etc/live/config/
	echo 'LIVE_USER_DEFAULT_GROUPS="audio cdrom dip floppy video plugdev netdev powerdev scanner bluetooth fuse docker grsec-tpe"' > config/includes.chroot/etc/live/config/user-setup.conf
	echo "d-i passwd/user-default-groups cdrom floppy audio dip video plugdev netdev scanner bluetooth wireshark docker grsec-tpe lpadmin" > config/preseed/preseed.cfg.chroot
	echo "d-i partman-auto/choose_recipe select atomic" >> config/preseed/preseed.cfg.chroot
	echo "d-i partman-basicfilesystems/no_swap boolean false">> config/preseed/preseed.cfg.chroot
	echo 'd-i partman-auto/expert_recipe string boot-root : \'>> config/preseed/preseed.cfg.chroot
	echo '5120 1 -1 btrfs \'>> config/preseed/preseed.cfg.chroot
	echo '$$primary{ } $$bootable{ } \'>> config/preseed/preseed.cfg.chroot
	echo 'method{ format } format{ } \'>> config/preseed/preseed.cfg.chroot
	echo 'use_filesystem{ } filesystem{ btrfs } \'>> config/preseed/preseed.cfg.chroot
	echo "label { root } mountpoint{ / } .">> config/preseed/preseed.cfg.chroot
	echo "d-i passwd/user-default-groups cdrom floppy audio dip video plugdev netdev scanner bluetooth wireshark docker grsec-tpe lpadmin" > config/preseed/preseed.cfg.binary
	echo "d-i partman-auto/choose_recipe select atomic" >> config/preseed/preseed.cfg.binary
	echo "d-i partman-basicfilesystems/no_swap boolean false">> config/preseed/preseed.cfg.binary
	echo 'd-i partman-auto/expert_recipe string boot-root : \'>> config/preseed/preseed.cfg.binary
	echo '5120 1 -1 btrfs \'>> config/preseed/preseed.cfg.binary
	echo '$$primary{ } $$bootable{ } \'>> config/preseed/preseed.cfg.binary
	echo 'method{ format } format{ } \'>> config/preseed/preseed.cfg.binary
	echo 'use_filesystem{ } filesystem{ btrfs } \'>> config/preseed/preseed.cfg.binary
	echo "label { root } mountpoint{ / } .">> config/preseed/preseed.cfg.binary
