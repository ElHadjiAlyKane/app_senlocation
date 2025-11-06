import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: propertyCard

    property var modelData: null

    signal clicked()

    height: 160
    radius: 10
    color: "white"
    border.color: "#E0E0E0"
    border.width: 1

    RowLayout {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        // Image placeholder
        Rectangle {
            Layout.preferredWidth: 100
            Layout.preferredHeight: 136
            radius: 8
            color: getPropertyColor()

            Text {
                anchors.centerIn: parent
                text: "🏠"
                font.pixelSize: 48
            }
        }

        // Property info
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 6

            Text {
                text: modelData ? modelData.title : ""
                font.pixelSize: 17
                font.bold: true
                color: "#333333"
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            RowLayout {
                spacing: 5

                Text {
                    text: "📍"
                    font.pixelSize: 14
                }

                Text {
                    text: modelData ? modelData.address : ""
                    font.pixelSize: 14
                    color: "#666666"
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }
            }

            Text {
                text: modelData ? formatAmount(modelData.price) + " FCFA/mois" : ""
                font.pixelSize: 19
                font.bold: true
                color: "#4CAF50"
            }

            RowLayout {
                spacing: 10

                Text {
                    text: modelData ? "🛏️ " + modelData.bedrooms : ""
                    font.pixelSize: 14
                    color: "#666666"
                }

                Text {
                    text: "|"
                    font.pixelSize: 14
                    color: "#CCCCCC"
                }

                Text {
                    text: modelData ? "🚿 " + modelData.bathrooms : ""
                    font.pixelSize: 14
                    color: "#666666"
                }

                Text {
                    text: "|"
                    font.pixelSize: 14
                    color: "#CCCCCC"
                }

                Text {
                    text: modelData ? "📐 " + modelData.area + " m²" : ""
                    font.pixelSize: 14
                    color: "#666666"
                }
            }

            Rectangle {
                Layout.preferredWidth: statusText.width + 20
                Layout.preferredHeight: 24
                radius: 12
                color: modelData && modelData.available ? "#E8F5E9" : "#F5F5F5"
                visible: modelData

                Text {
                    id: statusText
                    anchors.centerIn: parent
                    text: modelData && modelData.available ? "✓ Disponible" : "✗ Occupé"
                    font.pixelSize: 12
                    font.bold: true
                    color: modelData && modelData.available ? "#4CAF50" : "#999999"
                }
            }
        }
    }

    // Click effect overlay
    Rectangle {
        anchors.fill: parent
        radius: parent.radius
        color: "#000000"
        opacity: mouseArea.pressed ? 0.1 : (mouseArea.containsMouse ? 0.05 : 0)

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
        cursorShape: Qt.PointingHandCursor
        onClicked: propertyCard.clicked()
    }

    function getPropertyColor() {
        if (!modelData) return "#CCCCCC"
        
        // Different colors based on property type
        var colors = {
            "appartement": "#E3F2FD",
            "villa": "#FFF3E0",
            "studio": "#F3E5F5",
            "maison": "#E8F5E9"
        }
        
        return colors[modelData.type] || "#CCCCCC"
    }

    function formatAmount(amount) {
        return amount.toLocaleString(Qt.locale(), 'f', 0)
    }
}
