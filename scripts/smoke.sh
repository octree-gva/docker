#!/usr/bin/env bash
set -euo pipefail

IMAGE="${1:?image reference required}"

# Root so apt/dnf can refresh indexes for the distro-latest package check.
docker run --rm -i --user root --entrypoint bash "$IMAGE" -s <<'EOS'
set -euo pipefail

fail() { echo "SMOKE FAIL: $*" >&2; exit 1; }

echo "== bundle / ruby / assets =="
bundle check
ruby -v
test -d public/decidim-packs || test -d public/assets

echo "== libvips present =="
command -v vips >/dev/null || fail "vips not on PATH"
vips --version

echo "== libvips at distro latest =="
VIPS_BIN="$(command -v vips)"
if command -v apt-get >/dev/null 2>&1; then
  export DEBIAN_FRONTEND=noninteractive
  apt-get update -qq
  PKG="$(dpkg -S "$VIPS_BIN" | head -1 | cut -d: -f1)"
  INSTALLED="$(dpkg-query -W -f='${Version}' "$PKG")"
  CANDIDATE="$(apt-cache policy "$PKG" | awk '/Candidate:/ {print $2; exit}')"
  echo "package=$PKG installed=$INSTALLED candidate=$CANDIDATE"
  test -n "$CANDIDATE" && test "$CANDIDATE" != "(none)" || fail "no apt candidate for $PKG"
  test "$INSTALLED" = "$CANDIDATE" || fail "$PKG not at candidate ($INSTALLED != $CANDIDATE)"
elif command -v dnf >/dev/null 2>&1; then
  PKG="$(rpm -qf --qf '%{NAME}' "$VIPS_BIN")"
  dnf -q makecache || true
  INSTALLED="$(rpm -q --qf '%{EPOCH}:%{VERSION}-%{RELEASE}' "$PKG" | sed 's/^(none):/0:/')"
  CANDIDATE="$(dnf -q repoquery --latest-limit 1 --qf '%{epoch}:%{version}-%{release}' "$PKG" | sed 's/^(none):/0:/' | head -1)"
  echo "package=$PKG installed=$INSTALLED candidate=$CANDIDATE"
  test -n "$CANDIDATE" || fail "no dnf candidate for $PKG"
  test "$INSTALLED" = "$CANDIDATE" || fail "$PKG not at candidate ($INSTALLED != $CANDIDATE)"
else
  fail "unsupported package manager"
fi

echo "== libvips codecs (mozjpeg/libjpeg, libexif, libtiff, libpng/spng, libwebp) =="
CFG="$(vips --vips-config)"
echo "$CFG" | grep -q "EXIF metadata support with libexif: true" || fail "libexif not enabled in vips"
echo "$CFG" | grep -q "JPEG load/save with libjpeg: true" || fail "libjpeg/mozjpeg not enabled in vips"
echo "$CFG" | grep -E -q "PNG load/save with lib(png|spng): true" || fail "libpng/libspng not enabled in vips"
echo "$CFG" | grep -E -q "TIFF load/save with libtiff(-4)?: true" || fail "libtiff not enabled in vips"
echo "$CFG" | grep -q "WebP load/save with libwebp: true" || fail "libwebp not enabled in vips"

echo "== ImageMagick absent =="
if command -v convert >/dev/null 2>&1; then
  fail "convert is on PATH (ImageMagick must not be installed)"
fi
if convert --version >/dev/null 2>&1; then
  fail "convert --version succeeded (ImageMagick must not be installed)"
fi
echo "convert not available (ok)"

echo "== rails entrypoints =="
cd /home/decidim
RAILS_CMD="$(command -v rails || true)"
test -n "$RAILS_CMD" || fail "rails not on PATH"
test -x bin/rails || fail "bin/rails missing"
V_RAILS="$(rails -v)"
V_BIN="$(bin/rails -v)"
V_BUNDLE="$(bundle exec rails -v)"
echo "rails:        $V_RAILS ($RAILS_CMD)"
echo "bin/rails:    $V_BIN"
echo "bundle exec:  $V_BUNDLE"
test "$V_RAILS" = "$V_BIN" || fail "rails != bin/rails ($V_RAILS vs $V_BIN)"
test "$V_BIN" = "$V_BUNDLE" || fail "bin/rails != bundle exec rails ($V_BIN vs $V_BUNDLE)"

echo "== shakapacker entrypoints =="
cd /home/decidim
SHAKA_CMD="$(command -v shakapacker || true)"
test -n "$SHAKA_CMD" || fail "shakapacker not on PATH"
test -x bin/shakapacker || fail "bin/shakapacker missing"
V_SHAKA="$(shakapacker -v)"
V_SHAKA_BIN="$(bin/shakapacker -v)"
V_SHAKA_BUNDLE="$(bundle exec shakapacker -v)"
echo "shakapacker:        $V_SHAKA ($SHAKA_CMD)"
echo "bin/shakapacker:    $V_SHAKA_BIN"
echo "bundle exec:        $V_SHAKA_BUNDLE"
test "$V_SHAKA" = "$V_SHAKA_BIN" || fail "shakapacker != bin/shakapacker ($V_SHAKA vs $V_SHAKA_BIN)"
test "$V_SHAKA_BIN" = "$V_SHAKA_BUNDLE" || fail "bin/shakapacker != bundle exec shakapacker ($V_SHAKA_BIN vs $V_SHAKA_BUNDLE)"

echo "== shakapacker-dev-server entrypoints =="
cd /home/decidim
SHAKA_DS_CMD="$(command -v shakapacker-dev-server || true)"
test -n "$SHAKA_DS_CMD" || fail "shakapacker-dev-server not on PATH"
test -x bin/shakapacker-dev-server || fail "bin/shakapacker-dev-server missing"
V_SHAKA_DS="$(shakapacker-dev-server -v)"
V_SHAKA_DS_BIN="$(bin/shakapacker-dev-server -v)"
V_SHAKA_DS_BUNDLE="$(bundle exec shakapacker-dev-server -v)"
echo "shakapacker-dev-server:        $V_SHAKA_DS ($SHAKA_DS_CMD)"
echo "bin/shakapacker-dev-server:    $V_SHAKA_DS_BIN"
echo "bundle exec:                   $V_SHAKA_DS_BUNDLE"
test "$V_SHAKA_DS" = "$V_SHAKA_DS_BIN" || fail "shakapacker-dev-server != bin/shakapacker-dev-server ($V_SHAKA_DS vs $V_SHAKA_DS_BIN)"
test "$V_SHAKA_DS_BIN" = "$V_SHAKA_DS_BUNDLE" || fail "bin/shakapacker-dev-server != bundle exec shakapacker-dev-server ($V_SHAKA_DS_BIN vs $V_SHAKA_DS_BUNDLE)"

echo "SMOKE OK"
EOS
