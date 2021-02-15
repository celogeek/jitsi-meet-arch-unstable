#!/bin/bash

set -e

cat <<__EOF__
This package is deprecated.
I now maintain the package on AUR, so use this one instead.

Take a look at the "From AUR" section. And pick the stable version.
__EOF__
exit

cd debian
git checkout master
git pull

JITSI_MEET_VERSION=$(git describe | sed 's/jitsi-meet_//')
JITSI_MEET_WEB_VERSION=$(cat jitsi-meet-web)
JITSI_VIDEOBRIDGE=$(cat jitsi-videobridge)
JITSI_VIDEOBRIDGE_VERSION=$(cat jitsi-videobridge | tr '-' '+')
JICOFO=$(cat jicofo)

cd ..

cat << __EOF__
JITSI_MEET_VERSION=$JITSI_MEET_VERSION
JITSI_MEET_WEB_VERSION=$JITSI_MEET_WEB_VERSION
JITSI_VIDEOBRIDGE=$JITSI_VIDEOBRIDGE
JICOFO=$JICOFO
__EOF__


sed -i "s@^_tag_version=.*@_tag_version=$JITSI_MEET_VERSION@" jitsi-meet/PKGBUILD
sed -i "s@^_version=.*@_version=2.0.$JITSI_MEET_VERSION@" jitsi-meet/PKGBUILD

sed -i "s@^_tag=.*@_tag=$JITSI_MEET_WEB_VERSION@" jitsi-meet-{web,prosody,turnserver}/PKGBUILD
sed -i "s@^_version=.*@_version=1.0.$JITSI_MEET_WEB_VERSION@" jitsi-meet-{web,prosody,turnserver}/PKGBUILD

sed -i "s@^_tag=.*@_tag=$JITSI_VIDEOBRIDGE@" jitsi-videobridge/PKGBUILD
sed -i "s@^_version=.*@_version=$JITSI_VIDEOBRIDGE_VERSION@" jitsi-videobridge/PKGBUILD

sed -i "s@^_tag=.*@_tag=$JICOFO@" jicofo/PKGBUILD
sed -i "s@^_version=.*@_version=1.0+$JICOFO@" jicofo/PKGBUILD

for i in */PKGBUILD
do
	cd "$(dirname "$i")"
	pwd
	rm -f *.part
	updpkgsums
	makepkg --printsrcinfo > .SRCINFO
	cd ..
done

