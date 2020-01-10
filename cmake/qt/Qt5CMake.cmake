cmake_minimum_required(VERSION 3.4.0)

#[=============================================================================[.rst

Qt5CMake
--------

Qt5 support.

* `cmake-qt(7) <https://cmake.org/cmake/help/latest/manual/cmake-qt.7.html>`_
* `CMake Manual <http://doc.qt.io/qt-5/cmake-manual.html>`_
* `Using the Meta-Object Compiler (moc) <http://doc.qt.io/qt-5/moc.html>`_
* `The Qt Resource System <http://doc.qt.io/qt-5/resources.html>`_

setup_qt_cmake
^^^^^^^^^^^^^^

.. command:: setup_qt_cmake

  setup_qt_cmake()

Qt5 CMake setup shortcut.

Set `ON` to variable `CMAKE_INCLUDE_CURRENT_DIR`, and call
`add_qt_prefix_path()`, `enable_qt_automoc()`, `enable_qt_autouic()` and
`enable_qt_autorcc()`.

add_qt_prefix_path
^^^^^^^^^^^^^^^^^^

.. command:: add_qt_prefix_path

  add_qt_prefix_path()

Append Qt CMake module path to `CMAKE_PREFIX_PATH`, if `QTDIR` defined in
enviroment variable.

enable_qt_automoc
^^^^^^^^^^^^^^^^^

.. command:: enable_qt_automoc

  enable_qt_automoc()

Enable Qt Meta Object Compiler.

enable_qt_autouic
^^^^^^^^^^^^^^^^^

.. command:: enable_qt_autouic

  enable_qt_autouic()

Enable Qt User Interface support.

enable_qt_autorcc
^^^^^^^^^^^^^^^^^

.. command:: enable_qt_autorcc

  enable_qt_autorcc()

Enable Qt Resource Collection support.

set_target_qt_properties
^^^^^^^^^^^^^^^^^^^^^^^^

.. command: set_target_qt_properties

  set_target_qt_properties(
    TARGET target1 target2 ...
    [AUTOMOC]
    [AUTOUIC]
    [AUTORCC]
    [AUTOMOC_MACRO_NAMES <options> ... ]
    [AUTOMOC_MOC_OPTIONS <options> ... ]
    [AUTOMOC_DEPEND_FILTERS <options> ... ]
    [AUTOUIC_OPTIONS <options> ... ]
    [AUTOUIC_SEARCH_PATHS <options> ... ]
    [AUTORCC_OPTIONS <options> ... ]
  )

  Set Qt properties on targets.

  For more details of each properties,
  see `cmake-qt(7) <https://cmake.org/cmake/help/latest/manual/cmake-qt.7.html>`_.

OPTIONS
"""""""

``AUTOMOC``
  If the ``AUTOMOC`` flag is specified, set `ON` to ``AUTOMOC`` property.

``AUTOUIC``
  If the ``AUTOUIC`` flag is specified, set `ON` to ``AUTOUIC`` property.

