import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: propertyCard

    property var modelData: null

    signal clicked()

    height: 150
    radius: 10
    color: "white"
    border.color: "#E0E0E0"
    border.width: 1

    RowLayout {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 15

        // Image placeholder
        Rectangle {
            Layout.preferredWidth: 120
            Layout.fillHeight: true
            radius: 8
            color: "#CCCCCC"

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
            spacing: 8

            Text {
                text: modelData ? modelData.title : ""
                font.pixelSize: 18
                font.bold: true
                color: "#333333"
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            Text {
                text: modelData ? modelData.address : ""
                font.pixelSize: 14
                color: "#666666"
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            RowLayout {
                spacing: 10

                Text {
                    text: modelData ? "🛏️ " + modelData.bedrooms : ""
                    font.pixelSize: 14
                    color: "#666666"
                }

                Text {
                    text: modelData ? "🚿 " + modelData.bathrooms : ""
                    font.pixelSize: 14
                    color: "#666666"
                }

                Text {
                    text: modelData ? "📐 " + modelData.area + " m²" : ""
                    font.pixelSize: 14
                    color: "#666666"
                }
            }

            Text {
                text: modelData ? modelData.price + " FCFA/mois" : ""
                font.pixelSize: 16
                font.bold: true
                color: "#4CAF50"
            }

            Rectangle {
                Layout.preferredWidth: 80
                Layout.preferredHeight: 24
                radius: 12
                color: modelData && modelData.available ? "#E8F5E9" : "#FFEBEE"
                visible: modelData

                Text {
                    anchors.centerIn: parent
                    text: modelData && modelData.available ? "Disponible" : "Occupé"
                    font.pixelSize: 12
                    color: modelData && modelData.available ? "#4CAF50" : "#F44336"
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: propertyCard.clicked()
    }

    // Hover effect
    Rectangle {
        anchors.fill: parent
        radius: parent.radius
        color: "#000000"
        opacity: mouseArea.containsMouse ? 0.05 : 0

        Behavior on opacity {
            NumberAnimation {
                duration: 200
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            hoverEnabled: true
            propagateComposedEvents: true
            onClicked: propertyCard.clicked()
        }
    }
}
