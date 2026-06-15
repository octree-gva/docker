#!/usr/bin/env bash
set -euo pipefail

IMAGE="${1:?image reference required}"

docker run --rm --entrypoint bash "$IMAGE" -lc '
  bundle exec rails runner "puts :ok"
  test -d public/decidim-packs || test -d public/assets
'
