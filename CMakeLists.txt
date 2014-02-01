cmake_minimum_required(VERSION 2.8 FATAL_ERROR)

project(qml-drag-drop-list)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTOMOC ON)

find_package(Qt5Quick REQUIRED)

include_directories(src)

set(sources src/main.cpp)

option(ENABLE_QML_DEBUGGING ON)
message(STATUS "QML debugging: ${ENABLE_QML_DEBUGGING}")

if (ENABLE_QML_DEBUGGING)
  set(qml_debugging_helper "${PROJECT_BINARY_DIR}/src/qml/qmldebbuginghelper.cpp")
  file(WRITE ${qml_debugging_helper} "#include <QtQml/QQmlDebuggingEnabler>\nstatic QQmlDebuggingEnabler enabler;\n")
  set(sources ${sources} ${qml_debugging_helper})
endif()

add_executable(${PROJECT_NAME} ${sources})

# looks weird, can anyone tell me how it should be done?
file(COPY src/qml/main.qml
  src/qml/ListItem.qml
  DESTINATION ${PROJECT_BINARY_DIR}/qml)

qt5_use_modules(${PROJECT_NAME} Quick)
