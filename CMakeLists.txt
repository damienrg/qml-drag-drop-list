cmake_minimum_required(VERSION 2.8 FATAL_ERROR)

project(qml-drag-drop-list)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)

find_package(Qt5Quick REQUIRED)

include_directories(src)

set(qml_files
  src/qml/main.qml
  src/qml/ListItem.qml)

set(sources src/main.cpp ${qml_files})

option(ENABLE_QML_DEBUGGING ON)
message(STATUS "QML debugging: ${ENABLE_QML_DEBUGGING}")

if (ENABLE_QML_DEBUGGING)
  set(qml_debugging_helper "${PROJECT_BINARY_DIR}/src/qml/qmldebbuginghelper.cpp")
  file(WRITE ${qml_debugging_helper} "#include <QtQml/QQmlDebuggingEnabler>\nstatic QQmlDebuggingEnabler enabler;\n")
  set(sources ${sources} ${qml_debugging_helper})
endif()


add_custom_command(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/qml/main.qml ${CMAKE_CURRENT_BINARY_DIR}/qml/ListItem.qml
  COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_CURRENT_SOURCE_DIR}/src/qml/main.qml ${CMAKE_CURRENT_BINARY_DIR}/qml/main.qml
  COMMAND ${CMAKE_COMMAND} -E copy_if_different ${CMAKE_CURRENT_SOURCE_DIR}/src/qml/ListItem.qml ${CMAKE_CURRENT_BINARY_DIR}/qml/ListItem.qml
  DEPENDS ${qml_files})

add_executable(${PROJECT_NAME} ${sources}
  ${CMAKE_CURRENT_BINARY_DIR}/qml/main.qml ${CMAKE_CURRENT_BINARY_DIR}/qml/ListItem.qml)

qt5_use_modules(${PROJECT_NAME} Quick)
