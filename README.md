# ocp-virt-validation-checkup-python-deps

Pre-built Python dependencies for ocp-virt-validation-checkup hermetic builds.

## Purpose

The [ocp-virt-validation-checkup](https://github.com/openshift-cnv/ocp-virt-validation-checkup)
Konflux build requires Python dependencies from
[openshift-virtualization-tests](https://github.com/RedHatQE/openshift-virtualization-tests).
Building those dependencies hermetically (from source, offline) is extremely
fragile due to 160+ packages with conflicting build backends, Rust extensions,
and wheel-only distributions.

This repo solves the problem by building the dependencies **non-hermetically**
in a separate Konflux component. The resulting image contains a fully-installed
`.venv` with all Python deps, which the main hermetic build consumes via
`COPY --from`.

## How it works

1. A GitHub Actions workflow polls `openshift-virtualization-tests` (branch
   `cnv-4.22`) every 30 minutes for new commits
2. When a change is detected, the submodule is bumped and pushed
3. Konflux rebuilds the deps image using `uv sync --locked`
4. Component nudging updates the main midstream repo with the new image digest

## Manual sync

```bash
git submodule update --remote upstream/openshift-virtualization-tests
git add -A && git commit -m "Bump upstream" && git push
```
