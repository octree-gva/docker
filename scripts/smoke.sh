#!/usr/bin/env bash
set -euo pipefail

IMAGE="${1:?image reference required}"

docker run --rm --entrypoint bash "$IMAGE" -lc '
  bundle check
  ruby -v
  test -d public/decidim-packs || test -d public/assets
'
