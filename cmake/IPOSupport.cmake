#[=============================================================================[.rst
# IPOSupport
# ----------
#]=============================================================================]

cmake_minimum_required(VERSION 3.14.0)

include(CheckIPOSupported)

#[=============================================================================[.rst
.. command:: enable_ipo_support

  Enable CMake target `INTERPROCEDURAL_OPTIMIZATION` property.

    enable_ipo_support(TARGET [<target> ...]
      [CONFIG <config> ...]
      LANGUAGES [<lang> ...])

``TARGET [<target> ...]``
  Target name to enable ``INTERPROCEDURAL_OPTIMIZATION`` property.

``[CONFIG <config> ...]``
  Enable ``INTERPROCEDURAL_OPTIMIZATION_<config> property of ``<target>`` if specified.

``LANGUAGES [<lang> ...]``
  ``<lang>`` will be passed to the ``LANGUAGES`` argument of
  ``check_ipo_supported`` command.

Example
^^^^^^^

  enable_ipo_support(TARGET foo bar
    CONFIG Release
    LANGUAGES CXX)

#]=============================================================================]

function(enable_ipo_support)
  set(options)
  set(oneValueArgs)
  set(multiValueArgs
    TARGET
    CONFIG
    LANGUAGES)

  cmake_parse_arguments(
    EnableIpoSupport
    "${options}"
    "${oneValueArgs}"
    "${multiValueArgs}"
    ${ARGN})

  if (NOT DEFINED EnableIpoSupport_TARGET)
    message(FATAL_ERROR "TARGET not defined")
  else()

    foreach(_EnableIpoSupport_TARGET IN LISTS EnableIpoSupport_TARGET)
      if (NOT TARGET ${_EnableIpoSupport_TARGET})
        message(FATAL_ERROR "${_EnableIpoSupport_TARGET} is not target")
      endif()
    endforeach()

  endif()

  check_ipo_supported(
    RESULT enable_ipo_support_IPO_SUPPORTED_RESULT
    OUTPUT enable_ipo_support_IPO_SUPPORTED_OUTPUT
    LANGUAGES ${EnableIpoSupport_LANGUAGES})

  if (NOT enable_ipo_support_IPO_SUPPORTED_RESULT)
    message(WARNING "IPO is not supported: ${enable_ipo_support_IPO_SUPPORTED_OUTPUT}")

    return()
  endif()

  if (DEFINED EnableIpoSupport_CONFIG)

    foreach(_EnableIpoSupport_CONFIG IN LISTS EnableIpoSupport_CONFIG)
      string(TOUPPER "${_EnableIpoSupport_CONFIG}" _EnableIpoSupport_CONFIG)

      set_property(TARGET ${EnableIpoSupport_TARGET}
        PROPERTY
          INTERPROCEDURAL_OPTIMIZATION_${_EnableIpoSupport_CONFIG} TRUE)
    endforeach()

  else()
    set_property(TARGET ${EnableIpoSupport_TARGET}
      PROPERTY
        INTERPROCEDURAL_OPTIMIZATION TRUE)
  endif()
endfunction()
