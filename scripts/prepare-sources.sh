#!/bin/bash
# Prepare pinned sources in a new build tree; do not compile or run audio tests.
set -euo pipefail
repo=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
base=${1:-"$repo/_build"}
mkdir -p "$base"
base=$(cd -- "$base" && pwd)
test ! -e "$base/pulseaudio-module-xrdp"
test ! -e "$base/pulseaudio-17.0+dfsg1"
(cd "$repo/sources"; sha256sum -c SHA256SUMS)
cp -a "$repo/upstream/pulseaudio-module-xrdp" "$base/pulseaudio-module-xrdp"
# dpkg-source verifies the archive checksums in the bundled .dsc file.
dpkg-source --no-check -x "$repo/sources/pulseaudio_17.0+dfsg1-2.dsc" "$base/pulseaudio-17.0+dfsg1"
printf 'Sources prepared. To build:\nBUILD_ROOT=%q bash %q\n' "$base" "$repo/scripts/build-deb.sh"
