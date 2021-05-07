#!/bin/sh
COUNT=100 ## Number of characters to show near error.
if [ "$@" ]; then
    COUNT=$1
fi
X="$(./runIconv.sh 2>&1 > /dev/null)"
if [ ! -n "$X"  ]; then
    echo "iconv was happy-no character encoding issues detected"
    rm out.txt
    rm error.txt
    exit
fi
POS=`echo "$X" | cut -d ' ' -f 7`
dd if=hp-edit.owl of=error.txt bs=1 count=$COUNT skip=$POS

echo "*************************************************"
echo "*************************************************"
echo "** Character error found in hp.edit by iconv at $POS"

hexdump -C error.txt
rm out.txt
echo "*************************************************"
echo "*************************************************"

