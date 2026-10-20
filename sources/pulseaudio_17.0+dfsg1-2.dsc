-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

Format: 3.0 (quilt)
Source: pulseaudio
Binary: pulseaudio, pulseaudio-utils, pulseaudio-module-zeroconf, pulseaudio-module-jack, pulseaudio-module-lirc, pulseaudio-module-gsettings, pulseaudio-module-raop, pulseaudio-module-bluetooth, pulseaudio-equalizer, libpulse0, libpulse-mainloop-glib0, libpulse-dev, libpulsedsp
Architecture: any
Version: 17.0+dfsg1-2
Maintainer: Pulseaudio maintenance team <pkg-pulseaudio-devel@lists.alioth.debian.org>
Uploaders: Sjoerd Simons <sjoerd@debian.org>, Felipe Sateler <fsateler@debian.org>, Sebastien Bacher <seb128@debian.org>
Homepage: http://pulseaudio.org
Standards-Version: 4.7.0
Vcs-Browser: https://salsa.debian.org/pulseaudio-team/pulseaudio
Vcs-Git: https://salsa.debian.org/pulseaudio-team/pulseaudio.git
Testsuite: autopkgtest
Testsuite-Triggers: build-essential
Build-Depends: debhelper-compat (= 13), meson, ninja-build, check <!nocheck>, desktop-file-utils <!nocheck>, dh-exec, intltool, libasound2-dev [linux-any], libasyncns-dev, libavahi-client-dev, libbluetooth-dev [linux-any] <!stage1>, libsbc-dev [linux-any], libcap-dev [linux-any], libfftw3-dev, libglib2.0-dev, libgstreamer1.0-dev, libgstreamer-plugins-base1.0-dev, libgtk-3-dev, libice-dev, libjack-dev, liblirc-dev, libltdl-dev, liborc-0.4-dev, libsndfile1-dev, libsoxr-dev, libspeexdsp-dev, libssl-dev, libsystemd-dev [linux-any], libtdb-dev, libudev-dev [linux-any], libwebrtc-audio-processing-dev (>= 1.0) [linux-any], libwrap0-dev, libx11-xcb-dev, libxcb1-dev, libxml2-utils <!nocheck>, libxtst-dev, systemd-dev [linux-any]
Package-List:
 libpulse-dev deb libdevel optional arch=any
 libpulse-mainloop-glib0 deb libs optional arch=any
 libpulse0 deb libs optional arch=any
 libpulsedsp deb libs optional arch=amd64,arm64,i386,mips64el,ppc64el,riscv64,s390x,alpha,hurd-amd64,ia64,loong64,ppc64,sparc64,x32
 pulseaudio deb sound optional arch=any
 pulseaudio-equalizer deb sound optional arch=any
 pulseaudio-module-bluetooth deb sound optional arch=linux-any profile=!stage1
 pulseaudio-module-gsettings deb sound optional arch=any
 pulseaudio-module-jack deb sound optional arch=any
 pulseaudio-module-lirc deb sound optional arch=any
 pulseaudio-module-raop deb sound optional arch=any
 pulseaudio-module-zeroconf deb sound optional arch=any
 pulseaudio-utils deb sound optional arch=any
Checksums-Sha1:
 3eca8dc561e0a98abe90073b77e51d9d2f7f3c78 1459260 pulseaudio_17.0+dfsg1.orig.tar.xz
 f085130256ebd0a95db63156d6433a6698c4202e 41188 pulseaudio_17.0+dfsg1-2.debian.tar.xz
Checksums-Sha256:
 24a25d3cf8fcede801f6b3d05ca6d22b0a43ad2f710a4fbf2ec251debc9cff5b 1459260 pulseaudio_17.0+dfsg1.orig.tar.xz
 011e00b40902c9401eaf5c61921e2738c1782e7959581526cd701a74bfb6ba92 41188 pulseaudio_17.0+dfsg1-2.debian.tar.xz
Files:
 1dd3c05d50f988b0ff438808d143d6e4 1459260 pulseaudio_17.0+dfsg1.orig.tar.xz
 2a7cd69cc37bd685aa30c7b6e1f54bc6 41188 pulseaudio_17.0+dfsg1-2.debian.tar.xz

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEETQvhLw5HdtiqzpaW5mx3Wuv+bH0FAmeaWVgACgkQ5mx3Wuv+
bH0gkg//b++f2ybFEuO4fOjw5KHYhISvefF2PCDDAqDh9STfY8bWgt8dOHVJvLsk
59S/9puoOwaC2YECb2D+tZquRpAB3SqX2uDROzSzVgkyJuxtcKOUugJzS6rk2Qqo
4Mjd8uKGryEpT8DwFOmEKoS9tfuHtLXBu69U194r3BwZRKaKhS5/bP8WgRKfNIR8
QrhuQ8f4S5CscveZxM8ljUTSTC4pG3EjJZTPkJ2u9MNmaFrPjGo5grEaC31dASqw
8hKvvDJOUGO3AS3AzrrGgQC8KJIEwnZgSs4lu+OoQb1UZcDQv0MT5UgUKi7XUjdN
XHxlsbHpIxf0Cgu9ZYCixfguOR2xQLQZAh4iKR5RvnrbQU6TPaFxOxH417lRRhzb
KPS6xZhhFE2sxDnUxt37eHqjsXIVLZcczfSO/i23rjvxOtaODLO2iPwrRoAjsnU0
G22SHunNbTZTyp6JEsYBo5I1eRH9hMW2nypMPpiqzBedQpFC7mzFZy6l7cUbNQDX
MgddfD+kbiFOiiRcUylCDOBHXP6pYBJSk++bqZv1dHrMJiv3edBoNyZDHyV9/za1
Z86Su3Yf1ciV53+0fEKEScBhywFMIe3V2jgFmZqOgAVtTSwWntfxusbBA9EoUw8j
2RY/VOYrCn0DOOTDY2mMklOfPQ53s4aFpZ4UOsfYIWbu/drXlHM=
=NENn
-----END PGP SIGNATURE-----
