# Qt Positioning 6.10.1 / Python 3.14 transition

Issue: [`uibcdf/qt6-positioning-uibcdf#1`](https://github.com/uibcdf/qt6-positioning-uibcdf/issues/1).
Status: Linux/Python 3.14 package candidate tested locally; no release or
channel upload.

## Why the 6.9.2 package cannot simply be relabeled

The published 6.9.2 package has an exact Python 3.13 dependency. A current
Conda solve for Python 3.14.7 and `qt6-main=6.9.2` also fails without this
package: available `qt6-main`/`libglib` dependencies need an older `libffi`
than the current Python 3.14.7 build. Removing the Python pin from our old
recipe would not fix that base-stack conflict.

Qt for Python first declares Python 3.14 support in 6.10.1 in its
[official release notes](https://doc.qt.io/qtforpython-6/release_notes/pyside6_release_notes.html).
A Conda dry run confirmed `python=3.14.7 qt6-main=6.10.1` resolves from
conda-forge. The inspected `qt6-main` package does not contain Positioning.

## Candidate inputs and provenance

- Official `qtpositioning` tag `v6.10.1`, commit
  `11d336c178adf4b8d8f7f8589bb9641bcf4b8eda`, is the exact source
  pinned by the Conda recipe. It provides the implementation and headers.
- Official Linux x86-64 PySide6 Addons wheel
  `pyside6_addons-6.10.1-cp39-abi3-manylinux_2_34_x86_64.whl`, SHA-256
  `330c229b58d30083a7b99ed22e118eb4f4126408429816a4044ccd0438ae81b4`,
  was used only for the first repackage experiment. Every entry in the old
  `manifests/qt6_positioning.files.txt` existed and copied successfully.

The repackage experiment produced a Conda artifact but failed the Python 3.14
native-load test: its wheel-built `libQt6Positioning.so.6` requires a private
`QObjectPrivate` symbol that the conda-forge `qt6-main=6.10.1` build does not
provide. Matching version numbers do not establish Qt private-ABI
compatibility. That artifact was **not** published; the candidate now builds
the pinned Qt Positioning source directly against conda-forge's Qt base.

## Candidate recipe contract

The Qt payload contains no Python code or extension. The candidate therefore
has no Python host/run requirement and must not carry `python_abi`. It builds
with CMake/Ninja and the Conda C/C++ toolchain against `qt6-main=6.10.1`,
then depends on **exactly** `qt6-main=6.10.1`: Qt private ABI cannot safely be
assumed compatible even across patch versions. The Conda package test adds Python
3.14 solely to load the native Positioning and PositioningQuick libraries
with `ctypes`. A package that only contains the expected filenames does not
satisfy this gate.

The first source-build trial compiled and packaged `libQt6Positioning.so.6`,
but the test correctly rejected it because `libQt6PositioningQuick.so.6` and
its QML plugin were absent. CMake had not configured the optional upstream
Qt Quick target; its cache also showed missing OpenGL development libraries.
The corrected recipe adds `libgl-devel` and `libegl-devel` to the host
environment and fails immediately if the PositioningQuick target is still
unavailable. The first source artifact remained in Conda's local `broken/`
directory and was not uploaded.

## Verified local evidence, 23 September 2026

The corrected recipe built and passed Conda's package test on Linux x86-64
with Python 3.14.7. It contains both native libraries, the QML plugin at
`lib/qt6/qml/QtPositioning/libpositioningquickplugin.so`, headers, and CMake
metadata. The test loaded both native libraries with `ctypes`. A separate
clean Conda environment installed the artifact from the local channel with
`python=3.14.7` and `qt6-main=6.10.1`, then loaded both libraries **and** the
QML plugin successfully.

Artifact: `qt6-positioning-uibcdf-6.10.1-h3fd9d12_0.conda`, SHA-256
`e441f715afea8f2f38f669a5e2c303e5f1aefbc6213ee3681d542c7939f10089`.
Its `info/git` records upstream tag `v6.10.1` at the pinned commit. Its
`info/index.json` requires `qt6-main 6.10.1.*` and contains neither `python`
nor `python_abi` in the runtime dependencies. This is local candidate evidence,
not published-channel or cross-platform evidence.

The old repackage staging script rejected a 6.9.2 wheel source, but this
guard is now superseded by the exact upstream Git commit in the source-build
recipe. The failed native-load check is retained as a regression gate.

## Remaining gates

1. Test the exact artifact with a matching 6.10.1 WebEngine candidate.
2. Complete Shiboken, Essentials and Addons 6.10.1 candidates and run the
   MolSysViewer Qt pipeline. Keep real display/GPU validation separate.
3. Add CI reproducibility and other target platforms before staging or
   publication; the current build only covers Linux x86-64.
4. Check existing supported Python/Qt paths before any promotion. Neither a
   source import nor this isolated package authorizes a public release.
