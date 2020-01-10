# Overview

My CMake modules.

## CompileOptions.cmake

### Visual Studio compiler warnings

Visual Studio compiler produce the warning message when using
`set_cxx_warning_options(<target>)`.

```bash
cl : Command line warning D9025: overriding '/W3' with '/W4'
```

If you want to suppress this message.
define **CMAKE_USER_MAKE_RULES_OVERRIDE** variables to replace CMake default
compiler option.

Example:

* `cmake/CMakeRulesOverride.cmake`

  ```cmake
  if(MSVC)
    # Suppress D9025
    string(REGEX REPLACE "/W[0-4]" "/W4" CMAKE_CXX_FLAGS_INIT "${CMAKE_CXX_FLAGS_INIT}")
  endif()
  ```

* CMakeLists.txt

  ```cmake
  set(CMAKE_USER_MAKE_RULES_OVERRIDE 
    "${CMAKE_CURRENT_LIST_DIR}/cmake/CMakeRulesOverride.cmake")

  project(foo LANGUAGES CXX)
  ```
