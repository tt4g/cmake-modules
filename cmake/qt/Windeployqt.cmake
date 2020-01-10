cmake_minimum_required(VERSION 3.4.0)

#[=============================================================================[.rst

Windeployqt
-----------

execute_windeployqt
^^^^^^^^^^^^^^^^^^^

.. command:: execute_windeployqt

  execute_windeployqt(
    TARGET <target>
    [NAME windeployqt_target_name]
    [FILES windeployqt_files_arguments]
    [EXECUTABLE_PATH path_to_windeployqt]
    [WORKING_DIRECTORY dir]
    [DEPENDS [depends...]]
    [OPTION_DIR dir]
    [OPTION_LIBDIR path]
    [OPTION_PLUGINDIR path]
    [OPTION_DEBUG]
    [OPTION_RELEASE]
    [OPTION_PDB]
    [OPTION_FORCE]
    [OPTION_DRY_RUN]
    [OPTION_NO_PATCHQT]
    [OPTION_NO_PLUGINS]
    [OPTION_NO_LIBRARIES]
    [OPTION_QMLDIR dir]
    [OPTION_NO_QUICK_IMPORT]
    [OPTION_NO_TRANSLATIONS]
    [OPTION_NO_SYSTEM_D3D_COMPILER]
    [OPTION_COMPILER_RUNTIME]
    [OPTION_NO_COMPILER_RUNTIME]
    [OPTION_WEBKIT2]
    [OPTION_NO_WEBKIT2]
    [OPTION_JSON]
    [OPTION_ANGLE]
    [OPTION_NO_ANGLE]
    [OPTION_NO_OPENGL_SW]
    [OPTION_LIST option]
    [OPTION_VERBOSE level]
    [ADD_QT_LIBRARY_NAMES qt_library_name [qt_library_name2 ...] ]
    [REMOVE_QT_LIBRARY_NAMES qt_library_name [qt_library_name2 ...] ]
  )

Run ``windeployqt`` command.

See `Qt for Windows - Deployment <http://doc.qt.io/qt-5/windows-deployment.html>`_

do nothing if ``WIN32`` is falsy.

OPTIONS
"""""""

``TARGET``
  CMake ``add_executable`` target.
  Execute ``windeployqt`` depends on it.

``NAME``
  windeploqt target name.
  Default ``${TARGET}_windeployqt``.

``FILES``
  ``windeployqt`` arguments ``files``.
  Default ``$<TARGET_FILE:target>``.

``EXECUTABLE_PATH``
  Path to ``windeployqt``.
  If not defined ``EXECUTABLE_PATH``, search under ``$ENV{QTDIR}/bin``.

``WORKING_DIRECTORY``
  Execute the command with the given current working directory.

``DEPENDS``
  dependencies for ``NAME``.

``OPTION_DIR``
  Add ``--dir`` option to ``windeployqt``.

``OPTION_LIBDIR``
  Add ``--libdir <path>`` option to ``windeployqt``.

``OPTION_PLUGINDIR``
  Add ``--plugindir <path>`` option to ``windeployqt``.

``OPTION_DEBUG``
  Add ``--debug`` option to ``windeployqt``.
  Support CMake generator-expressions conditional variable ``OPTION_DEBUG_<CONFIG>``,
  ``OPTION_DEBUG_<CONFIG>`` works if ``$<CONFIG:<CONFIG>`` is truthy.
  ``OPTION_DEBUG`` take precedence over ``OPTION_DEBUG_<CONFIG>``.

``OPTION_RELEASE``
  Add ``--release`` option to ``windeployqt``.
  Support CMake generator-expressions conditional variable ``OPTION_RELEASE_<CONFIG>``,
  ``OPTION_RELEASE_<CONFIG>`` works if ``$<CONFIG:<CONFIG>`` is truthy.
  ``OPTION_RELEASE`` take precedence over ``OPTION_RELEASE_<CONFIG>``.

``OPTION_PDB``
  Add ``--pdb`` option to ``windeployqt``.
  Support CMake generator-expressions conditional variable ``OPTION_PDB_<CONFIG>``,
  ``OPTION_PDB_<CONFIG>`` works if ``$<CONFIG:<CONFIG>`` is truthy.
  ``OPTION_PDB`` take precedence over ``OPTION_PDB_<CONFIG>``.

