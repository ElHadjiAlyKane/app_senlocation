cmake_minimum_required(VERSION 3.16)

project(SenLocation VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

# Find Qt packages
find_package(Qt5 REQUIRED COMPONENTS Core Quick Network Qml QuickControls2)

# Source files
set(SOURCES
    src/main.cpp
    src/apiclient.cpp
    src/authmanager.cpp
    src/propertymanager.cpp
    src/usermanager.cpp
)

set(HEADERS
    src/apiclient.h
    src/authmanager.h
    src/propertymanager.h
    src/usermanager.h
)

set(RESOURCES
    qml.qrc
)

# Add executable
add_executable(${PROJECT_NAME}
    ${SOURCES}
    ${HEADERS}
    ${RESOURCES}
)

# Link Qt libraries
target_link_libraries(${PROJECT_NAME}
    Qt5::Core
    Qt5::Quick
    Qt5::Network
    Qt5::Qml
    Qt5::QuickControls2
)

# Set target properties
set_target_properties(${PROJECT_NAME} PROPERTIES
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

# Install target
install(TARGETS ${PROJECT_NAME}
    BUNDLE DESTINATION .
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
