import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: statCard

    property string title: ""
    property string value: ""
    property string icon: "📊"
    property color accentColor: "#4CAF50"

    implicitWidth: 200
    implicitHeight: 120
    radius: 12
    color: "white"
    border.color: "#E0E0E0"
    border.width: 1

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        // Icon in colored circle
        Rectangle {
            Layout.preferredWidth: 48
            Layout.preferredHeight: 48
            radius: 24
            color: Qt.rgba(accentColor.r, accentColor.g, accentColor.b, 0.1)

            Text {
                anchors.centerIn: parent
                text: icon
                font.pixelSize: 24
            }
        }

        // Title
        Text {
            text: title
            font.pixelSize: 13
            color: "#666666"
            wrapMode: Text.WordWrap
            Layout.fillWidth: true
        }

        // Value
        Text {
            text: value
            font.pixelSize: 24
            font.bold: true
            color: accentColor
            Layout.fillWidth: true
        }
    }

    // Subtle hover effect
    Rectangle {
        anchors.fill: parent
        radius: parent.radius
        color: accentColor
        opacity: mouseArea.containsMouse ? 0.03 : 0

        Behavior on opacity {
            NumberAnimation {
                duration: 150
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
    }
}