``AUTORCC``
  If the ``AUTORCC`` flag is specified, set `ON` to `AUTOUIC`` property.

``AUTOMOC_MACRO_NAMES``
  if defined, pass to target properties ``AUTOMOC_MACRO_NAMES``.

``AUTOMOC_MOC_OPTIONS``
  if defined, pass to target properties ``AUTOMOC_MOC_OPTIONS``.

``AUTOMOC_DEPEND_FILTERS``
  if defined, pass to target properties ``AUTOMOC_DEPEND_FILTERS``.

``AUTOUIC_OPTIONS``
  if defined, pass to target properties ``AUTOUIC_OPTIONS``.

``AUTOUIC_SEARCH_PATHS``
  if defined, pass to target properties ``AUTOUIC_SEARCH_PATHS``.

``AUTORCC_OPTIONS``
  if defined, pass to target properties ``AUTORCC_OPTIONS``.

Example
"""""""

.. code-block:: cmake

  add_executable(foo foo.cpp)
  set_target_qt_properties(TARGET foo AUTOMOC AUTOUIC AUTORCC)

]=============================================================================]

function(setup_qt_cmake)
  set(CMAKE_INCLUDE_CURRENT_DIR ON PARENT_SCOPE)

  add_qt_prefix_path()
  set(CMAKE_PREFIX_PATH "${CMAKE_PREFIX_PATH}" PARENT_SCOPE)

  enable_qt_automoc()
  set(CMAKE_AUTOMOC ${CMAKE_AUTOMOC} PARENT_SCOPE)

  enable_qt_autouic()
  set(CMAKE_AUTOUIC ${CMAKE_AUTOUIC} PARENT_SCOPE)

  enable_qt_autorcc()
  set(CMAKE_AUTORCC ${CMAKE_AUTORCC} PARENT_SCOPE)
endfunction()

function(add_qt_prefix_path)

  if(DEFINED ENV{QTDIR})
    set(CMAKE_PREFIX_PATH ${CMAKE_PREFIX_PATH} "$ENV{QTDIR}" PARENT_SCOPE)
  endif()

endfunction()

function(enable_qt_automoc)
  # Instruct CMake to run moc automatically when needed.
  set(CMAKE_AUTOMOC ON PARENT_SCOPE)
endfunction()

function(enable_qt_autouic)
  # Create code from a list of Qt designer ui files.
  set(CMAKE_AUTOUIC ON PARENT_SCOPE)
endfunction()

function(enable_qt_autorcc)
  # .qrc files added as target sources at build time and invoke rcc accordingly.
  set(CMAKE_AUTORCC ON PARENT_SCOPE)
endfunction()

function(set_target_qt_properties)
  set(options
    AUTOMOC
    AUTOUIC
    AUTORCC)
  set(oneValueArgs)
  set(multiValueArgs
    TARGET
    AUTOMOC_MACRO_NAMES
    AUTOMOC_MOC_OPTIONS
    AUTOMOC_DEPEND_FILTERS
    AUTOUIC_OPTIONS
    AUTOUIC_SEARCH_PATHS
    AUTORCC_OPTIONS)

  cmake_parse_arguments(
    SetTargetQtOptionsArgs
    "${options}"
    "${oneValueArgs}"
    "${multiValueArgs}"
    ${ARGN})

  if(SetTargetQtOptionsArgs_AUTOMOC)
    set_target_properties(${SetTargetQtOptionsArgs_TARGET}
      PROPERTIES
        AUTOMOC ON)
  endif()

  if(SetTargetQtOptionsArgs_AUTOUIC)
    set_target_properties(${SetTargetQtOptionsArgs_TARGET}
      PROPERTIES
        AUTOUIC ON)
  endif()

  if(SetTargetQtOptionsArgs_AUTORCC)
    set_target_properties(${SetTargetQtOptionsArgs_TARGET}
      PROPERTIES
        AUTORCC ON)
  endif()

  if(SetTargetQtOptionsArgs_AUTOMOC_MACRO_NAMES)
    set_target_properties(${SetTargetQtOptionsArgs_TARGET}
      PROPERTIES
        AUTOMOC_MACRO_NAMES ${SetTargetQtOptionsArgs_AUTOMOC_MACRO_NAMES})
  endif()

  if(SetTargetQtOptionsArgs_AUTOMOC_MOC_OPTIONS)
    set_target_properties(${SetTargetQtOptionsArgs_TARGET}
      PROPERTIES
        AUTOMOC_MOC_OPTIONS ${SetTargetQtOptionsArgs_AUTOMOC_MOC_OPTIONS})
  endif()

  if(SetTargetQtOptionsArgs_AUTOMOC_DEPEND_FILTERS)
    set_target_properties(${SetTargetQtOptionsArgs_TARGET}
      PROPERTIES
        AUTOMOC_DEPEND_FILTERS ${SetTargetQtOptionsArgs_AUTOMOC_DEPEND_FILTERS})
  endif()

  if(SetTargetQtOptionsArgs_AUTOUIC_OPTIONS)
    set_target_properties(${SetTargetQtOptionsArgs_TARGET}
      PROPERTIES
        AUTOUIC_OPTIONS ${SetTargetQtOptionsArgs_AUTOUIC_OPTIONS})
  endif()

  if(SetTargetQtOptionsArgs_AUTOUIC_SEARCH_PATHS)
    set_target_properties(${SetTargetQtOptionsArgs_TARGET}
      PROPERTIES
        AUTOUIC_SEARCH_PATHS ${SetTargetQtOptionsArgs_AUTOUIC_SEARCH_PATHS})
  endif()

  if(SetTargetQtOptionsArgs_AUTORCC_OPTIONS)
    set_target_properties(${SetTargetQtOptionsArgs_TARGET}
      PROPERTIES
        AUTORCC_OPTIONS ${SetTargetQtOptionsArgs_AUTORCC_OPTIONS})
  endif()
endfunction()
