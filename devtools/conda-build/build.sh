#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "${RECIPE_DIR}/../.." && pwd)"
SOURCE_QT_PREFIX="${QT6_POSITIONING_UIBCDF_SOURCE_PREFIX:-/home/diego/Myopt/miniconda3/envs/molsyssuite-qt-spike/lib/python3.13/site-packages/PySide6}"
SOURCE_QT_REPO="${QT6_POSITIONING_UIBCDF_SOURCE_REPO:-/home/diego/repos@others/qtpositioning}"
MANIFEST="${QT6_POSITIONING_UIBCDF_MANIFEST:-${REPO_ROOT}/manifests/qt6_positioning.files.txt}"

if [ ! -d "$SOURCE_QT_PREFIX/Qt" ]; then
    echo "Missing source Qt runtime under: $SOURCE_QT_PREFIX" >&2
    exit 1
fi

if [ ! -f "$MANIFEST" ]; then
    echo "Missing manifest: $MANIFEST" >&2
    exit 1
fi

if [ ! -d "$SOURCE_QT_REPO/src/positioning" ]; then
    echo "Missing source Qt Positioning repo under: $SOURCE_QT_REPO" >&2
    exit 1
fi

while IFS= read -r relpath; do
    [ -n "$relpath" ] || continue
    src="$SOURCE_QT_PREFIX/$relpath"
    dst="$PREFIX/${relpath#Qt/}"
    if [ ! -e "$src" ]; then
        echo "Missing manifest entry in source environment: $src" >&2
        exit 1
    fi
    mkdir -p "$(dirname "$dst")"
    cp -a "$src" "$dst"
done < "$MANIFEST"

header_src_dir="$SOURCE_QT_REPO/src/positioning"
header_dst_dir="$PREFIX/include/qt6/QtPositioning"
mkdir -p "$header_dst_dir"
for header in \
    qgeoaddress.h \
    qgeoareamonitorinfo.h \
    qgeoareamonitorsource.h \
    qgeocircle.h \
    qgeocoordinate.h \
    qgeolocation.h \
    qgeopath.h \
    qgeopolygon.h \
    qgeopositioninfo.h \
    qgeopositioninfosource.h \
    qgeopositioninfosourcefactory.h \
    qgeorectangle.h \
    qgeosatelliteinfo.h \
    qgeosatelliteinfosource.h \
    qgeoshape.h \
    qnmeapositioninfosource.h \
    qnmeasatelliteinfosource.h \
    qpositioningglobal.h
do
    src="$header_src_dir/$header"
    if [ ! -f "$src" ]; then
        echo "Missing public header in source repo: $src" >&2
        exit 1
    fi
    cp -a "$src" "$header_dst_dir/$header"
done

cat > "$PREFIX/include/qt6/QtPositioning/qtpositioningexports.h" <<'HDR'
#ifndef QTPOSITIONINGEXPORTS_H
#define QTPOSITIONINGEXPORTS_H

#include <QtCore/qglobal.h>

#ifndef QT_STATIC
#  if defined(QT_BUILD_POSITIONING_LIB)
#    define Q_POSITIONING_EXPORT Q_DECL_EXPORT
#  else
#    define Q_POSITIONING_EXPORT Q_DECL_IMPORT
#  endif
#else
#  define Q_POSITIONING_EXPORT
#endif

#endif
HDR

for alias in \
    QGeoAddress:qgeoaddress.h \
    QGeoAreaMonitorInfo:qgeoareamonitorinfo.h \
    QGeoAreaMonitorSource:qgeoareamonitorsource.h \
    QGeoCircle:qgeocircle.h \
    QGeoCoordinate:qgeocoordinate.h \
    QGeoLocation:qgeolocation.h \
    QGeoPath:qgeopath.h \
    QGeoPolygon:qgeopolygon.h \
    QGeoPositionInfo:qgeopositioninfo.h \
    QGeoPositionInfoSource:qgeopositioninfosource.h \
    QGeoPositionInfoSourceFactory:qgeopositioninfosourcefactory.h \
    QGeoRectangle:qgeorectangle.h \
    QGeoSatelliteInfo:qgeosatelliteinfo.h \
    QGeoSatelliteInfoSource:qgeosatelliteinfosource.h \
    QGeoShape:qgeoshape.h \
    QNmeaPositionInfoSource:qnmeapositioninfosource.h \
    QNmeaSatelliteInfoSource:qnmeasatelliteinfosource.h
    do
    name="${alias%%:*}"
    header="${alias##*:}"
    cat > "$PREFIX/include/qt6/QtPositioning/${name}" <<HDR
#include <QtPositioning/${header}>
HDR
done

cat > "$PREFIX/include/qt6/QtPositioning/QtPositioning" <<'HDR'
#ifndef QTPOSITIONING_MODULE_H
#define QTPOSITIONING_MODULE_H

#include <QtPositioning/qpositioningglobal.h>
#include <QtPositioning/qgeoaddress.h>
#include <QtPositioning/qgeoareamonitorinfo.h>
#include <QtPositioning/qgeoareamonitorsource.h>
#include <QtPositioning/qgeocircle.h>
#include <QtPositioning/qgeocoordinate.h>
#include <QtPositioning/qgeolocation.h>
#include <QtPositioning/qgeopath.h>
#include <QtPositioning/qgeopolygon.h>
#include <QtPositioning/qgeopositioninfo.h>
#include <QtPositioning/qgeopositioninfosource.h>
#include <QtPositioning/qgeopositioninfosourcefactory.h>
#include <QtPositioning/qgeorectangle.h>
#include <QtPositioning/qgeosatelliteinfo.h>
#include <QtPositioning/qgeosatelliteinfosource.h>
#include <QtPositioning/qgeoshape.h>
#include <QtPositioning/qnmeapositioninfosource.h>
#include <QtPositioning/qnmeasatelliteinfosource.h>

#endif
HDR

cmake_dst_dir="$PREFIX/lib/cmake/Qt6Positioning"
mkdir -p "$cmake_dst_dir"
cp -a "$REPO_ROOT/cmake/Qt6PositioningConfig.cmake" "$cmake_dst_dir/"
cp -a "$REPO_ROOT/cmake/Qt6PositioningConfigVersion.cmake" "$cmake_dst_dir/"
cp -a "$REPO_ROOT/cmake/Qt6PositioningTargets.cmake" "$cmake_dst_dir/"
