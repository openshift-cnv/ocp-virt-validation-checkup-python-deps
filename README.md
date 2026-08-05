# ocp-virt-validation-checkup-python-deps

Pre-downloaded Python dependencies for ocp-virt-validation-checkup hermetic builds.

## Purpose

The [ocp-virt-validation-checkup](https://github.com/openshift-cnv/ocp-virt-validation-checkup)
Konflux build requires Python dependencies from
[openshift-virtualization-tests](https://github.com/RedHatQE/openshift-virtualization-tests).

This repo stores the downloaded wheel and sdist files so the hermetic
build can install them offline via `pip install --find-links` without
needing Hermeto pip prefetching.

## How it works

1. A GitHub Actions workflow polls `openshift-virtualization-tests` every
   30 minutes for new commits
2. When a change is detected, it exports `requirements.txt` from `uv.lock`
   and downloads all packages (wheels + sdists for all target architectures)
3. The files are committed to the `deps/` directory
4. The midstream repo references this repo as a git submodule
5. The hermetic Dockerfile uses `pip install --find-links` on the local files

## Branch mapping

| This repo | Upstream branch |
|-----------|----------------|
| `release-4.22` | `cnv-4.22` |
| `main` | `main` |

## Contents

- `upstream/openshift-virtualization-tests` -- submodule tracking upstream
- `requirements.txt` -- exported from `uv.lock`, fully resolved with hashes
- `deps/` -- downloaded wheels and sdists for x86_64, aarch64, s390x

## Manual sync

```bash
git submodule update --remote upstream/openshift-virtualization-tests
cd upstream/openshift-virtualization-tests
uv export --format requirements.txt --frozen --no-dev --output-file ../../requirements.txt
cd ../..
pip download -r requirements.txt --dest deps/ --no-deps --prefer-binary
git add -A && git commit -m "Sync deps" && git push
```