``OPTION_FORCE``
  Add ``--force`` option to ``windeployqt``.

``OPTION_DRY_RUN``
  Add ``--dry-run`` option to ``windeployqt``.

``OPTION_NO_PATCHQT``
  Add ``--no-patchqt`` option to ``windeployqt``.

``OPTION_NO_PLUGINS``
  Add ``--no-plugins`` option to ``windeployqt``.

``OPTION_NO_LIBRARIES``
  Add ``--no-libraries`` option to ``windeployqt``.

``OPTION_QMLDIR``
  Add ``--qmldir <directory>`` option to ``windeployqt``.

``OPTION_NO_QUICK_IMPORT``
  Add ``--no-quick-import`` option to ``windeployqt``.

``OPTION_NO_TRANSLATIONS``
  Add ``--no-translations`` option to ``windeployqt``.

``OPTION_NO_SYSTEM_D3D_COMPILER``
  Add ``--no-system-d3d-compiler`` option to ``windeployqt``.

``OPTION_COMPILER_RUNTIME``
  Add ``--compiler-runtime`` option to ``windeployqt``.

``OPTION_NO_COMPILER_RUNTIME``
  Add ``--no-compiler-runtime`` option to ``windeployqt``.

``OPTION_WEBKIT2``
  Add ``--webkit2`` option to ``windeployqt``.

``OPTION_NO_WEBKIT2``
  Add ``--no-webkit2`` option to ``windeployqt``.

``OPTION_JSON``
  Add ``--json`` option to ``windeployqt``.

``OPTION_ANGLE``
  Add ``--angle`` option to ``windeployqt``.

``OPTION_NO_ANGLE``
  Add ``--no-angle`` option to ``windeployqt``.

``OPTION_NO_OPENGL_SW``
  Add ``--no-opengl-sw`` option to ``windeployqt``.

``OPTION_LIST``
  Add ``--list <option>`` option to ``windeployqt``.

``OPTION_VERBOSE``
  Add ``--verbose <level>`` option to ``windeployqt``.

``ADD_QT_LIBRARY_NAMES``
  List of Qt library name.
  Add ``--<qt-library-name>`` option to ``windeployqt``.

``REMOVE_QT_LIBRARY_NAMES``
  List of Qt library name.
  Add ``--no-<qt-library-name>`` option to ``windeployqt``.

Example
"""""""

.. code-block:: cmake

  add_executable(foo ...)
  execute_windeployqt(
    NAME foo_windeployqt
    TARGET foo
    FILES "$<TARGET_FILE:foo>"
    WORKING_DIRECTORY "$<TARGET_FILE_DIR:foo>")

