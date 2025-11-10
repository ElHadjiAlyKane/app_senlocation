import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: sessionTimeline

    property var sessions: []

    implicitHeight: column.height

    ColumnLayout {
        id: column
        width: parent.width
        spacing: 0

        Repeater {
            model: sessions

            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: sessionItem.height + 16

                RowLayout {
                    id: sessionItem
                    anchors.fill: parent
                    spacing: 16

                    // Timeline indicator
                    Item {
                        Layout.preferredWidth: 40
                        Layout.fillHeight: true

                        // Vertical line
                        Rectangle {
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: 2
                            height: parent.height
                            color: index < sessions.length - 1 ? "#E0E0E0" : "transparent"
                        }

                        // Circle indicator
                        Rectangle {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.top
                            anchors.topMargin: 8
                            width: 16
                            height: 16
                            radius: 8
                            color: getSessionStatusColor(modelData.status)
                            border.color: "#FFFFFF"
                            border.width: 2
                        }
                    }

                    // Session content
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: sessionContent.height + 24
                        radius: 8
                        color: "#F5F5F5"

                        ColumnLayout {
                            id: sessionContent
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 6

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 8

                                Text {
                                    text: "Séance #" + modelData.number
                                    font.pixelSize: 16
                                    font.bold: true
                                    color: "#333333"
                                    Layout.fillWidth: true
                                }

                                Rectangle {
                                    Layout.preferredWidth: statusText.width + 16
                                    Layout.preferredHeight: 22
                                    radius: 11
                                    color: getSessionStatusColor(modelData.status)

                                    Text {
                                        id: statusText
                                        anchors.centerIn: parent
                                        text: getSessionStatusText(modelData.status)
                                        font.pixelSize: 11
                                        font.bold: true
                                        color: "white"
                                    }
                                }
                            }

                            Text {
                                text: "📅 " + modelData.date
                                font.pixelSize: 14
                                color: "#666666"
                            }

                            Text {
                                text: modelData.notes || "Aucune note"
                                font.pixelSize: 13
                                color: "#888888"
                                wrapMode: Text.WordWrap
                                Layout.fillWidth: true
                            }
                        }
                    }
                }
            }
        }
    }

    function getSessionStatusColor(status) {
        const colors = {
            "scheduled": "#2196F3",
            "completed": "#4CAF50",
            "cancelled": "#F44336"
        }
        return colors[status] || "#999999"
    }

    function getSessionStatusText(status) {
        const texts = {
            "scheduled": "Programmée",
            "completed": "Terminée",
            "cancelled": "Annulée"
        }
        return texts[status] || status
    }
}
