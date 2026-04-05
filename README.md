# qt6-positioning-uibcdf

Experimental UIBCDF conda packaging repo for the Qt `Positioning` layer needed
by the provisional standalone Qt-for-Python family.

Current line:

- Qt runtime line: `6.9.2`
- target platform: Linux
- target Python family using it: Python `3.13`

This repo exists because:

- `pyside6-addons-uibcdf 6.9.2` needs `Qt6Positioning`
- `qt6-main 6.9.2` from conda-forge does not provide it
- `qt6-main 6.9.2` does already provide `Qt6WebChannel`, so this repo is
  intentionally narrower than a generic "Qt extra modules" bundle

This is the small Qt-side precursor to a later `qt6-webengine-uibcdf` line.
