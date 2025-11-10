import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: mediationCard

    property var mediation: null
    signal clicked()

    readonly property var statusColors: ({
        "pending": "#FFF3E0",
        "in_progress": "#FF9800",
        "success": "#4CAF50",
        "failed": "#F44336",
        "escalated": "#9C27B0"
    })

    height: 140
    radius: 10
    color: "white"
    border.color: "#E0E0E0"
    border.width: 1

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 8

        // Header with status badge
        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Text {
                text: mediation ? "Médiation #" + mediation.id : ""
                font.pixelSize: 18
                font.bold: true
                color: "#333333"
                Layout.fillWidth: true
            }

            Rectangle {
                Layout.preferredWidth: statusLabel.width + 20
                Layout.preferredHeight: 26
                radius: 13
                color: getStatusColor()

                Text {
                    id: statusLabel
                    anchors.centerIn: parent
                    text: getStatusText()
                    font.pixelSize: 12
                    font.bold: true
                    color: "white"
                }
            }
        }

        // Parties
        RowLayout {
            spacing: 8

            Text {
                text: "⚖️"
                font.pixelSize: 14
            }

            Text {
                text: mediation ? mediation.landlordName + " vs " + mediation.tenantName : ""
                font.pixelSize: 14
                color: "#666666"
                elide: Text.ElideRight
                Layout.fillWidth: true
            }
        }

        // Mediator
        RowLayout {
            spacing: 8

            Text {
                text: "👤"
                font.pixelSize: 14
            }

            Text {
                text: mediation ? "Médiateur: " + mediation.mediatorName : ""
                font.pixelSize: 14
                color: "#666666"
                Layout.fillWidth: true
            }
        }

        // Date
        RowLayout {
            spacing: 8

            Text {
                text: "📅"
                font.pixelSize: 14
            }

            Text {
                text: mediation ? "Créé le: " + mediation.createdDate : ""
                font.pixelSize: 14
                color: "#999999"
                Layout.fillWidth: true
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
        onClicked: mediationCard.clicked()
    }

    function getStatusColor() {
        if (!mediation) return "#CCCCCC"
        return statusColors[mediation.status] || "#CCCCCC"
    }

    function getStatusText() {
        if (!mediation) return ""
        const texts = {
            "pending": "En attente",
            "in_progress": "En cours",
            "success": "Réussie",
            "failed": "Échouée",
            "escalated": "Escaladée"
        }
        return texts[mediation.status] || mediation.status
    }
}
