#[=======================================================================[.rst:
FindCppWinRT
------------

Find the Microsoft C++/WinRT libraries from Windows SDK.

Override Windows SDK version
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Get the version of Windows SDK from the variable
`CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION`.
If `CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION` is not specified, get from the
variable `CMAKE_SYSTEM_VERSION`.

.. note::

  `CMAKE_SYSTEM_VERSION` must be specified ``cmake -DCMAKE_SYSTEM_VERSION=...``.
  Otherwise, specify this before `project()` is called in `CMakeLists.txt`.

  Set `CMAKE_SYSTEM_VERSION` example:

  .. code-block:: cmake

      # Add a directry path containing FindCppWinRT.cmake
      list(APPEND CMAKE_MODULE_PATH cmake)

      set(TARGET_WINDOWS_SDK_VERSION 10.0.17763.0)

      if(NOT DEFINED CMAKE_SYSTEM_VERSION
        AND ("${CMAKE_SYSTEM_NAME}" STREQUAL "Windows"
          OR "${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "Windows"))

        set(CMAKE_SYSTEM_VERSION ${TARGET_WINDOWS_SDK_VERSION}
          CACHE INTERNAL "" FORCE)
      endif()

      project(example-project)

      find_package(CppWinRT ${TARGET_WINDOWS_SDK_VERSION} EXACT REQUIRED)

IMPORTED targets
^^^^^^^^^^^^^^^^

This module defines the following `IMPORTED` target: ``CppWinRT::CppWinRT``

Result variables
^^^^^^^^^^^^^^^^

This module will set the following variables if found:

``CppWinRT_INCLUDE_DIRS``
  Where to find winrt/base.h, winrt/Windows.Foundation.h, etc.

``CppWinRT_LIBRARIES``
  The libraries to link against to use C++/WinRT.

``CppWinRT_VERSION``
  Version of the C++/WinRT library found, this is the version of Windows SDK.

``CppWinRT_FOUND``
  TRUE if found.

#]=======================================================================]

# Custom Windows 10 SDK directory.
# https://cmake.org/cmake/help/latest/variable/CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION.html
if(DEFINED ENV{CMAKE_WINDOWS_KITS_10_DIR})
  set(CppWinRT_WINDOWS_SDK_DIR "$ENV{CMAKE_WINDOWS_KITS_10_DIR}")

# The environment variable `WindowsSdkDir` provided by MSVC.
elseif(DEFINED ENV{WindowsSdkDir})
  set(CppWinRT_WINDOWS_SDK_DIR "$ENV{WindowsSdkDir}")
endif()

if(DEFINED CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION)
  set(CppWinRT_WINDOWS_SDK_VERSION ${CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION})

  # The environment variable `WindowsSDKVersion` is not required.
  # This is because the environment variable `Lib` provided by MSVC contains the
  # directory where the library of the Windows SDK of the corresponding version
  # exists, and is included in the search range of `find_path` and `find_library`.
  #
# elseif(DEFINED ENV{WindowsSDKVersion})
#   set(CppWinRT_WINDOWS_SDK_VERSION "$ENV{WindowsSDKVersion}")
#   # Delete last backslash in environment variable `WindowsSDKVersion`.
#   # e.g. 10.0.xxxxx.x\
#   #                  ^
#   string(REGEX REPLACE "\\\\" "" CppWinRT_WINDOWS_SDK_VERSION "${CppWinRT_WINDOWS_SDK_VERSION}")

elseif(WIN32)
  # If the target platform is `WIN32`, the variable `CMAKE_SYSTEM_VERSION`
  # is the target Windows version. This should match the Windows SDK version.
  set(CppWinRT_WINDOWS_SDK_VERSION ${CMAKE_SYSTEM_VERSION})
endif()

if("${CMAKE_VS_PLATFORM_NAME}" STREQUAL "ARM")
  if(CMAKE_CL_64)
    set(CppWinRT_TARGERT_ARCH arm64)
  else()
    set(CppWinRT_TARGERT_ARCH arm)
  endif()
else()
  if(CMAKE_CL_64)
    set(CppWinRT_TARGERT_ARCH x64)
  else()
    set(CppWinRT_TARGERT_ARCH x86)
  endif()
endif()

set(CppWinRT_INCLUDE_SUFFIXES)
set(CppWinRT_LIBRARY_SUFFIXES)

if(DEFINED CppWinRT_WINDOWS_SDK_VERSION)
  list(APPEND CppWinRT_INCLUDE_SUFFIXES
    "include/${CppWinRT_WINDOWS_SDK_VERSION}/cppwinrt")

  if(DEFINED CppWinRT_TARGERT_ARCH)
    list(APPEND CppWinRT_LIBRARY_SUFFIXES
      "Lib/${CppWinRT_WINDOWS_SDK_VERSION}/um/${CppWinRT_TARGERT_ARCH}")
  endif()

endif()

find_path(CppWinRT_INCLUDE_DIR
  NAMES winrt/base.h winrt/Windows.Foundation.h
  # Since the default Windows SDK directory exists in the search path,
  # HINTS is used to detect user-defined version libraries with priority.
  HINTS ${CppWinRT_WINDOWS_SDK_DIR}
  PATH_SUFFIXES
    ${CppWinRT_INCLUDE_SUFFIXES})

find_library(CppWinRT_LIBRARY
  NAMES WindowsApp.lib
  # Since the default Windows SDK directory exists in the search path,
  # HINTS is used to detect user-defined version libraries with priority.
  HINTS ${CppWinRT_WINDOWS_SDK_DIR}
  PATH_SUFFIXES
    ${CppWinRT_LIBRARY_SUFFIXES})

if(DEFINED CppWinRT_INCLUDE_DIR AND DEFINED CppWinRT_LIBRARY)
  # Get version string from directory name (e.g. 10.0.17763.0).
  # Include path: ${WindowsSdkDir}/Include/<version>/cppwinrt
  #                                        ^^^^^^^^^
  # Library path: ${WindowsSdkDir}/Lib/<version>/um/<arch>/WindowsApp.lib
  #                                    ^^^^^^^^^

  get_filename_component(CppWinRT_INCLUDE_DIR_VERSION
    "${CppWinRT_INCLUDE_DIR}/.." ABSOLUTE)
  get_filename_component(CppWinRT_INCLUDE_DIR_VERSION
    "${CppWinRT_INCLUDE_DIR_VERSION}" NAME)

    get_filename_component(CppWinRT_LIBRARY_DIR_VERSION
      "${CppWinRT_LIBRARY}/../../.." ABSOLUTE)
      get_filename_component(CppWinRT_LIBRARY_DIR_VERSION
        "${CppWinRT_LIBRARY_DIR_VERSION}" NAME)

  if(CppWinRT_INCLUDE_DIR_VERSION VERSION_EQUAL CppWinRT_LIBRARY_DIR_VERSION)
    set(CppWinRT_VERSION ${CppWinRT_INCLUDE_DIR_VERSION})
  endif()

  unset(CppWinRT_INCLUDE_DIR_VERSION)
  unset(CppWinRT_LIBRARY_DIR_VERSION)
endif()

unset(CppWinRT_WINDOWS_SDK_DIR)
unset(CppWinRT_WINDOWS_SDK_VERSION)
unset(CppWinRT_TARGERT_ARCH)
unset(CppWinRT_INCLUDE_SUFFIXES)
unset(CppWinRT_LIBRARY_SUFFIXES)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(CppWinRT
  REQUIRED_VARS CppWinRT_INCLUDE_DIR CppWinRT_LIBRARY
  VERSION_VAR CppWinRT_VERSION)

if(CppWinRT_FOUND)
  set(CppWinRT_INCLUDE_DIRS "${CppWinRT_INCLUDE_DIR}")
  set(CppWinRT_LIBRARIES "${CppWinRT_LIBRARY}")

  if(NOT TARGET CppWinRT::CppWinRT)
    add_library(CppWinRT::CppWinRT UNKNOWN IMPORTED)
    set_target_properties(CppWinRT::CppWinRT
      PROPERTIES
        IMPORTED_LOCATION ${CppWinRT_LIBRARIES}
        INTERFACE_INCLUDE_DIRECTORIES ${CppWinRT_INCLUDE_DIR})
  endif()
endif()

mark_as_advanced(CppWinRT_INCLUDE_DIR CppWinRT_LIBRARY)
