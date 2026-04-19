cmake_minimum_required(VERSION 3.16)
project(StarYuanGame LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(SFML_BUILD_AUDIO OFF CACHE BOOL "" FORCE)
set(SFML_BUILD_NETWORK OFF CACHE BOOL "" FORCE)

# Optional: point to an extracted SFML 2.6.x source tree to skip any download (recommended on Win11 / bad network).
set(STAR_YUAN_SFML_DIR "" CACHE PATH "Path to SFML 2.6.x sources (folder containing CMakeLists.txt); empty = auto")

set(_sfml_local "")
if(STAR_YUAN_SFML_DIR AND EXISTS "${STAR_YUAN_SFML_DIR}/CMakeLists.txt")
  set(_sfml_local "${STAR_YUAN_SFML_DIR}")
elseif(EXISTS "${CMAKE_SOURCE_DIR}/third_party/sfml/CMakeLists.txt")
  set(_sfml_local "${CMAKE_SOURCE_DIR}/third_party/sfml")
elseif(EXISTS "${CMAKE_SOURCE_DIR}/third_party/SFML-2.6.2/CMakeLists.txt")
  set(_sfml_local "${CMAKE_SOURCE_DIR}/third_party/SFML-2.6.2")
endif()

if(_sfml_local)
  message(STATUS "Using local SFML sources: ${_sfml_local}")
  add_subdirectory("${_sfml_local}" "${CMAKE_BINARY_DIR}/sfml-build-local")
else()
  include(FetchContent)
  set(SFML_ZIP_URL
      "https://github.com/SFML/SFML/archive/refs/tags/2.6.2.zip"
      CACHE STRING "SFML 2.6.2 source archive")
  FetchContent_Declare(
    SFML
    URL ${SFML_ZIP_URL}
    DOWNLOAD_EXTRACT_TIMESTAMP OFF)
  FetchContent_MakeAvailable(SFML)
endif()

set(GAME_SOURCES
    src/main.cpp
    src/Game.cpp
    src/Player.cpp
    src/Level.cpp
    src/StarYuan.cpp
    src/Riddle.cpp
    src/RiddleUI.cpp
    src/BossScene.cpp
)

add_executable(star_yuan_game ${GAME_SOURCES})
target_include_directories(star_yuan_game PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/src)
target_link_libraries(star_yuan_game PRIVATE sfml-graphics sfml-window sfml-system)

if(MSVC)
  target_compile_options(star_yuan_game PRIVATE /utf-8)
endif()

add_custom_command(
  TARGET star_yuan_game
  POST_BUILD
  COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_SOURCE_DIR}/assets
          $<TARGET_FILE_DIR:star_yuan_game>/assets
  COMMAND ${CMAKE_COMMAND} -E copy_if_different
          $<TARGET_FILE:sfml-system>
          $<TARGET_FILE_DIR:star_yuan_game>
  COMMAND ${CMAKE_COMMAND} -E copy_if_different
          $<TARGET_FILE:sfml-window>
          $<TARGET_FILE_DIR:star_yuan_game>
  COMMAND ${CMAKE_COMMAND} -E copy_if_different
          $<TARGET_FILE:sfml-graphics>
          $<TARGET_FILE_DIR:star_yuan_game>
  COMMENT "Copy assets and SFML DLLs next to executable")
