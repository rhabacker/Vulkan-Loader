#
# create and install cmake support files
#
# available arguments:
#
#    CONFIG_TEMPLATE <file>   cmake template file for generating <prefix>Config.cmake file
#    [PREFIX <prefix>]        prefix for generating file names (optional)
#                             If not specified, ${PROJECT_NAME} is used
#    [VERSION <version>]      version used for <prefix>ConfigVersion.cmake (optional)
#                             If not specified, ${PROJECT_VERSION} is used
#    [NO_EXPORT]
#
# The files maintained by this macro are
#
#    <prefix>Config.cmake
#    <prefix>ConfigVersion.cmake
#    <prefix>Targets*.cmake
#
macro(vulkan_add_cmake_support_files)
    set(options NO_EXPORT)
    set(oneValueArgs CONFIG_TEMPLATE PREFIX VERSION)
    set(multiValueArgs)
    cmake_parse_arguments(ARGS "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    if(NOT ARGS_PREFIX)
        set(ARGS_PREFIX ${PROJECT_NAME})
    endif()
    if(NOT ARGS_VERSION)
        set(ARGS_VERSION ${PROJECT_VERSION})
    endif()
    set(CONFIG_FILE ${CMAKE_BINARY_DIR}/${ARGS_PREFIX}Config.cmake)
    set(CONFIG_VERSION_FILE ${CMAKE_BINARY_DIR}/${ARGS_PREFIX}ConfigVersion.cmake)

    if(NOT ARGS_CONFIG_TEMPLATE)
        message(FATAL_ERROR "no template for generating <prefix>Config.cmake provided - use argument CONFIG_TEMPLATE <file>")
    endif()
    configure_file(${ARGS_CONFIG_TEMPLATE} ${CONFIG_FILE} @ONLY)

    if(NOT ARGS_NO_EXPORT)
        install(EXPORT ${ARGS_PREFIX}Targets
            FILE ${ARGS_PREFIX}Targets.cmake
            NAMESPACE ${ARGS_PREFIX}::
            DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${ARGS_PREFIX}
        )
    endif()

    include(CMakePackageConfigHelpers)
    write_basic_package_version_file(
        ${CONFIG_VERSION_FILE}
        COMPATIBILITY SameMajorVersion
        VERSION ${ARGS_VERSION}
    )

    install(
        FILES
            ${CONFIG_FILE}
            ${CONFIG_VERSION_FILE}
        DESTINATION
            ${CMAKE_INSTALL_LIBDIR}/cmake/${ARGS_PREFIX}
    )
endmacro()

#
# add feature summary
#
macro(vulkan_add_feature_summary)
    include(FeatureSummary)
    feature_summary(WHAT ALL)
endmacro()
