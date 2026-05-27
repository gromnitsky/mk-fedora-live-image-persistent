Converts a stock Fedora Live Workstation .iso (or any spin) to a
bootable image with persistence.

~~~
$ scc m* | grep ^[LS]
Language  Files  Lines  Blanks  Comments  Code  Complexity
Shell     4      135    35      7         93    12
~~~

## What this does

1. Mounts an EROFS image from a Fedora live .iso.
2. Creates an EFI image with Fedora's kernel and initramfs.
3. Creates an ext4 image with all OS files.
4. Combines the 2 images into 1.

You specify an amount of *free space* available in the ext4 image as
the 1st argument:

    $ sudo V=1 ./mflip 2G Fedora-Xfce-Live-44-1.7.x86_64.iso out.img

Internally, *mflip* runs all .sh scripts. *sudo* is required to copy
the OS files into the ext4 image w/ proper permissions.

To change the default kernel cmdline, edit `EFI/BOOT/grub.cfg`.

## See also

[mk-debian-live-iso-persistent](https://github.com/gromnitsky/mk-debian-live-iso-persistent)

## &#x2672; Loicense

MIT
