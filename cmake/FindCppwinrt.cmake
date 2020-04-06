#[=======================================================================[.rst:
FindCppwinrt
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

      # Add a directry path containing FindCppwinrt.cmake
      list(APPEND CMAKE_MODULE_PATH cmake)

      set(TARGET_WINDOWS_SDK_VERSION 10.0.18362.0)

      if(NOT DEFINED CMAKE_SYSTEM_VERSION
        AND ("${CMAKE_SYSTEM_NAME}" STREQUAL "Windows"
          OR "${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "Windows"))

        set(CMAKE_SYSTEM_VERSION ${TARGET_WINDOWS_SDK_VERSION}
          CACHE INTERNAL "" FORCE)
      endif()

      project(example-project)

      find_package(Cppwinrt ${TARGET_WINDOWS_SDK_VERSION} EXACT REQUIRED)

IMPORTED targets
^^^^^^^^^^^^^^^^

This module defines the following `IMPORTED` target: ``Cppwinrt::Cppwinrt``

Result variables
^^^^^^^^^^^^^^^^

This module will set the following variables if found:

``Cppwinrt_INCLUDE_DIRS``
  Where to find winrt/base.h, winrt/Windows.Foundation.h, etc.

``Cppwinrt_LIBRARIES``
  The libraries to link against to use C++/WinRT.

``Cppwinrt_VERSION``
  Version of the C++/WinRT library found, this is the version of Windows SDK.

``Cppwinrt_FOUND``
  TRUE if found.

#]=======================================================================]

# Custom Windows 10 SDK directory.
# https://cmake.org/cmake/help/latest/variable/CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION.html
if(DEFINED ENV{CMAKE_WINDOWS_KITS_10_DIR})
  set(Cppwinrt_WINDOWS_SDK_DIR "$ENV{CMAKE_WINDOWS_KITS_10_DIR}")

# The environment variable `WindowsSdkDir` provided by MSVC.
elseif(DEFINED ENV{WindowsSdkDir})
  set(Cppwinrt_WINDOWS_SDK_DIR "$ENV{WindowsSdkDir}")
endif()

if(DEFINED CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION)
  set(Cppwinrt_WINDOWS_SDK_VERSION ${CMAKE_VS_WINDOWS_TARGET_PLATFORM_VERSION})

  # The environment variable `WindowsSDKVersion` is not required.
  # This is because the environment variable `Lib` provided by MSVC contains the
  # directory where the library of the Windows SDK of the corresponding version
  # exists, and is included in the search range of `find_path` and `find_library`.
  #
# elseif(DEFINED ENV{WindowsSDKVersion})
#   set(Cppwinrt_WINDOWS_SDK_VERSION "$ENV{WindowsSDKVersion}")
#   # Delete last backslash in environment variable `WindowsSDKVersion`.
#   # e.g. 10.0.xxxxx.x\
#   #                  ^
#   string(REGEX REPLACE "\\\\" "" Cppwinrt_WINDOWS_SDK_VERSION "${Cppwinrt_WINDOWS_SDK_VERSION}")

elseif(WIN32)
  # If the target platform is `WIN32`, the variable `CMAKE_SYSTEM_VERSION`
  # is the target Windows version. This should match the Windows SDK version.
  set(Cppwinrt_WINDOWS_SDK_VERSION ${CMAKE_SYSTEM_VERSION})
endif()

if("${CMAKE_VS_PLATFORM_NAME}" STREQUAL "ARM")
  if(CMAKE_CL_64)
    set(Cppwinrt_TARGERT_ARCH arm64)
  else()
    set(Cppwinrt_TARGERT_ARCH arm)
  endif()
else()
  if(CMAKE_CL_64)
    set(Cppwinrt_TARGERT_ARCH x64)
  else()
    set(Cppwinrt_TARGERT_ARCH x86)
  endif()
endif()

set(Cppwinrt_INCLUDE_SUFFIXES)
set(Cppwinrt_LIBRARY_SUFFIXES)

if(DEFINED Cppwinrt_WINDOWS_SDK_VERSION)
  list(APPEND Cppwinrt_INCLUDE_SUFFIXES
    "include/${Cppwinrt_WINDOWS_SDK_VERSION}/cppwinrt")

  if(DEFINED Cppwinrt_TARGERT_ARCH)
    list(APPEND Cppwinrt_LIBRARY_SUFFIXES
      "Lib/${Cppwinrt_WINDOWS_SDK_VERSION}/um/${Cppwinrt_TARGERT_ARCH}")
  endif()

endif()

find_path(Cppwinrt_INCLUDE_DIR
  NAMES winrt/base.h winrt/Windows.Foundation.h
  # Since the default Windows SDK directory exists in the search path,
  # HINTS is used to detect user-defined version libraries with priority.
  HINTS ${Cppwinrt_WINDOWS_SDK_DIR}
  PATH_SUFFIXES
    ${Cppwinrt_INCLUDE_SUFFIXES})

find_library(Cppwinrt_LIBRARY
  NAMES WindowsApp.lib
  # Since the default Windows SDK directory exists in the search path,
  # HINTS is used to detect user-defined version libraries with priority.
  HINTS ${Cppwinrt_WINDOWS_SDK_DIR}
  PATH_SUFFIXES
    ${Cppwinrt_LIBRARY_SUFFIXES})

if(DEFINED Cppwinrt_INCLUDE_DIR)
  set(Cppwinrt_BASE_HEADER_FILE "${Cppwinrt_INCLUDE_DIR}/winrt/base.h")
  if(EXISTS "${Cppwinrt_BASE_HEADER_FILE}")
    file(STRINGS "${Cppwinrt_BASE_HEADER_FILE}" Cppwinrt_VERSION_STRING
        # #define CPPWINRT_VERSION "2.0.200316.3"
        REGEX "^#define[\t ]+CPPWINRT_VERSION[\t ]+.*")
    if(Cppwinrt_VERSION_STRING)
      string(REGEX REPLACE "^#define[\t ]+CPPWINRT_VERSION[\t ]+\"?([0-9.]+)\"?"
            "\\1" Cppwinrt_VERSION "${Cppwinrt_VERSION_STRING}")
    endif()
  endif()

  unset(Cppwinrt_BASE_HEADER_FILE)
endif()

unset(Cppwinrt_WINDOWS_SDK_DIR)
unset(Cppwinrt_WINDOWS_SDK_VERSION)
unset(Cppwinrt_TARGERT_ARCH)
unset(Cppwinrt_INCLUDE_SUFFIXES)
unset(Cppwinrt_LIBRARY_SUFFIXES)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Cppwinrt
  REQUIRED_VARS Cppwinrt_INCLUDE_DIR Cppwinrt_LIBRARY
  VERSION_VAR Cppwinrt_VERSION)

if(Cppwinrt_FOUND)
  set(Cppwinrt_INCLUDE_DIRS "${Cppwinrt_INCLUDE_DIR}")
  set(Cppwinrt_LIBRARIES "${Cppwinrt_LIBRARY}")

  if(NOT TARGET Cppwinrt::Cppwinrt)
    add_library(Cppwinrt::Cppwinrt UNKNOWN IMPORTED)
    set_target_properties(Cppwinrt::Cppwinrt
      PROPERTIES
        IMPORTED_LOCATION ${Cppwinrt_LIBRARIES}
        INTERFACE_INCLUDE_DIRECTORIES ${Cppwinrt_INCLUDE_DIR})
  endif()
endif()

mark_as_advanced(Cppwinrt_INCLUDE_DIR Cppwinrt_LIBRARY)
