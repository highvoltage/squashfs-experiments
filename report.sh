#!/bin/sh

echo "Filename, Size, Ratio, CTIME, CRATE, UTIME, URATE"
cd results
for FILENAME in $(ls *squashfs | sort -V); do
    FILESIZE=$(du $FILENAME | awk '{print $1}')
    RATIO=$(grep "of uncompressed filesystem" $FILENAME.results | awk '{print $1}')
    CTIME=$(cat $FILENAME.compress_time | grep real | awk '{print $2}')
    CRATE="NI"
    UTIME=$(cat $FILENAME.uncompress_time)
    URATE="NI"
    echo "$FILENAME, $FILESIZE, $RATIO, $CTIME, $CRATE, $UTIME, $URATE"
done
