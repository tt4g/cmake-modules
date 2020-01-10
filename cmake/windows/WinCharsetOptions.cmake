cmake_minimum_required(VERSION 3.4.0)

#[=============================================================================[.rst

WinCharsetOptions.cmake
-----------------------

MSVC compiler charset definitiions.
See `Unicode and Multibyte Character Set (MBCS) Support <https://msdn.microsoft.com/en-us/library/ey142t48.aspx>`.

.. command:: set_win_charset_unicode_options

    set_win_charset_unicode_options(<target>)

  Define `UNICODE` and `_UNICODE` macro to ``<target>``.

Example
"""""""

  .. code-block:: cmake

    add_executable(foo ...)
    set_win_charset_unicode_options(foo)

.. command:: set_win_charset_multibyte_options

    set_win_charset_multibyte_options(<target>)

  Define `_MBCS` macro to ``<target>``.

Example
"""""""

  .. code-block:: cmake

    add_executable(foo ...)
    set_win_charset_multibyte_options(foo)

]=============================================================================]

function(set_win_charset_unicode_options target)
  target_compile_definitions(${target}
    PRIVATE
      $<$<CXX_COMPILER_ID:MSVC>:UNICODE _UNICODE>)
endfunction()

function(set_win_charset_multibyte_options target)
  target_compile_definitions(${target}
    PRIVATE
      $<$<CXX_COMPILER_ID:MSVC>:_MBCS>)
endfunction()
