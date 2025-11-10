import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: disputeCard

    property var dispute: null
    signal clicked()

    readonly property var severityColors: ({
        "low": "#4CAF50",
        "medium": "#FF9800",
        "high": "#F44336"
    })

    height: 120
    radius: 10
    color: "white"
    border.color: "#E0E0E0"
    border.width: 1

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 8

        // Header with severity badge
        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Text {
                text: dispute ? dispute.title : ""
                font.pixelSize: 17
                font.bold: true
                color: "#333333"
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            Rectangle {
                Layout.preferredWidth: severityLabel.width + 18
                Layout.preferredHeight: 24
                radius: 12
                color: getSeverityColor()

                Text {
                    id: severityLabel
                    anchors.centerIn: parent
                    text: getSeverityText()
                    font.pixelSize: 11
                    font.bold: true
                    color: "white"
                }
            }
        }

        // Description
        Text {
            text: dispute ? dispute.description : ""
            font.pixelSize: 14
            color: "#666666"
            wrapMode: Text.WordWrap
            maximumLineCount: 2
            elide: Text.ElideRight
            Layout.fillWidth: true
        }

        // Footer info
        RowLayout {
            Layout.fillWidth: true
            spacing: 16

            RowLayout {
                spacing: 6

                Text {
                    text: "📅"
                    font.pixelSize: 13
                }

                Text {
                    text: dispute ? dispute.createdDate : ""
                    font.pixelSize: 13
                    color: "#999999"
                }
            }

            Item { Layout.fillWidth: true }

            Rectangle {
                Layout.preferredWidth: statusText.width + 16
                Layout.preferredHeight: 22
                radius: 11
                color: getStatusColor()

                Text {
                    id: statusText
                    anchors.centerIn: parent
                    text: getStatusText()
                    font.pixelSize: 11
                    font.bold: true
                    color: "white"
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
        onClicked: disputeCard.clicked()
    }

    function getSeverityColor() {
        if (!dispute) return "#CCCCCC"
        return severityColors[dispute.severity] || "#CCCCCC"
    }

    function getSeverityText() {
        if (!dispute) return ""
        const texts = {
            "low": "Faible",
            "medium": "Moyen",
            "high": "Élevé"
        }
        return texts[dispute.severity] || dispute.severity
    }

    function getStatusColor() {
        if (!dispute) return "#CCCCCC"
        const colors = {
            "open": "#2196F3",
            "in_mediation": "#FF9800",
            "resolved": "#4CAF50",
            "closed": "#999999"
        }
        return colors[dispute.status] || "#CCCCCC"
    }

    function getStatusText() {
        if (!dispute) return ""
        const texts = {
            "open": "Ouvert",
            "in_mediation": "En médiation",
            "resolved": "Résolu",
            "closed": "Fermé"
        }
        return texts[dispute.status] || dispute.status
    }
}
