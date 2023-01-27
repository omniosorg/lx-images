#!/bin/sh

touch /etc/void-release

cat << EOM >> /etc/rc.conf

# Let runit know we're virtualised
export VIRTUALIZATION=1

EOM

sed -i '
	/^#HOSTNAME=/c\
HOSTNAME=lx
	/^#TIMEZONE=/c\
TIMEZONE="UTC"
' /etc/rc.conf

# Disable sysctl changes (reduces console noise on boot)
sed -i 's/^[a-z]/#&/' /usr/lib/sysctl.d/10-void.conf

# Update the package manager
xbps-install -ySu xbps
# Update all packages
xbps-install -ySu
# Install extras
xbps-install -ySu \
	iproute2 iputils net-tools \
	vpm vsv \
	ncurses-base \
	openssh joe vim \
	rsyslog \
	jq

xbps-alternatives -g vi -s vim-common

# Clean up cache and remove orphans
xbps-remove -yOo

svdir=/etc/runit/runsvdir/default

# Disable default agetty services
rm -f $svdir/agetty-tty*

# Enable serial console
ln -s /etc/sv/agetty-console $svdir/

