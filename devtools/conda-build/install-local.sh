#!/usr/bin/env bash
# Build from the exact upstream commit pinned in meta.yaml, then install the
# local artifact into the active Conda environment for development testing.
set -euo pipefail

PKG_NAME="qt6-positioning-uibcdf"
RECIPE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! conda build --version >/dev/null 2>&1; then
    echo "error: conda-build is required." >&2
    exit 1
fi
if [ -z "${CONDA_PREFIX:-}" ]; then
    echo "error: activate the target Conda environment first." >&2
    exit 1
fi

conda build "$RECIPE_DIR" -c local -c conda-forge --no-anaconda-upload
mamba install -y -c local -c conda-forge "$PKG_NAME=6.10.1"
