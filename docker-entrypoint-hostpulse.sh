#!/bin/sh
set -e

USER_UID=${USER_UID:-1000}
USER_GID=${USER_GID:-1000}
CMD=${1:-dosbox}

# create user group
if ! getent group gamer >/dev/null; then
	addgroup -g ${USER_GID} gamer
fi

# create user with uid and gid matching that of the host user
if ! getent passwd gamer >/dev/null; then
	adduser -u ${USER_UID} -G gamer \
		-D -s /bin/sh \
		-g 'Gamer' gamer
fi


exec su gamer -c $CMD

exit 0
