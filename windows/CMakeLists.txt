# The Flutter tooling requires that developers have a version of Visual Studio
# installed that includes CMake 3.14 or later. You should not increase this
# version, as doing so will cause the plugin to fail to compile for some
# customers of the plugin.
cmake_minimum_required(VERSION 3.14)

# Project-level configuration.
set(PROJECT_NAME "zego_zim")
project(${PROJECT_NAME} LANGUAGES CXX)

# This value is used when generating builds using this plugin, so it must
# not be changed
set(PLUGIN_NAME "zego_zim_plugin")

# Download native windows sdk with a script(python)
# If developers need to copy sdk locally, this command can be commented
execute_process(COMMAND python ${CMAKE_CURRENT_LIST_DIR}/download_native_sdk.py)

# Setup deps: native SDK header and link search path
include_directories(${CMAKE_CURRENT_LIST_DIR}/deps/release/x64/include)

# It seems that flutter doesn't support windows on x86
link_directories(${CMAKE_CURRENT_LIST_DIR}/deps/release/x64)

# Any new source files that you add to the plugin should be added here.
list(APPEND PLUGIN_SOURCES
  "zego_zim_plugin.cpp"
)

# Define the plugin library target. Its name must not be changed (see comment
# on PLUGIN_NAME above).
add_library(${PLUGIN_NAME} SHARED
  "include/zego_zim/zego_zim_plugin.h"
  "internal/ZIMPluginMethodHandler.h"
  "internal/ZIMPluginMethodHandler.cpp"
  "internal/ZIMPluginEventHandler.h"
  "internal/ZIMPluginEventHandler.cpp"
  "internal/ZIMPluginConverter.h"
  "internal/ZIMPluginConverter.cpp"
  ${PLUGIN_SOURCES}
)

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /utf-8 /bigobj /Zi")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} /utf-8 /bigobj /Zi")

set(CMAKE_EXE_LINKER_FLAGS "/DEBUG ${CMAKE_EXE_LINKER_FLAGS}")

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_PDB_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /Zi")
set(CMAKE_EXE_LINKER_FLAGS_RELEASE "${CMAKE_EXE_LINKER_FLAGS_RELEASE} /DEBUG /OPT:REF /OPT:ICF")
set(CMAKE_SHARED_LINKER_FLAGS_RELEASE "${CMAKE_SHARED_LINKER_FLAGS_RELEASE} /DEBUG /OPT:REF /OPT:ICF")

# Apply a standard set of build settings that are configured in the
# application-level CMakeLists.txt. This can be removed for plugins that want
# full control over build settings.
apply_standard_settings(${PLUGIN_NAME})

# Symbols are hidden by default to reduce the chance of accidental conflicts
# between plugins. This should not be removed; any symbols that should be
# exported should be explicitly exported with the FLUTTER_PLUGIN_EXPORT macro.
set_target_properties(${PLUGIN_NAME} PROPERTIES
  CXX_VISIBILITY_PRESET hidden)
target_compile_definitions(${PLUGIN_NAME} PRIVATE FLUTTER_PLUGIN_IMPL)

# Source include directories and library dependencies. Add any plugin-specific
# dependencies here.
target_include_directories(${PLUGIN_NAME} INTERFACE
  "${CMAKE_CURRENT_SOURCE_DIR}/include")
target_link_libraries(${PLUGIN_NAME} PRIVATE flutter flutter_wrapper_plugin ZIM.lib)

# List of absolute paths to libraries that should be bundled with the plugin.
# This list could contain prebuilt libraries, or libraries created by an
# external build triggered from this build file.
set(zego_zim_bundled_libraries
  ${CMAKE_CURRENT_LIST_DIR}/deps/release/x64/ZIM.dll
  PARENT_SCOPE
)
