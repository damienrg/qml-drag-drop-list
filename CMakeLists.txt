cmake_minimum_required(VERSION 2.8 FATAL_ERROR)

project(qml-drag-drop-list)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)

option(ENABLE_QML_DEBUGGING ON)
message(STATUS "QML debugging: ${ENABLE_QML_DEBUGGING}")

if (ENABLE_QML_DEBUGGING)
  set(qml_debugging_helper ${PROJECT_BINARY_DIR}/src/qml/qmldebbuginghelper.cpp)
  file(WRITE ${qml_debugging_helper} "#include <QtQml/QQmlDebuggingEnabler>\nstatic QQmlDebuggingEnabler enabler;\n")
endif()

add_subdirectory(src)
