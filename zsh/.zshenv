# some special aliases for slackware
if [ -e /etc/slackware-version ]; then
	[ "$USER" = "mumahendras3" ] && export PATH="${PATH}:/usr/local/sbin:/usr/sbin:/sbin"
fi
