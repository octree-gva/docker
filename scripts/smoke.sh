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
test -n "$(find public/decidim-packs -type f -print -quit)" || fail "public/decidim-packs is empty"

echo "== jemalloc / bootsnap / fast boot =="
echo "${LD_PRELOAD:-}" | grep -q jemalloc || fail "LD_PRELOAD is not jemalloc"
test -e /usr/lib/libjemalloc.so.2 || fail "libjemalloc.so.2 missing"
test -d tmp/cache/bootsnap || fail "bootsnap cache missing"
test -x bin/check || fail "bin/check missing"
test ! -e docker-entrypoint.d/35_bundle_check || fail "bundle check still runs at boot"
test ! -e docker-entrypoint.d/36_db_check || fail "db migrate still runs at boot"
grep -q 'VIPS_CONCURRENCY' config/boot.rb || fail "boot.rb does not set VIPS_CONCURRENCY"

echo "== libvips present =="
command -v vips >/dev/null || fail "vips not on PATH"
vips --version

echo "== libvips without gif libraries =="
packages=""
if command -v dpkg >/dev/null 2>&1; then
  packages="$(dpkg -l || true)"
elif command -v rpm >/dev/null 2>&1; then
  packages="$(rpm -qa || true)"
fi
if echo "$packages" | grep -Eiq 'libgif|giflib|libcgif|libnsgif'; then
  fail "gif library package installed"
fi

echo "== libvips codecs (mozjpeg/libjpeg, libexif, libtiff, libpng/spng, libwebp) =="
CFG="$(vips --vips-config)"
echo "$CFG" | grep -q "EXIF metadata support with libexif: true" || fail "libexif not enabled in vips"
echo "$CFG" | grep -q "JPEG load/save with libjpeg: true" || fail "libjpeg/mozjpeg not enabled in vips"
echo "$CFG" | grep -E -q "PNG load/save with lib(png|spng): true" || fail "libpng/libspng not enabled in vips"
echo "$CFG" | grep -E -q "TIFF load/save with libtiff(-4)?: true" || fail "libtiff not enabled in vips"
echo "$CFG" | grep -q "WebP load/save with libwebp: true" || fail "libwebp not enabled in vips"
if echo "$CFG" | grep -Ei 'gif|nsgif|cgif' | grep -q ': true'; then
  fail "gif codec is enabled in vips"
fi
libvips="$(find /usr/local/lib /usr/local/lib64 -name 'libvips.so.*' -type f | head -1)"
test -n "$libvips" || fail "libvips shared library missing"
if ldd "$libvips" | grep -Ei 'gif|cgif'; then
  fail "libvips is linked to a gif library"
fi

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

# Shakapacker 7/8 `-v` boots webpack. Production images strip node_modules
# (ENOTCACHED / "webpack not found"). Fall back to the gem version.
gem_shaka_ver() {
  bundle exec ruby -e 'puts Gem.loaded_specs.fetch("shakapacker").version'
}

cli_ver() {
  local out rc
  set +e
  out="$("$@" -v 2>&1)"
  rc=$?
  set -e
  if [ "$rc" -eq 0 ] && [ -n "$out" ] && ! echo "$out" | grep -Eqi 'webpack not found|ENOTCACHED|error Command'; then
    printf '%s\n' "$out" | tail -n 1
    return 0
  fi
  printf 'gem:%s\n' "$(gem_shaka_ver)"
}

echo "== shakapacker entrypoints =="
cd /home/decidim
SHAKA_CMD="$(command -v shakapacker || true)"
test -n "$SHAKA_CMD" || fail "shakapacker not on PATH"
test -x bin/shakapacker || fail "bin/shakapacker missing"
V_SHAKA="$(cli_ver shakapacker)"
V_SHAKA_BIN="$(cli_ver bin/shakapacker)"
V_SHAKA_BUNDLE="$(cli_ver bundle exec shakapacker)"
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
V_SHAKA_DS="$(cli_ver shakapacker-dev-server)"
V_SHAKA_DS_BIN="$(cli_ver bin/shakapacker-dev-server)"
V_SHAKA_DS_BUNDLE="$(cli_ver bundle exec shakapacker-dev-server)"
echo "shakapacker-dev-server:        $V_SHAKA_DS ($SHAKA_DS_CMD)"
echo "bin/shakapacker-dev-server:    $V_SHAKA_DS_BIN"
echo "bundle exec:                   $V_SHAKA_DS_BUNDLE"
test "$V_SHAKA_DS" = "$V_SHAKA_DS_BIN" || fail "shakapacker-dev-server != bin/shakapacker-dev-server ($V_SHAKA_DS vs $V_SHAKA_DS_BIN)"
test "$V_SHAKA_DS_BIN" = "$V_SHAKA_DS_BUNDLE" || fail "bin/shakapacker-dev-server != bundle exec shakapacker-dev-server ($V_SHAKA_DS_BIN vs $V_SHAKA_DS_BUNDLE)"

echo "SMOKE OK"
EOS

echo "== entrypoint =="
vips_for() {
  docker run --rm -e "WEB_CONCURRENCY=$1" "$IMAGE" sh -c 'printf %s "$VIPS_CONCURRENCY"'
}
test "$(vips_for 9)" = "3"
test "$(vips_for 2)" = "1"
test "$(vips_for 1)" = "1"
