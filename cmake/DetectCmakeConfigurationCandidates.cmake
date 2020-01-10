cmake_minimum_required(VERSION 3.4.0)

#[=============================================================================[.rst

DetectCmakeConfigurationCandidates
----------------------------------

detect_cmake_configuration_candidates
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. command:: detect_cmake_configuration_candidates

  detect_cmake_configuration_candidates(<output variable>)

Detect CMake Configuration candidates.
Set ``CMAKE_CONFIGURATION_TYPES`` and ``CMAKE_BUILD_TYPE`` to ``<out-var>``.

Example
"""""""

.. code-block:: cmake

  set(CMAKE_CONFIGURATION_TYPES "Debug;Release" CACHE STRING "" FORCE)

  detect_cmake_configuration_candidates(CONF_CANDIDATES)
  message("CONF_CANDIDATES=${CONF_CANDIDATES}")

When using single-configuration generators, output message
"CONF_CANDIDATES=Debug;Release;MinSizeRel".
When using multi-configuration generators, output message
"CONF_CANDIDATES=Debug;Release;".

]=============================================================================]

function(detect_cmake_configuration_candidates output_name)
  # multi-configuration generator
  if(CMAKE_CONFIGURATION_TYPES)

    foreach(CMAKE_CONFIGURATION_TYPE_ IN LISTS CMAKE_CONFIGURATION_TYPES)
      list(APPEND ${output_name} "${CMAKE_CONFIGURATION_TYPE_}")
    endforeach()

  endif()

  # single-configuration generator
  if(CMAKE_BUILD_TYPE)
    list(APPEND ${output_name} "${CMAKE_BUILD_TYPE}")
  endif()

  if(${output_name})
    list(REMOVE_DUPLICATES ${output_name})
  endif()

  set(${output_name} "${${output_name}}" PARENT_SCOPE)
endfunction()
