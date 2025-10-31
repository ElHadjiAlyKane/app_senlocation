import QtQuick 2.15
import QtQuick.Controls 2.15

QtObject {
    // Color palette
    property color primary: "#00853E"
    property color secondary: "#FFC107"
    property color accent: "#2196F3"
    property color error: "#F44336" // Commonly used error color
    property color success: "#4CAF50" // Commonly used success color

    // Text colors
    property color textColor: "#FFFFFF" // For dark mode
    property color headerTextColor: "#E0E0E0" // For dark mode

    // Card styling
    property color cardBackground: "#1E1E1E" // Dark mode background
    property real cardElevation: 4
    property real cardBorderRadius: 8

    // Button styling
    property color buttonBackground: primary
    property color buttonTextColor: "#FFFFFF"
    property real buttonBorderRadius: 4
    property real buttonPadding: 10

    // Animation durations
    property int animationDuration: 200 // in milliseconds

    // Dark Mode specific colors
    property color darkModeBackground: "#121212"
    property color darkModeTextColor: "#FFFFFF"
    property color darkModeCardBackground: "#1E1E1E"
}