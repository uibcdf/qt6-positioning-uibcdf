# Bootstrap 6.9.2

## Scope

This repo tracks the first Linux / Python 3.13 experimental UIBCDF line for
the Qt `Positioning` runtime layer needed by:

- `pyside6-addons-uibcdf 6.9.2`

## Why This Repo Exists

`pyside6-addons-uibcdf` source-builds correctly far enough to prove that the
remaining blocker is not `_uibcdf` namespace work, but missing Qt runtime
components in conda.

The active findings are:

- `qt6-main 6.9.2` from conda-forge does not expose `Qt6Positioning`
- `qt6-main 6.9.2` does expose `Qt6WebChannel`
- `QtPositioning` is small enough to package independently before tackling the
  much larger `QtWebEngine` layer

## Runtime Reference

The working runtime reference is:

- `/home/diego/Myopt/miniconda3/envs/molsyssuite-qt-spike`

The minimum visible `QtPositioning` payload there is:

- `PySide6/Qt/lib/libQt6Positioning.so.6`
- `PySide6/Qt/lib/libQt6PositioningQuick.so.6`
- `PySide6/Qt/qml/QtPositioning/`

## Current Reading

`QtPositioning` looks like a good first Qt-side package because:

- it is small
- it appears to depend mainly on `Qt6Core` plus ICU from the bundled runtime
- it should unblock `pyside6-addons-uibcdf` before the much larger
  `QtWebEngine` slice

## Immediate Goal

Produce a first experimental local conda package for:

- `qt6-positioning-uibcdf 6.9.2`

Then test whether `pyside6-addons-uibcdf` gets past the current
`Qt6Positioning` configure blocker when that package is installed in the host
build env.

## Build Result (2026-03-31)

First `conda build` attempt succeeded on 2026-03-31.

- Output: `qt6-positioning-uibcdf-6.9.2-py313_0.conda` (321 KB)
- Location: `conda-bld/linux-64/`
- Build time: ~3:46
- All tests passed:
  - `libQt6Positioning.so.6` present
  - `libQt6PositioningQuick.so.6` present
  - `QtPositioning/libpositioningquickplugin.so` present
  - headers installed under `include/qt6/QtPositioning/`
  - cmake config installed under `lib/cmake/Qt6Positioning/`

This package is now available as a local dependency for `pyside6-addons-uibcdf`
and `qt6-webengine-uibcdf` via `--use-local` or the local conda-bld channel.
