sudo mv /etc/rc.local /etc/rc.local.bak \ 
	&& grep -v "gradm2 -F -L /etc/grsec/learning.logs" "/etc/rc.local.bak" > /etc/rc.local
