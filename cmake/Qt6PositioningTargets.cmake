if(TARGET Qt6::Positioning)
    return()
endif()

add_library(Qt6::Positioning SHARED IMPORTED)
set_target_properties(Qt6::Positioning PROPERTIES
    IMPORTED_LOCATION "${PACKAGE_PREFIX_DIR}/lib/libQt6Positioning.so.6"
    IMPORTED_SONAME "libQt6Positioning.so.6"
    INTERFACE_INCLUDE_DIRECTORIES "${PACKAGE_PREFIX_DIR}/include/qt6/QtPositioning;${PACKAGE_PREFIX_DIR}/include/qt6"
    INTERFACE_LINK_LIBRARIES "Qt6::Core"
    INTERFACE_QT_MAJOR_VERSION "6"
    _qt_module_include_name "QtPositioning"
    _qt_module_interface_name "Positioning"
    _qt_package_name "Qt6Positioning"
    _qt_package_version "6.9.2"
)

add_library(Qt6::PositioningPrivate INTERFACE IMPORTED)
set_target_properties(Qt6::PositioningPrivate PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES "${PACKAGE_PREFIX_DIR}/include/qt6/QtPositioning;${PACKAGE_PREFIX_DIR}/include/qt6"
    INTERFACE_LINK_LIBRARIES "Qt6::Positioning"
)
