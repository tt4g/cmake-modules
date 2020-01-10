cmake_minimum_required(VERSION 3.4.0)

#[=============================================================================[.rst

CompileOptions
--------------

.. command:: set_cxx_warning_options

    set_cxx_warning_options(<target>)

  Add warning flag to the ``<target>`` compiler options.

NOTE
""""

  `CMAKE_CXX_FLAGS` and `CMAKE_C_FLAGS` is contain */W3* on MSVC.
  This causes a conflict with */W4* set by `set_cxx_warning_options`.
  Then MSVC compiler emits the warning message *D9025* when set multiple warning flags.

  If you want to suppress the warning message of *D9025*,
  remove */W0* - */W4* flags from **CMAKE_CXX_FLAGS** and **CMAKE_C_FLAGS**.

  .. code-block:: cmake

    if(MSVC)
      string(REGEX REPLACE "/W[0-4]" "" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
      string(REGEX REPLACE "/W[0-4]" "" CMAKE_C_FLAGS "${CMAKE_C_FLAGS}")
    endif()

.. command:: set_source_charset

    set_source_charset(<target> <charset>)

  Set source-charset of the ``<target>`` to ``<charset>``.

Example
"""""""

  .. code-block:: cmake

    add_executable(foo ...)
    set_source_charset(foo utf-8)

.. command:: set_source_charset_utf8

    set_source_charset_utf8(<target>)

  Set source-charset of the ``<target>`` to *utf-8*.

.. command:: set_execution_charset

    set_execution_charset(<target> <charset>)

  Set execution-charset of the ``<target>`` to ``<charset>``.

Example
"""""""

  .. code-block:: cmake

    add_executable(foo ...)
    set_execution_charset(foo utf-8)

.. command:: set_execution_charset_utf8

    set_execution_charset_utf8(<target> <charset>)

  Set execution-charset of the ``<target>`` to *utf-8*.

]=============================================================================]

function(set_cxx_warning_options target)
  set(MSVC_WARNING_FLAGS
    /W4 /WX /Za /EHsc
    /w44061 /w34062 /w34191 /w44242 /w44254 /w44255 /w44263 /w14264 /w34265
    /w44266 /w34287 /w44289 /w44296 /w24302 /w14311 /w14312 /w44339 /w14342
    /w14350 /w44355 /w44365 /w34370 /w34371 /w44388 /w24412 /w44431 /w44435
    /w44437 /w34444 /w44471 /w14472 /w44514 /w44536 /w14545 /w14546 /w14547
    /w14548 /w14549 /w14555 /w34557 /w44571 /w44574 /w34608 /w44619 /w44623
    /w44625 /w44626 /w14628 /w34640 /w44668 /w44682 /w44682 /w34686 /w14692
    /w44710 /w34738 /w44767 /w34786 /w44820 /w24826 /w44837 /w14905 /w14906
    /w14917 /w14928 /w44931 /w14946 /w44986 /w44987 /w44988)

  target_compile_options(${target}
    PRIVATE
      $<$<CXX_COMPILER_ID:MSVC>:${MSVC_WARNING_FLAGS}>)

  # The MSVC compiler version 14.0(VS 2015) and above supports /permissive.
  target_compile_options(${target}
    PRIVATE
      $<$<AND:$<CXX_COMPILER_ID:MSVC>,$<VERSION_GREATER_EQUAL:${MSVC_VERSION},1900>>:/permissive->)

  set(GCC_WARNING_FLAGS
    -Wall -Werror -pedantic -Wextra
    -Wcast-align -Wcast-qual -Wendif-labels -Wfloat-equal
    -Winit-self -Winline -Wmissing-include-dirs -Wmissing-include-dirs
    -Wpacked -Wpointer-arith -Wredundant-decls -Wshadow -Wsign-promo
    -Wswitch-default -Wswitch-enum -Wvariadic-macros -Wwrite-strings)

  target_compile_options(${target}
    PRIVATE
      $<$<CXX_COMPILER_ID:GNU>:${GCC_WARNING_FLAGS}>)
endfunction()

function(set_source_charset target charset)
  target_compile_options(${target}
    PRIVATE
      $<$<CXX_COMPILER_ID:MSVC>:/source-charset:${charset}>)

  target_compile_options(${target}
    PRIVATE
      $<$<CXX_COMPILER_ID:GNU>:--input-charset=${charset}>)
endfunction()

function(set_source_charset_utf8 target)
  set_source_charset(${target} utf-8)
endfunction()

function(set_execution_charset target charset)
  target_compile_options(${target}
    PRIVATE
      $<$<CXX_COMPILER_ID:MSVC>:/execution-charset:${charset}>)

  target_compile_options(${target}
    PRIVATE
      $<$<CXX_COMPILER_ID:GNU>:--exec-charset=${charset}>)
endfunction()

function(set_execution_charset_utf8 target)
  set_execution_charset(${target} utf-8)
endfunction()
