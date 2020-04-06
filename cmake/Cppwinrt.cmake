#[========================================================================[.rst:
CppwinrtGenerateProjectionHeader
--------------------------------

Overview
^^^^^^^^

Generate C++/WinRT projection header by ``cppwinrt.exe``.

For more information about C++/WinRT and ``cppwinrt.exe``, see
`GitHub: microsoft/cppwinrt <https://github.com/microsoft/cppwinrt>`_.

.. note::
  ``cppwinrt.exe`` requirements.

  ``cppwinrt.exe` use WinMetadata file (.winmd) to generate projection header.
  Should installed target Windows SDK on the CMake running machine.

.. command:: cppwinrt_generate_projection_header

  .. code-block:: cmake

    cppwinrt_generate_projection_header(<target_name>
      CPPWINRT_VERSION <cppwinrt-version>
      CPPWINRT_WINDOWS_SDK <cppwinrt-windows-sdk>
      CPPWINRT_HEADER_OUTPUT_DIRECTORY <cppwinrt-header-output-directory>
      [CPPWINRT_FASTABI]
      [CPPWINRT_OPTIMIZE]
      [CPPWINRT_OVERWRITE]
      [CPPWINRT_VERBOSE]
      DOWNLOAD_URL <cppwinrt-download-url>
      DOWNLOAD_SHA256 <cppwinrt-download-sha256>
      [DOWNLOAD_TIMEOUT <cppwinrt-download-timeout]
      [WORKING_DIRECTORY <cppwinrt-working-directory>]
    )

  This command download ``cppwinrt.exe`` from GitHub cppwinrt release page, and
  Execute ``cppwinrt.exe`` to generate C++/WinRT projection header files.

  ``<target_name>``
    `FetchContent_Declare` and `FetchContent_Populate` target names used internally.

  ``CPPWINRT_VERSION <cppwinrt-version>``
    C++/WinRT version.

  ``CPPWINRT_WINDOWS_SDK <cppwinrt-windows-sdk>``
    Windows SDK version.
    This variable is passed to ``-input`` option of ``cppwinrt.exe``.
    Windows SDK version and ``local``, ``sdk`` can also be specified.

  ``CPPWINRT_HEADER_OUTPUT_DIRECTORY <cppwinrt-header-output-directory>``
    C++/WinRT header output directory.
    This variable is passed to ``-output`` option of ``cppwinrt.exe``.

  ``CPPWINRT_FASTABI``
    If this option is specified, set ``-fastabi`` option of ``cppwinrt.exe``.

  ``CPPWINRT_OPTIMIZE``
    If this option is specified, set ``-optimize`` option of ``cppwinrt.exe``.

  ``CPPWINRT_OVERWRITE``
    If this option is specified, set ``-overwrite`` option of ``cppwinrt.exe``.

  ``CPPWINRT_VERBOSE``
    If this option is specified, set ``-verbose`` option of ``cppwinrt.exe``.

  ``DOWNLOAD_URL <cppwinrt-download-url>``
    Download URL for C++/WinRT Nuget package.
    Must be able to download the Nuget package file (.nupkg) from this URL.
    e.g. `https://github.com/microsoft/cppwinrt/releases/download/2.0.200514.2/Microsoft.Windows.CppWinRT.2.0.200514.2.nupkg`

  ``DOWNLOAD_SHA256 <cppwinrt-download-sha256>``
    Sha256 hash of the file downloaded from ``DOWNLOAD_URL``.

  ``DOWNLOAD_TIMEOUT <cppwinrt-download-timeout``
    Downalod timeout.
    The default value is ``60``.

  ``WORKING_DIRECTORY <cppwinrt-working-directory>``
    Execute the command with the given current working directory.
    The default value is ``<target_name>``.

Examples
^^^^^^^^

Generate C++/WinRT projection header and find dependent library
(by ``FindCppwinrt.cmake``).

.. code-block:: cmake

  set(Cppwinrt_VERWSION 2.0.200514.2)
  set(WindowsSDK_VERSION 10.0.18362.0)
  set(Cppwinrt_INCLUDE_DIR
    "cppwinrt_${Cppwinrt_VERWSION}_${WindowsSDK_VERSION}/include")

  # Generate C++/WinRT projection header in ``Cppwinrt_INCLUDE_DIR``.
  cppwinrt_generate_projection_header(cppwinrt_generate_header
    CPPWINRT_VERSION ${Cppwinrt_VERWSION}
    CPPWINRT_WINDOWS_SDK ${WindowsSDK_VERSION}
    CPPWINRT_HEADER_OUTPUT_DIRECTORY "${Cppwinrt_INCLUDE_DIR}"
    DOWNLOAD_URL "https://github.com/microsoft/cppwinrt/releases/download/2.0.200514.2/Microsoft.Windows.CppWinRT.2.0.200514.2.nupkg"
    DOWNLOAD_SHA256 cca4b0b3e232a13606a1d4a70f1bc0304d536392aa11c22eedb53cab8a02a089
    WORKING_DIRECTORY "cppwinrt_generate_header")

  # Use ``FindCppwinrt.cmake``.
  find_package(Cppwinrt ${Cppwinrt_VERSION} EXACT
    REQUIRED
    MODULE)

  add_executable(foo main.cpp)
  target_link_libraries(foo
    PUBLIC
      Cppwinrt::Cppwinrt)

