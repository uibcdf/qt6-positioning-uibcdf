#!/usr/bin/env bash
set -euo pipefail

# The recipe checks out the exact upstream commit into SRC_DIR. Build against
# conda-forge's Qt base so private Qt symbols match the runtime dependency.
cmake -S "$SRC_DIR" -B "$SRC_DIR/build-conda" -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX="$PREFIX" \
    -DCMAKE_PREFIX_PATH="$PREFIX" \
    -DQT_BUILD_TESTS=OFF \
    -DQT_BUILD_EXAMPLES=OFF \
    -DBUILD_TESTING=OFF

# PositioningQuick is optional upstream but mandatory for our Addons runtime.
# A missing Qt Quick/OpenGL build dependency must fail here, not produce a
# seemingly valid package that fails only when MolSysViewer loads QML.
if ! cmake --build "$SRC_DIR/build-conda" --target help | grep -q '^PositioningQuick:'; then
    echo 'Qt PositioningQuick target was not configured' >&2
    exit 1
fi

cmake --build "$SRC_DIR/build-conda" --parallel "${CPU_COUNT:-2}"
cmake --install "$SRC_DIR/build-conda"
