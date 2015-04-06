# squashfs-experiments

Script to test performance and compression of squashfs images

See also: https://jonathancarter.org/2015/04/06/squashfs-performance-testing/

Dependencies: squashfs-tools

The way it currently works, you'll need a lot of disk space. (by default, around 25GB), will probably be changed in future versions.

./test-mksquashfs.sh will create a directory called 'results' that contains the squashfs images along with mksquashfs output and compression/uncompression times.

./report.sh will use the information from that directory and output it in CSV

For most accurate results, your computer shouldn't be doing anything else when running these. Close any other progress or reboot and log in from a VT with cron and similar services disabled.