#]========================================================================]

cmake_minimum_required(VERSION 3.12.0)

include(FetchContent)

function(cppwinrt_generate_projection_header target_name)
  set(options
    CPPWINRT_FASTABI
    CPPWINRT_OPTIMIZE
    CPPWINRT_OVERWRITE
    CPPWINRT_VERBOSE)
  set(onValueArgs
    CPPWINRT_VERSION
    CPPWINRT_WINDOWS_SDK
    CPPWINRT_HEADER_OUTPUT_DIRECTORY
    DOWNLOAD_URL
    DOWNLOAD_SHA256
    DOWNLOAD_TIMEOUT
    WORKING_DIRECTORY)
  set(multiValueArgs)

  cmake_parse_arguments(
    CppwinrtGenerateProjectionHeaderArgs
    "${options}"
    "${onValueArgs}"
    "${multiValueArgs}"
    ${ARGN})

  if(NOT DEFINED CppwinrtGenerateProjectionHeaderArgs_CPPWINRT_VERSION)
    message(FATAL_ERROR "CPPWINRT_VERSION not defined")
  endif()

  if(NOT DEFINED CppwinrtGenerateProjectionHeaderArgs_CPPWINRT_WINDOWS_SDK)
    message(FATAL_ERROR "CPPWINRT_WINDOWS_SDK not defined")
  endif()

  if(NOT DEFINED CppwinrtGenerateProjectionHeaderArgs_WORKING_DIRECTORY)
    set(CppwinrtGenerateProjectionHeaderArgs_WORKING_DIRECTORY "${target_name}")
  endif()

  if(NOT DEFINED CppwinrtGenerateProjectionHeaderArgs_CPPWINRT_HEADER_OUTPUT_DIRECTORY)
    message(FATAL_ERROR "CPPWINRT_HEADER_OUTPUT_DIRECTORY not defined")
  endif()

  if(NOT DEFINED CppwinrtGenerateProjectionHeaderArgs_DOWNLOAD_URL)
    message(FATAL_ERROR "DOWNLOAD_URL not defined")
  endif()

  if(NOT DEFINED CppwinrtGenerateProjectionHeaderArgs_DOWNLOAD_SHA256)
    message(FATAL_ERROR "DOWNLOAD_SHA256 not defined")
  endif()

  if(NOT DEFINED CppwinrtGenerateProjectionHeaderArgs_DOWNLOAD_TIMEOUT)
    set(CppwinrtGenerateProjectionHeaderArgs_DOWNLOAD_TIMEOUT 60)
  endif()

  set(CppwinrtGenerateProjectionHeader_DOWNLOAD_NAME "")
  get_filename_component(CppwinrtGenerateProjectionHeader_DOWNLOAD_FILE_EXTENSION
    "${CppwinrtGenerateProjectionHeaderArgs_DOWNLOAD_URL}" EXT)
  string(TOLOWER "${CppwinrtGenerateProjectionHeader_DOWNLOAD_FILE_EXTENSION}"
    CppwinrtGenerateProjectionHeader_DOWNLOAD_FILE_EXTENSION)
  if(CppwinrtGenerateProjectionHeader_DOWNLOAD_FILE_EXTENSION MATCHES "\.nupkg$")
    # NOTE: .nupkg is ZIP file format. Add the suffix ".zip" to enable automatic
    # extraction by `FetchContent`.
    get_filename_component(CppwinrtGenerateProjectionHeader_DOWNLOAD_FILE_NAME
      "${CppwinrtGenerateProjectionHeaderArgs_DOWNLOAD_URL}" NAME)
    set(CppwinrtGenerateProjectionHeader_DOWNLOAD_NAME
      "${CppwinrtGenerateProjectionHeader_DOWNLOAD_FILE_NAME}.zip")

    unset(CppwinrtGenerateProjectionHeader_DOWNLOAD_FILE_NAME)
  endif()
  unset(CppwinrtGenerateProjectionHeader_DOWNLOAD_FILE_EXTENSION)

  # Download and extract.
  FetchContent_Declare(${target_name}
    PREFIX "${CppwinrtGenerateProjectionHeaderArgs_WORKING_DIRECTORY}"
    URL "${CppwinrtGenerateProjectionHeaderArgs_DOWNLOAD_URL}"
    URL_HASH SHA256=${CppwinrtGenerateProjectionHeaderArgs_DOWNLOAD_SHA256}
    DOWNLOAD_NAME "${CppwinrtGenerateProjectionHeader_DOWNLOAD_NAME}"
    TIMEOUT ${CppwinrtGenerateProjectionHeaderArgs_DOWNLOAD_TIMEOUT})

  set(CppwinrtGenerateProjectionHeader_TARGET_POPULATED
    "${target_name}_POPULATED")
  FetchContent_GetProperties(${target_name}
    POPULATED ${CppwinrtGenerateProjectionHeader_TARGET_POPULATED})
  if(NOT ${CppwinrtGenerateProjectionHeader_TARGET_POPULATED})
    FetchContent_Populate(${target_name})
  endif()

  FetchContent_GetProperties(${target_name}
    SOURCE_DIR CppwinrtGenerateProjectionHeader_SOURCE_DIR)

  if(NOT CppwinrtGenerateProjectionHeaderArgs_CPPWINRT_OVERWRITE)
    set(CppwinrtGenerateProjectionHeader_GENERATE_FILE
      "${CppwinrtGenerateProjectionHeaderArgs_CPPWINRT_HEADER_OUTPUT_DIRECTORY}/winrt/base.h")
    if(EXISTS "${CppwinrtGenerateProjectionHeader_GENERATE_FILE}")
      message("${target_name}: skip generate cppwinrt projection headers. \
${CppwinrtGenerateProjectionHeader_GENERATE_FILE} is already exists.")
      return()
    endif()
  endif()

  set(CppwinrtGenerateProjectionHeader_COMMAND_LINE
    "${CppwinrtGenerateProjectionHeader_SOURCE_DIR}/bin/cppwinrt.exe")
  list(APPEND CppwinrtGenerateProjectionHeader_COMMAND_LINE
    "-input" "${CppwinrtGenerateProjectionHeaderArgs_CPPWINRT_WINDOWS_SDK}"
    "-output" "${CppwinrtGenerateProjectionHeaderArgs_CPPWINRT_HEADER_OUTPUT_DIRECTORY}")

  if(CppwinrtGenerateProjectionHeaderArgs_CPPWINRT_FASTABI)
    list(APPEND CppwinrtGenerateProjectionHeader_COMMAND_LINE "-fastabi")
  endif()

  if(CppwinrtGenerateProjectionHeaderArgs_CPPWINRT_OPTIMIZE)
    list(APPEND CppwinrtGenerateProjectionHeader_COMMAND_LINE "-optimize")
  endif()

  if(CppwinrtGenerateProjectionHeaderArgs_CPPWINRT_OVERWRITE)
    list(APPEND CppwinrtGenerateProjectionHeader_COMMAND_LINE "-overwrite")
  endif()

  if(CppwinrtGenerateProjectionHeaderArgs_CPPWINRT_VERBOSE)
    list(APPEND CppwinrtGenerateProjectionHeader_COMMAND_LINE "-verbose")
  endif()

  set(CppwinrtGenerateProjectionHeader_OUTPUT_FILE
    "${CppwinrtGenerateProjectionHeaderArgs_WORKING_DIRECTORY}/${target_name}.cppwinrt.output.log")
  set(CppwinrtGenerateProjectionHeader_ERROR_FILE
    "${CppwinrtGenerateProjectionHeaderArgs_WORKING_DIRECTORY}/${target_name}.cppwinrt.error.log")

  message("${target_name}: generate cppwinrt projection headers.")

  # Execute ``cppwinrt.exe``.
  execute_process(COMMAND ${CppwinrtGenerateProjectionHeader_COMMAND_LINE}
    RESULT_VARIABLE CppwinrtGenerateProjectionHeader_COMMAND_RESULT_CODE
    OUTPUT_FILE "${CppwinrtGenerateProjectionHeader_OUTPUT_FILE}"
    ERROR_FILE "${CppwinrtGenerateProjectionHeader_ERROR_FILE}"
    WORKING_DIRECTORY "${CppwinrtGenerateProjectionHeaderArgs_WORKING_DIRECTORY}")

  if(NOT CppwinrtGenerateProjectionHeader_COMMAND_RESULT_CODE EQUAL 0)
    message(FATAL_ERROR
      "${target_name} failed: See ${CppwinrtGenerateProjectionHeader_ERROR_FILE}")
  endif()

endfunction()