Always clean artifacts
""""""""""""""""""""""

``windeployqt`` is not clean dependency files.
If you want to always clean artifacts in directory,
add clean and collect artifacts target using ``add_custom_target``.

.. code-block:: cmake

  # Arrifacts output direcotry.
  set(ARTIFACTS_DIR "${CMAKE_BINARY_DIR}/artifacts")

  # Add executable target.
  add_executable(foo ...)

  # Add clean target.
  add_custom_target(clean_artifacts_dir
    COMMAND "${CMAKE_COMMAND}" -E remove_directory "${ARTIFACTS_DIR}"
    COMMAND "${CMAKE_COMMAND}" -E make_directory "${ARTIFACTS_DIR}"
    VERBATIM)

  # Add collect artifacts target.
  # this target always build.
  add_custom_target(collect_artifacts ALL
    COMMAND "${CMAKE_COMMAND}" -E copy "$<TARGET_FILE:foo>" "${ARTIFACTS_DIR}"
    VERBATIM)

  # Run 'clean_artifacts_dir' before 'collect_artifacts'.
  add_dependencies(collect_artifacts clean_artifacts_dir)

  include(Windeployqt)
  execute_windeployqt(
    NAME foo_windeployqt
    TARGET foo
    FILES "$<TARGET_FILE:foo>"
    WORKING_DIRECTORY "${ARTIFACTS_DIR}"
    DEPENDS foo
    OPTION_DEBUG_Debug
    OPTION_PDB_Debug
    OPTION_RELEASE_Release
    OPTION_DIR "${ARTIFACTS_DIR}"
    OPTION_COMPILER_RUNTIME)

  # Define target foo_windeployqt if build target windows.
  if (TARGET foo_windeployqt)
    add_dependencies(collect_artifacts foo_windeployqt)
  endif()

]=============================================================================]

include("${CMAKE_CURRENT_LIST_DIR}/../DetectCmakeConfigurationCandidates.cmake")

function(execute_windeployqt)
  if(NOT WIN32)
    return()
  endif()

  set(options
    OPTION_DEBUG
    OPTION_RELEASE
    OPTION_PDB
    OPTION_FORCE
    OPTION_DRY_RUN
    OPTION_NO_PATCHQT
    OPTION_NO_PLUGINS
    OPTION_NO_LIBRARIES
    OPTION_NO_QUICK_IMPORT
    OPTION_NO_TRANSLATIONS
    OPTION_NO_SYSTEM_D3D_COMPILER
    OPTION_COMPILER_RUNTIME
    OPTION_NO_COMPILER_RUNTIME
    OPTION_WEBKIT2
    OPTION_NO_WEBKIT2
    OPTION_JSON
    OPTION_ANGLE
    OPTION_NO_ANGLE
    OPTION_NO_OPENGL_SW)
  set(oneValueArgs
    TARGET
    NAME
    FILES
    EXECUTABLE_PATH
    WORKING_DIRECTORY
    OPTION_DIR
    OPTION_LIBDIR
    OPTION_PLUGINDIR
    OPTION_QMLDIR
    OPTION_LIST
    OPTION_VERBOSE)
  set(multiValueArgs
    DEPENDS
    ADD_QT_LIBRARY_NAMES
    REMOVE_QT_LIBRARY_NAMES)

  detect_cmake_configuration_candidates(ExecuteWindeployqt_CONFIG_NAMES_)
  foreach(ExecuteWindeployqt_CONFIG_NAME_ IN LISTS ExecuteWindeployqt_CONFIG_NAMES_)
    # Add options: OPTION_DEBUG_<CONFIG>, OPTION_RELEASE_<CONFIG>, OPTION_PDB_<CONFIG>
    list(APPEND options
      "OPTION_DEBUG_${ExecuteWindeployqt_CONFIG_NAME_}"
      "OPTION_RELEASE_${ExecuteWindeployqt_CONFIG_NAME_}"
      "OPTION_PDB_${ExecuteWindeployqt_CONFIG_NAME_}")
  endforeach()

  cmake_parse_arguments(
    ExecuteWindeployqtArgs
    "${options}"
    "${oneValueArgs}"
    "${multiValueArgs}"
    ${ARGN})

  if((DEFINED ExecuteWindeployqtArgs_EXECUTABLE_PATH)
    AND EXISTS "${ExecuteWindeployqtArgs_EXECUTABLE_PATH}")

    set(RUN_WINDEPLOYQT_EXECUTABLE "${ExecuteWindeployqtArgs_EXECUTABLE_PATH}")
  else()

    if(DEFINED ENV{QTDIR})
      set(WINDEPLOYQT_DIR_CANDIDATE "$ENV{QTDIR}/bin")
    endif()

  endif()

  find_program(RUN_WINDEPLOYQT_EXECUTABLE windeployqt
    PATHS "${WINDEPLOYQT_DIR_CANDIDATE}"
    DOC "`run_windeployqt` use windeployqt")

  if(NOT RUN_WINDEPLOYQT_EXECUTABLE)
    message(FATAL_ERROR "windeployqt command not found!")
  endif()

  if(NOT TARGET ${ExecuteWindeployqtArgs_TARGET})
    message(FATAL_ERROR
      "TARGET is not CMake target. ${ExecuteWindeployqtArgs_TARGET}")
  endif()

  if(NOT DEFINED ExecuteWindeployqtArgs_NAME)
    set(ExecuteWindeployqtArgs_NAME
      "${ExecuteWindeployqtArgs_TARGET}_windeployqt")
  endif()

  if(NOT DEFINED ExecuteWindeployqtArgs_FILES)
    set(ExecuteWindeployqtArgs_FILES
      "$<TARGET_FILE:${ExecuteWindeployqtArgs_TARGET}>")
  endif()

  if(NOT DEFINED ExecuteWindeployqtArgs_WORKING_DIRECTORY)
    set(ExecuteWindeployqtArgs_WORKING_DIRECTORY
      "$<TARGET_FILE_DIR:${ExecuteWindeployqtArgs_TARGET}>")
  endif()

  # windeployqt options
  set(WINDEPLOYQT_OPTIONS)

  if(DEFINED ExecuteWindeployqtArgs_OPTION_DIR)
    list(APPEND WINDEPLOYQT_OPTIONS
      "--dir" "${ExecuteWindeployqtArgs_OPTION_DIR}")
  endif()

  if(DEFINED ExecuteWindeployqtArgs_OPTION_LIBDIR)
    list(APPEND WINDEPLOYQT_OPTIONS
      "--libdir" "${ExecuteWindeployqtArgs_OPTION_LIBDIR}")
  endif()

  if(DEFINED ExecuteWindeployqtArgs_OPTION_PLUGINDIR)
    list(APPEND WINDEPLOYQT_OPTIONS
      "--plugindir" "${ExecuteWindeployqtArgs_OPTION_PLUGINDIR}")
  endif()

  foreach(ExecuteWindeployqt_CONFIG_NAME_ IN LISTS ExecuteWindeployqt_CONFIG_NAMES_)
    list(APPEND WINDEPLOYQT_OPTIONS
      # --debug if OPTION_DEBUG OR (<CONFIG> AND OPTION_DEBUG_<CONFIG>)
      "$<$<OR:$<BOOL:${ExecuteWindeployqtArgs_OPTION_DEBUG}>,$<AND:$<CONFIG:${ExecuteWindeployqt_CONFIG_NAME_}>,$<BOOL:${ExecuteWindeployqtArgs_OPTION_DEBUG_${ExecuteWindeployqt_CONFIG_NAME_}}>>>:--debug>"
      # --release if OPTION_RELEASE OR (<CONFIG> AND OPTION_RELEASE_<CONFIG>)
      "$<$<OR:$<BOOL:${ExecuteWindeployqtArgs_OPTION_RELEASE}>,$<AND:$<CONFIG:${ExecuteWindeployqt_CONFIG_NAME_}>,$<BOOL:${ExecuteWindeployqtArgs_OPTION_RELEASE_${ExecuteWindeployqt_CONFIG_NAME_}}>>>:--release>"
      # --pdb if OPTION_PDB OR (<CONFIG> AND OPTION_PDB_<CONFIG>)
      "$<$<OR:$<BOOL:${ExecuteWindeployqtArgs_OPTION_PDB}>,$<AND:$<CONFIG:${ExecuteWindeployqt_CONFIG_NAME_}>,$<BOOL:${ExecuteWindeployqtArgs_OPTION_PDB_${ExecuteWindeployqt_CONFIG_NAME_}}>>>:--pdb>"
    )
  endforeach()

  if(ExecuteWindeployqtArgs_OPTION_FORCE)
    list(APPEND WINDEPLOYQT_OPTIONS "--force")
  endif()

  if(ExecuteWindeployqtArgs_OPTION_DRY_RUN)
    list(APPEND WINDEPLOYQT_OPTIONS "--dry-run")
  endif()

  if(ExecuteWindeployqtArgs_OPTION_NO_PATCHQT)
    list(APPEND WINDEPLOYQT_OPTIONS "--no-patchqt")
  endif()

  if(ExecuteWindeployqtArgs_OPTION_NO_PLUGINS)
    list(APPEND WINDEPLOYQT_OPTIONS "--no-plugins")
  endif()

  if(ExecuteWindeployqtArgs_OPTION_NO_LIBRARIES)
    list(APPEND WINDEPLOYQT_OPTIONS "--no-libraries")
  endif()

  if(DEFINED ExecuteWindeployqtArgs_OPTION_QMLDIR)
    list(APPEND WINDEPLOYQT_OPTIONS
      "--qmldir" "${ExecuteWindeployqtArgs_OPTION_QMLDIR}")
  endif()

  if(ExecuteWindeployqtArgs_OPTION_NO_QUICK_IMPORT)
    list(APPEND WINDEPLOYQT_OPTIONS "--no-quick-import")
  endif()

  if(ExecuteWindeployqtArgs_OPTION_NO_TRANSLATIONS)
    list(APPEND WINDEPLOYQT_OPTIONS "--no-translations")
  endif()

  if(ExecuteWindeployqtArgs_OPTION_NO_SYSTEM_D3D_COMPILER)
    list(APPEND WINDEPLOYQT_OPTIONS "--no-system-d3d-compiler")
  endif()

  if(ExecuteWindeployqtArgs_OPTION_COMPILER_RUNTIME)
    list(APPEND WINDEPLOYQT_OPTIONS "--compiler-runtime")
  endif()

  if(ExecuteWindeployqtArgs_OPTION_NO_COMPILER_RUNTIME)
    list(APPEND WINDEPLOYQT_OPTIONS "--no-compiler-runtime")
  endif()

  if(ExecuteWindeployqtArgs_OPTION_WEBKIT2)
    list(APPEND WINDEPLOYQT_OPTIONS "--webkit2")
  endif()

  if(ExecuteWindeployqtArgs_OPTION_NO_WEBKIT2)
    list(APPEND WINDEPLOYQT_OPTIONS "--no-webkit2")
  endif()

  if(ExecuteWindeployqtArgs_OPTION_JSON)
    list(APPEND WINDEPLOYQT_OPTIONS "--json")
  endif()

  if(ExecuteWindeployqtArgs_OPTION_ANGLE)
    list(APPEND WINDEPLOYQT_OPTIONS "--angle")
  endif()

  if(ExecuteWindeployqtArgs_OPTION_NO_ANGLE)
    list(APPEND WINDEPLOYQT_OPTIONS "--no-angle")
  endif()

  if(ExecuteWindeployqtArgs_OPTION_NO_OPENGL_SW)
    list(APPEND WINDEPLOYQT_OPTIONS "--no-opengl-sw")
  endif()

  if(DEFINED ExecuteWindeployqtArgs_OPTION_LIST)
    list(APPEND WINDEPLOYQT_OPTIONS
      "--list" "${ExecuteWindeployqtArgs_OPTION_LIST}")
  endif()

  if(DEFINED ExecuteWindeployqtArgs_OPTION_VERBOSE)
    list(APPEND WINDEPLOYQT_OPTIONS
      "--verbose" "${ExecuteWindeployqtArgs_OPTION_VERBOSE}")
  endif()

  foreach(ADD_QT_LIBRARY_NAME IN LISTS ExecuteWindeployqtArgs_ADD_QT_LIBRARY_NAMES)

    string(TOLOWER "${ADD_QT_LIBRARY_NAME}" ADD_QT_LIBRARY_NAME)
    list(APPEND WINDEPLOYQT_OPTIONS "--${ADD_QT_LIBRARY_NAME}")
  endforeach()

  foreach(REMOVE_QT_LIBRARY_NAME IN LISTS ExecuteWindeployqtArgs_REMOVE_QT_LIBRARY_NAMES)

    string(TOLOWER "${REMOVE_QT_LIBRARY_NAME}" REMOVE_QT_LIBRARY_NAME)
    list(APPEND WINDEPLOYQT_OPTIONS "--no-${REMOVE_QT_LIBRARY_NAME}")
  endforeach()

  add_custom_target(${ExecuteWindeployqtArgs_NAME}
    COMMAND "${RUN_WINDEPLOYQT_EXECUTABLE}" "${WINDEPLOYQT_OPTIONS}" "${ExecuteWindeployqtArgs_FILES}"
    WORKING_DIRECTORY "${ExecuteWindeployqtArgs_WORKING_DIRECTORY}"
    DEPENDS ${ExecuteWindeployqtArgs_DEPENDS}
    COMMAND_EXPAND_LISTS
    VERBATIM)

endfunction()
