# Building the Debian package

These instructions are for rebuilding the package. They are not needed to install the prebuilt `.deb`.

## Requirements

Use a Debian 13 arm64 userspace, either on native arm64 hardware or through QEMU. The build script checks the distribution, architecture, and installed PulseAudio source version.

Install the build dependencies:

```sh
sudo apt update
sudo apt install --no-install-recommends \
  build-essential autoconf automake libtool pkg-config \
  libpulse-dev pulseaudio pulseaudio-utils meson ninja-build \
  libsndfile1-dev libdbus-1-dev libcap-dev libltdl-dev
```

The bundled PulseAudio source is `17.0+dfsg1-2`. The published package was built with the Debian binary packages at `17.0+dfsg1-2+b1`. If the repository has moved to another source version, update the bundled sources and build configuration rather than bypassing the version check.

## Prepare and build

From the repository root:

```sh
bash scripts/prepare-sources.sh
bash scripts/build-deb.sh
```

The default build directory is `_build/`. Source preparation refuses to overwrite existing source directories. A new absolute path can also be used:

```sh
bash scripts/prepare-sources.sh /absolute/path/audio-build
BUILD_ROOT=/absolute/path/audio-build bash scripts/build-deb.sh
```

## Packaging process

1. Configure the Debian PulseAudio sources with Meson to generate internal headers.
2. Run bootstrap, configure, and make for the upstream xrdp modules.
3. Stage files with `make DESTDIR=... install`.
4. Remove libtool `.la` files, strip debug symbols, and inspect the ELF architecture.
5. Generate shared-library dependencies with `dpkg-shlibdeps` and write the Debian control metadata, checksums, and documentation.
6. Assemble the archive with `dpkg-deb --root-owner-group -Zxz --build`.

The PulseAudio source tree is used to generate headers. Its optional feature settings do not replace or modify the installed PulseAudio daemon. No replacement PulseAudio daemon is built.

## Output

```text
_build/packages/pulseaudio-module-xrdp_0.8-1~deb13+local1_arm64.deb
_build/packages/SHA256SUMS
```

The package contains both audio modules, the upstream loader and XDG autostart entry, and license/build information. Archive ownership is set to root:root.

The published build uses Debian GCC `14.2.0-19`, targeting `aarch64-linux-gnu`, with `dpkg-buildflags` and `DEB_BUILD_MAINT_OPTIONS=hardening=+all`. No `-march=native` option is used.

The source archives and scripts support rebuilding the package. Byte-for-byte reproducibility has not been established.
