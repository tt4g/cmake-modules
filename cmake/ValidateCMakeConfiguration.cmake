cmake_minimum_required(VERSION 3.4.0)

#[=============================================================================[.rst

ValidateCMakeConfiguration
--------------------------

validate_cmake_configuration_types
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. command:: validate_cmake_configuration_types

  validate_cmake_configuration_types(
    TARGET <target variable>
    [ALLOW_TYPES <allow-type> ... ]
    [ALLOW_EMPTY])

Check ``CMAKE_BUILD_TYPE`` when using single-configuration generators
e.g. `cmake -G "... Makefiles" -DCMAKE_BUILD_TYPE:STRING=Debug`.

Do nothing when using multi-configuration generators.
e.g. ``cmake -G "Visutl Studio ..."``.

OPTIONS
"""""""

  ``TARGET``
    The target variable.
    Default ``CMAKE_BUILD_TYPE``.

  ``ALLOW_TYPES``
    Lists allow configuration types.
    Default ``${CMAKE_CONFIGURATION_TYPES}``

  ``ALLOW_EMPTY``
    Allow ``${TARGET}`` is empty.

Example
"""""""

.. code-block:: cmake

  set(CMAKE_CONFIGURATION_TYPES "Debug;Release" CACHE STRING "" FORCE)

  validate_cmake_configuration_types(
    TARGET CMAKE_BUILD_TYPE
    ALLOW_TYPES "${CMAKE_CONFIGURATION_TYPES}")

]=============================================================================]

function(validate_cmake_configuration_types)
  # multi-configuration generator
  if(NOT CMAKE_BUILD_TYPE)
    return()
  endif()

  set(options
    ALLOW_EMPTY)
  set(oneValueArgs
    TARGET)
  set(multiValueArgs
    ALLOW_TYPES)

  cmake_parse_arguments(
    ValidateCmakeConfigurationTypesArgs
    "${options}"
    "${oneValueArgs}"
    "${multiValueArgs}"
    ${ARGN})

  if(NOT DEFINED ValidateCmakeConfigurationTypesArgs_TARGET)
    set(ValidateCmakeConfigurationTypesArgs_TARGET CMAKE_BUILD_TYPE)
  endif()

  if(DEFINED ValidateCmakeConfigurationTypesArgs_ALLOW_TYPES)
    set(ALLOW_TYPES "${ValidateCmakeConfigurationTypesArgs_ALLOW_TYPES}")
  else()
    set(ALLOW_TYPES "${CMAKE_CONFIGURATION_TYPES}")
  endif()

  set(ACTUAL_CONFIGURATION_TYPE
    "${${ValidateCmakeConfigurationTypesArgs_TARGET}}")

  # empty
  if(ACTUAL_CONFIGURATION_TYPE STREQUAL "")
    if(ValidateCmakeConfigurationTypesArgs_ALLOW_EMPTY)
      return()
    endif()

    message(FATAL_ERROR
      "[validate_cmake_configuration_types]\
 \"${ValidateCmakeConfigurationTypesArgs_TARGET}\" is empty")
  endif()

  if(NOT ALLOW_TYPES)
    # Do nothing, if allow configuration is empty.
    return()
  endif()

  if(NOT (ACTUAL_CONFIGURATION_TYPE IN_LIST ALLOW_TYPES))
    message(FATAL_ERROR "[validate_cmake_configuration_types]\
 Invalid configuration type \"${ACTUAL_CONFIGURATION_TYPE}\", allow ${ALLOW_TYPES}")
  endif()

endfunction()
