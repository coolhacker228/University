cmake_minimum_required(VERSION 2.8.12)

project(Lab_01)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

add_subdirectory(lib)
add_subdirectory(gui)
add_subdirectory(tests)

find_package(Qt5 COMPONENTS Quick REQUIRED)
qt5_add_resources(RESOURCES resources.qrc)

add_executable(${PROJECT_NAME} "main.cpp" ${RESOURCES})
target_link_libraries(${PROJECT_NAME} Lab_01_gui Qt5::Quick)
