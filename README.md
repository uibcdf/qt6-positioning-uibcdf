# qt6-positioning-uibcdf

Experimental UIBCDF conda packaging repo for the Qt `Positioning` layer needed
by the provisional standalone Qt-for-Python family.

Current development candidate:

- Qt runtime line: `6.10.1`
- target platform: Linux
- target Python family using it: Python `3.14` (candidate, not published)

This repo exists because:

- `pyside6-addons-uibcdf` needs `Qt6Positioning`
- `qt6-main 6.10.1` from conda-forge does not provide it
- `qt6-main 6.10.1` does provide `Qt6WebChannel`, so this repo is
  intentionally narrower than a generic "Qt extra modules" bundle

This is the small Qt-side precursor to a later `qt6-webengine-uibcdf` line.
Its payload is native Qt code, so the candidate recipe does not impose a
Python runtime or ABI dependency. A Python 3.14 package test checks native
loading. A Linux x86-64 build and a separate clean Python 3.14.7 Conda
installation passed locally on 23 September 2026. The complete five-package
Qt host is not yet supported or released.

Track the candidate and its remaining release gates in
[`uibcdf/qt6-positioning-uibcdf#1`](https://github.com/uibcdf/qt6-positioning-uibcdf/issues/1).
