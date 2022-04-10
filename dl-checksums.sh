#!/usr/bin/env sh
set -e
DIR=~/Downloads
APP=caddy
GHUSER=caddyserver
MIRROR=https://github.com/${GHUSER}/${APP}/releases/download

dl() {
    local ver=$1
    local lchecksums=$2
    local os=$3
    local arch=$4
    local archive_type=${5:-tar.gz}
    local platform="${os}_${arch}"
    local file="${APP}_${ver}_${platform}.${archive_type}"
    local url="$MIRROR/v$ver/$file"
    printf "    # %s\n" $url
    printf "    %s: sha512:%s\n" $platform $(grep $file $lchecksums | awk '{print $1}')
}

dl_ver() {
    local ver=$1
    local url="$MIRROR/v$ver/${APP}_${ver}_checksums.txt"
    local lchecksums="$DIR/${APP}_${ver}_checksums.txt"
    if [ ! -e $lchecksums ];
    then
        curl -sSLf -o $lchecksums $url
    fi

    printf "  # %s\n" $url
    printf "  '%s':\n" $ver

    dl $ver $lchecksums freebsd amd64
    dl $ver $lchecksums freebsd arm64
    dl $ver $lchecksums freebsd armv6
    dl $ver $lchecksums freebsd armv7
    dl $ver $lchecksums linux amd64
    dl $ver $lchecksums linux arm64
    dl $ver $lchecksums linux armv5
    dl $ver $lchecksums linux armv6
    dl $ver $lchecksums linux armv7
    dl $ver $lchecksums linux ppc64le
    dl $ver $lchecksums linux s390x
    dl $ver $lchecksums mac amd64
    dl $ver $lchecksums windows amd64 zip
}

dl_ver ${1:-2.4.6}
