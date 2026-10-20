#!/bin/bash
# Run in Debian 13 arm64 userspace. No audio/session tests are run.
set -euo pipefail
export LC_ALL=C.UTF-8
repo=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
base=${BUILD_ROOT:-"$repo/_build"}
src="$base/pulseaudio-module-xrdp"
pa="$base/pulseaudio-17.0+dfsg1"
out="$base/packages"
version=0.8-1~deb13+local1
test "$(dpkg --print-architecture)" = arm64
test "$(. /etc/os-release; echo "$ID")" = debian
test "$(. /etc/os-release; echo "$VERSION_ID")" = 13
pa_source_version=$(dpkg-query -W -f='${source:Version}' pulseaudio)
if [ "$pa_source_version" != 17.0+dfsg1-2 ]; then
    printf 'PulseAudio source version %s differs from bundled 17.0+dfsg1-2; update sources before rebuilding.\n' "$pa_source_version" >&2
    exit 1
fi
test -f "$src/configure.ac"
test -f "$pa/meson.build"
mkdir -p "$out"

# Only generate PulseAudio's internal headers; do not build its daemon.
if [ ! -f "$pa/build/config.h" ]; then
    meson setup "$pa/build" "$pa" --prefix=/usr \
        --libdir=lib/aarch64-linux-gnu --auto-features=disabled \
        -Ddoxygen=false -Dman=false -Dtests=false -Ddatabase=simple \
        -Ddbus=enabled -Dmodlibexecdir=/usr/lib/pulse-17.0+dfsg1/modules
fi

cd "$src"
./bootstrap
export DEB_BUILD_MAINT_OPTIONS=hardening=+all
eval "$(dpkg-buildflags --export=sh)"
./configure --prefix=/usr --libexecdir=/usr/libexec \
    PULSE_DIR="$pa" PULSE_CONFIG_DIR="$pa/build"
make -j2

# Stage into a fresh directory. Never use make install against the live system.
stage=$(mktemp -d "$base/pkg-stage.XXXXXXXX")
chmod 755 "$stage"
make DESTDIR="$stage" install
find "$stage" -type f -name '*.la' -delete
moddir=$(pkg-config --variable=modlibexecdir libpulse)
modules=("$stage$moddir/module-xrdp-sink.so" "$stage$moddir/module-xrdp-source.so")
for module in "${modules[@]}"; do
    strip --strip-unneeded "$module"
    readelf -h "$module" | grep -q 'Machine:.*AArch64'
done

# Use dpkg's shared library dependency calculation (inspection, not execution).
mkdir -p debian
cat > debian/control <<'CONTROL'
Source: pulseaudio-module-xrdp
Section: sound
Priority: optional
Maintainer: Local Builder <builder@localhost>

Package: pulseaudio-module-xrdp
Architecture: arm64
Description: xrdp PulseAudio audio output and input modules
CONTROL
shlibs=$(dpkg-shlibdeps --warnings=0 -O -e"${modules[0]}" -e"${modules[1]}")
shlibs=${shlibs#shlibs:Depends=}
pa_version=$(dpkg-query -W -f='${Version}' pulseaudio)
mkdir -p "$stage/DEBIAN" "$stage/usr/share/doc/pulseaudio-module-xrdp"
install -m644 LICENSE "$stage/usr/share/doc/pulseaudio-module-xrdp/copyright"
install -m644 README.md "$stage/usr/share/doc/pulseaudio-module-xrdp/README.upstream"
cat > "$stage/usr/share/doc/pulseaudio-module-xrdp/BUILD-INFO" <<INFO
Upstream tag: v0.8
Upstream commit: f36911ee49a85dce19ecc3d53b0edaee624c9faa
Debian PulseAudio source: 17.0+dfsg1-2
Debian PulseAudio binary: $pa_version
Compiler target: $(gcc -dumpmachine)
Compiler version: $(gcc -dumpfullversion)
Module directory: $moddir
CFLAGS: $CFLAGS
LDFLAGS: $LDFLAGS
Build mode: target-architecture compiler in Debian 13 arm64 userspace
Validation: package metadata and ELF inspection only; runtime NOT tested
INFO
cat > "$stage/usr/share/doc/pulseaudio-module-xrdp/README.Debian" <<'README'
Local Debian 13 arm64 build of upstream v0.8.
Contains module-xrdp-sink.so and module-xrdp-source.so, the upstream module
loader, and the XDG autostart entry. No PulseAudio daemon is bundled.

The package requires the PulseAudio binary version used at build time,
following the version matching of Debian's own PulseAudio module packages.
It uses internal APIs; a different PulseAudio version may need a rebuild.
PipeWire's PulseAudio compatibility server cannot load these modules.

On desktops supporting XDG autostart the upstream loader runs at login.
In a minimal xterm session, start PulseAudio as the logged-in user if needed,
then run /usr/libexec/pulseaudio-module-xrdp/load_pa_modules.sh from that
xrdp session. Do not run the loader as root or outside the xrdp session.

Runtime audio, microphone, session reconnect, and clean-device installation
have NOT been tested. This is a candidate package for manual validation.
README
cat > "$stage/DEBIAN/control" <<CONTROL
Package: pulseaudio-module-xrdp
Version: $version
Architecture: arm64
Section: sound
Priority: optional
Maintainer: Local Builder <builder@localhost>
Depends: pulseaudio (= $pa_version), pulseaudio-utils (= $pa_version), xrdp (>= 0.9.8), $shlibs
Installed-Size: $(du -sk "$stage/usr" "$stage/etc" | awk '{n+=$1} END {print n}')
Homepage: https://github.com/neutrinolabs/pulseaudio-module-xrdp
Description: PulseAudio audio output and input modules for xrdp
 Prebuilt Debian 13 arm64 modules with the upstream XDG autostart loader.
 Built against Debian PulseAudio's private module API.
CONTROL
find "$stage/etc" -type f -printf '/etc/%P\n' | sort > "$stage/DEBIAN/conffiles"
(cd "$stage"; find usr etc -type f -print0 | sort -z | xargs -0 md5sum > DEBIAN/md5sums)
package="$out/pulseaudio-module-xrdp_0.8_debian13_arm64.deb"
dpkg-deb --root-owner-group -Zxz --build "$stage" "$package"
dpkg-deb --info "$package"
dpkg-deb --contents "$package"
sha256sum "$package" > "$out/SHA256SUMS"
printf '%s\n' "$stage" > "$out/staging-directory.txt"
printf 'PACKAGE_BUILT: %s\n' "$package"
