# Version-specific build dependencies

Overlays are keyed by **Decidim minor version** (`0.29`, `0.31`, …). Only the directory matching the image `DECIDIM_VERSION` is applied — there is no inheritance between minors.

## Layout

```
version-deps/
  0.29/gems.txt
  0.30/gems.txt
  0.31/gems.txt
  0.31/npm.txt
  0.32/gems.txt
  0.32/npm.txt
```

## Files

| File | Applied in Dockerfile stage | Line format |
|------|-----------------------------|-------------|
| `gems.txt` | generator | gem name |
| `npm.txt` | assets | `npm install` arguments |
| `ubuntu.txt` | base (Ubuntu) | apt package name |
| `redhat.txt` | base (Red Hat) | dnf package name |

Lines starting with `#` and blank lines are ignored.

## Add a dependency

1. Find the Decidim minor (e.g. `0.31` for `0.31.1`).
2. Create or edit `version-deps/0.31/<kind>.txt`.
3. If another minor needs the same entry, copy it to that minor’s directory explicitly.

## Native libraries

Shared OS packages stay in the Dockerfiles. Version-only native packages belong in `ubuntu.txt` or `redhat.txt` for the relevant minor.

Baseline Red Hat packages in the Dockerfile include `pkg-config`, `which`, and `file` for gem native extensions.

## Test locally

```bash
DECIDIM_VERSION=0.31.1 VERSION_DEPS_ROOT=./docker/version-deps \
  ./docker/context/bin/apply-version-deps list npm
```
