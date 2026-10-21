#!/bin/sh
set -e
cd /home/decidim

if [ -z "${VIPS_CONCURRENCY:-}" ]; then
  wc=${WEB_CONCURRENCY:-2}
  case "$wc" in
    ''|*[!0-9]*) wc=2 ;;
  esac
  vips=$((wc / 3))
  if [ "$vips" -lt 1 ]; then
    vips=1
  fi
  export VIPS_CONCURRENCY=$vips
fi

for script in /home/decidim/docker-entrypoint.d/*; do
  [ -x "$script" ] || continue
  "$script"
done

exec "$@"
