get_filename_component(PACKAGE_PREFIX_DIR "${CMAKE_CURRENT_LIST_DIR}/../../../" ABSOLUTE)

include(CMakeFindDependencyMacro)

if(NOT Qt6_FOUND)
    find_dependency(Qt6 6.9.2)
endif()

find_dependency(Qt6Core 6.9.2)

if(NOT DEFINED Qt6Positioning_FOUND)
    set(Qt6Positioning_FOUND TRUE)
endif()

if(NOT QT_NO_CREATE_TARGETS AND Qt6Positioning_FOUND)
    include("${CMAKE_CURRENT_LIST_DIR}/Qt6PositioningTargets.cmake")
endif()

if(TARGET Qt6::Positioning)
    set(Qt6Positioning_LIBRARIES "Qt6::Positioning")
    set(Qt6Positioning_INCLUDE_DIRS
        "${PACKAGE_PREFIX_DIR}/include/qt6/QtPositioning"
        "${PACKAGE_PREFIX_DIR}/include/qt6")
    if(TARGET Qt6::PositioningPrivate)
        get_target_property(Qt6Positioning_PRIVATE_INCLUDE_DIRS
                            Qt6::PositioningPrivate
                            INTERFACE_INCLUDE_DIRECTORIES)
    endif()
    set(_Qt6Positioning_MODULE_DEPENDENCIES "Core")
endif()
