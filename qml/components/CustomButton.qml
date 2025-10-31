import QtQuick 2.15
import QtQuick.Controls 2.15

Button {
    id: customButton

    property bool primary: false

    height: 50

    contentItem: Text {
        text: customButton.text
        font.pixelSize: 16
        font.bold: true
        color: primary ? "white" : "#4CAF50"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    background: Rectangle {
        radius: 25
        color: {
            if (!customButton.enabled) {
                return "#CCCCCC"
            }
            if (customButton.pressed) {
                return primary ? "#388E3C" : "#E8F5E9"
            }
            if (customButton.hovered) {
                return primary ? "#43A047" : "#F1F8E9"
            }
            return primary ? "#4CAF50" : "white"
        }
        border.color: primary ? "transparent" : "#4CAF50"
        border.width: primary ? 0 : 2

        Behavior on color {
            ColorAnimation {
                duration: 200
            }
        }
    }

    HoverHandler {
        cursorShape: Qt.PointingHandCursor
    }
}
