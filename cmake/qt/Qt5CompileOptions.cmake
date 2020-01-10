cmake_minimum_required(VERSION 3.4.0)

#[=============================================================================[.rst

QtCompileOptions
----------------

.. command:: set_qt_compile_options

    set_qt_compile_options(<target>)

  Enable Qt warning macros.

  .. code-block:: cmake

    add_executable(foo ...)
    set_qt_compile_options(foo)

.. command:: set_qt_debug_disable_options

    set_qt_debug_disable_options(<target>)

  Add **QT_NO_DEBUG_OUTPUT** to ``<target>`` compiler definitions,
  if ``$<CONFIG:Release>`` is ``TRUE``.

  .. code-block:: cmake

    add_executable(foo ...)
    set_qt_debug_disable_options(foo)

]=============================================================================]

function(set_qt_compile_options target)
  target_compile_definitions(${target}
    PRIVATE
      QT_DEPRECATED_WARNINGS
      QT_DISABLE_DEPRECATED_BEFORE)
endfunction()

function(set_qt_debug_disable_options target)
  target_compile_definitions(${target}
    PRIVATE
      $<$<CONFIG:Release>:QT_NO_DEBUG_OUTPUT>)
endfunction()
