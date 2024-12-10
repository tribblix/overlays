#!/bin/sh
#
# SPDX-License-Identifier: CDDL-1.0
#
# verify that the overlays on the iso(s) are consistent
#

case $# in
    0)
	OVLISO=overlays.iso
	;;
    1)
	OVLISO=overlays.${1}.iso
	;;
    *)
	echo "Usage: $0 [variant]"
	exit 2
	;;
esac

if [ ! -f "${OVLISO}" ]; then
    echo "ERROR: no ${OVLISO} file"
    exit 1
fi

for novl in $(cat "${OVLISO}")
do
    if [ ! -f "${novl}.ovl" ]; then
	echo "ERROR: missing overlay $novl"
    fi
    if [ ! -f "${novl}.pkgs" ]; then
	echo "ERROR: missing pkgs for overlay $novl"
    fi
done

CKDIR=/tmp/novl.$$
rm -fr $CKDIR
mkdir -p $CKDIR
if [ ! -d $CKDIR ]; then
    echo "ERROR: unable to create check directory"
    exit 2
fi

sort "${OVLISO}" > ${CKDIR}/list.orig
sort -u "${OVLISO}" > ${CKDIR}/list.orig.uniq

DIFF1=$(diff ${CKDIR}/list.orig ${CKDIR}/list.orig.uniq)
if [ -n "$DIFF1" ]; then
    echo "ERROR: ${OVLISO} has duplicate entries"
fi

grep -h '^REQUIRES=' $(awk '{print $1".ovl"}' "${OVLISO}") | awk -F= '{print $2}' >> ${CKDIR}/list.orig.uniq
sort -u ${CKDIR}/list.orig.uniq > ${CKDIR}/list.combo

DIFF1=$(diff ${CKDIR}/list.orig ${CKDIR}/list.combo)
if [ -n "$DIFF1" ]; then
    echo "ERROR: ${OVLISO} has missing dependencies"
    diff ${CKDIR}/list.orig ${CKDIR}/list.combo
fi

#
# clean up
#
rm -fr $CKDIR
