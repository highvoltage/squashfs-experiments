#!/bin/bash

# Set up environment
echo " * Setting up..."
mkdir -p squashfs
mkdir -p tmpfs
mkdir -p results
mount filesystem.squashfs squashfs
mount -t tmpfs none tmpfs -o size=80%
cp -R squashfs/. tmpfs/

# Crunch
for COMPRESSION_TYPE in gzip lzo xz; do
    echo " - Testing $COMPRESSION_TYPE"
    for BLOCK_SIZE in 4096 8192 16384 32768 65536 131072; do
    FILENAME="results/squashfs-$COMPRESSION_TYPE-$BLOCK_SIZE.squashfs"
    echo "   * Running a squashfs using compression $COMPRESSION_TYPE, blocksize $BLOCK_SIZE"
    ( time mksquashfs tmpfs $FILENAME \
                      -b $BLOCK_SIZE -comp $COMPRESSION_TYPE -noappend ) \
                      >  $FILENAME.results \
                      2> $FILENAME.compress_time
    done
done

echo " * Testing uncompressing times..."
for FILENAME in $(ls results/*.squashfs); do
    mkdir -p squashfs.extract
    echo "   * Reading $FILENAME..."
    # Catting things in /dev... not so great idea (and it's trivially small anyway)
    mount $FILENAME squashfs.extract
    (time $(find squashfs.extract | grep -v "/dev" | xargs cat - > /dev/null)) 2> $FILENAME.uncompress_time
    REALTIME=$(grep "real" $FILENAME.uncompress_time | \
               tail -n 1 | awk '{print $2}')
    echo $REALTIME > $FILENAME.uncompress_time
    sync
    umount squashfs.extract
    rmdir squashfs.extract
done

# Clean up
echo " * Cleaning up..."
umount -l squashfs
umount -l tmpfs
rmdir squashfs
rmdir tmpfs
