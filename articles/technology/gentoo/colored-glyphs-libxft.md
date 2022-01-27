Colored glyphs with libXft
Patching libXft to achieve colored glyphs, emojis.
libxft, xft, xorg, x11, emoji, emojis, colored glyphs, gentoo, patching, portage, bgra

If you want to use colored emojis, you have to patch libXft, because it still doesn't support BGRA glyphs out-of-the-box.
Arch-based distros have [libxft-bgra](https://aur.archlinux.org/packages/libxft-bgra) in the AUR which is already patched.
We can achieve exactly the same result with Gentoo.
[Portage supports applying patches to source code.](https://wiki.gentoo.org/wiki//etc/portage/patches)

## Steps

1. Create a directory for libXft patches: `mkdir -p /etc/portage/patches/x11-libs/libXft`,
* `cd` into the previously created directory,
* Download the patch: `wget -O bgra_support.patch https://gitlab.freedesktop.org/xorg/lib/libxft/-/merge_requests/1.patch`.

And that's it!

![Screenshot of dwm with colored glyphs](/assets/pix/gentoo/libxft_screenshot.webp)
