# Build Instructions for SenLocation Mobile App

## Prerequisites

### Linux (Ubuntu/Debian)
```bash
sudo apt-get update
sudo apt-get install -y \
    qt5-default \
    qt5-qmake \
    qtbase5-dev \
    qtdeclarative5-dev \
    qtquickcontrols2-5-dev \
    libqt5network5 \
    build-essential
```

### macOS
```bash
brew install qt@5
export PATH="/usr/local/opt/qt@5/bin:$PATH"
```

### Windows
Download and install Qt from https://www.qt.io/download
- Select Qt 5.15 or later
- Include Qt Quick Controls 2
- Include MinGW or MSVC compiler

## Building the Application

### Method 1: Using qmake (Recommended)

```bash
# Navigate to project directory
cd app_senlocation

# Generate Makefile
qmake SenLocation.pro

# Build
make

# Run
./SenLocation
```

### Method 2: Using CMake

```bash
# Navigate to project directory
cd app_senlocation

# Create build directory
mkdir build && cd build

# Configure
cmake ..

# Build
cmake --build .

# Run
./SenLocation
```

### Method 3: Using Qt Creator (GUI)

1. Open Qt Creator
2. File → Open File or Project
3. Select `SenLocation.pro`
4. Configure your kit (Desktop, Android, or iOS)
5. Click the green play button to build and run

## Building for Mobile Platforms

### Android

1. Install Android SDK and NDK
2. Configure Qt for Android in Qt Creator
3. Open `SenLocation.pro` in Qt Creator
4. Select Android kit
5. Build → Build APK

Or via command line:
```bash
# Set environment variables
export ANDROID_SDK_ROOT=/path/to/android-sdk
export ANDROID_NDK_ROOT=/path/to/android-ndk

# Build
qmake SenLocation.pro -spec android-clang
make
make apk
```

### iOS

1. Open project in Qt Creator on macOS
2. Configure iOS kit
3. Select iOS device or simulator
4. Build and run

Or via command line:
```bash
qmake SenLocation.pro -spec macx-ios-clang CONFIG+=iphoneos CONFIG+=device
make
```

## Configuration

### API URL Configuration

Edit `src/main.cpp` to change the API endpoint:

```cpp
ApiClient apiClient("https://your-api-url.com");
```

### Build Configurations

#### Debug Build
```bash
qmake CONFIG+=debug
make
```

#### Release Build
```bash
qmake CONFIG+=release
make
```

#### With Verbose Output
```bash
make VERBOSE=1
```

## Troubleshooting

### Qt not found
Make sure Qt is in your PATH:
```bash
export PATH=/path/to/qt/bin:$PATH
export LD_LIBRARY_PATH=/path/to/qt/lib:$LD_LIBRARY_PATH
```

### Missing Qt modules
Install required Qt modules:
```bash
# Ubuntu/Debian
sudo apt-get install qtquickcontrols2-5-dev

# macOS
brew install qt5
```

### Build errors
Clean and rebuild:
```bash
make clean
qmake
make
```

## Running the Application

### Desktop
```bash
./SenLocation
```

### Android
Install the generated APK on your device:
```bash
adb install -r android-build/build/outputs/apk/debug/android-build-debug.apk
```

### iOS
Deploy through Xcode or Qt Creator

## Development

### File Structure
- `src/` - C++ source and header files
- `qml/` - QML UI files
- `qml/components/` - Reusable QML components
- `qml.qrc` - Qt Resource file
- `SenLocation.pro` - qmake project file
- `CMakeLists.txt` - CMake project file

### Adding New Files

When adding new C++ files, update `SenLocation.pro`:
```qmake
SOURCES += src/newfile.cpp
HEADERS += src/newfile.h
```

When adding new QML files, update `qml.qrc`:
```xml
<file>qml/NewPage.qml</file>
```

### Code Style
- Use C++17 features
- Follow Qt naming conventions
- Use signals and slots for communication
- Keep QML files focused and modular

## Testing

Currently, there are no automated tests. Future implementations should include:
- Unit tests with Qt Test framework
- UI tests with Qt Quick Test
- Integration tests for API communication

## Deployment

### Desktop Applications
Use Qt's deployment tools:
```bash
# Linux
/path/to/qt/bin/linuxdeployqt SenLocation

# macOS
/path/to/qt/bin/macdeployqt SenLocation.app

# Windows
/path/to/qt/bin/windeployqt.exe SenLocation.exe
```

### Mobile Applications
Follow platform-specific guidelines for app store deployment.
