#!/bin/sh

# Update the package manager
apk update
# Update all packages
apk upgrade

# Install extras
apk add -u \
	alpine-base \
	alpine-conf \
	alpine-release \
	apk-tools-doc \
        bash \
	bind-tools \
	busybox-mdev-openrc \
	busybox-openrc \
	busybox-suid \
	curl \
	logrotate \
	logrotate-openrc \
	man-db \
	man-pages \
	mdev-conf \
	openrc \
	openssh \
	sudo \
	vim

# Enable services
rc-update add bootmisc boot
rc-update add devfs boot
rc-update add syslog boot
rc-update add crond default
rc-update add local default
rc-update add sshd default
