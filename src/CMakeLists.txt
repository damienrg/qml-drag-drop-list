find_package(Qt5Quick REQUIRED)

set(qml_files
  qml/main.qml
  qml/ListItem.qml)

set(js_files
   js/logic.js)

set(sources main.cpp ${qml_files} ${js_files})

if (ENABLE_QML_DEBUGGING)
  set(sources ${sources} ${qml_debugging_helper})
endif()

foreach(file ${qml_files} ${js_files})
  add_custom_command(OUTPUT ${CMAKE_BINARY_DIR}/${file}
    COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_SOURCE_DIR}/${file} ${CMAKE_BINARY_DIR}/${file}
    DEPENDS ${file})
  set(output_files ${output_files} ${CMAKE_BINARY_DIR}/${file})
endforeach()

add_executable(${PROJECT_NAME} ${sources} ${output_files})

set_property(TARGET ${PROJECT_NAME}
  PROPERTY RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR})

qt5_use_modules(${PROJECT_NAME} Quick)
