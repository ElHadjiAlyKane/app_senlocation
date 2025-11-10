import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: contractCard

    property var contract: null
    signal clicked()

    readonly property var statusColors: ({
        "pending": "#FFF3E0",
        "active": "#4CAF50",
        "expired": "#999999",
        "terminated": "#F44336"
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

        // Header
        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Text {
                text: contract ? contract.propertyTitle : ""
                font.pixelSize: 17
                font.bold: true
                color: "#333333"
                elide: Text.ElideRight
                Layout.fillWidth: true
            }

            Rectangle {
                Layout.preferredWidth: statusLabel.width + 18
                Layout.preferredHeight: 24
                radius: 12
                color: getStatusColor()

                Text {
                    id: statusLabel
                    anchors.centerIn: parent
                    text: getStatusText()
                    font.pixelSize: 11
                    font.bold: true
                    color: "white"
                }
            }
        }

        // Tenant/Landlord info
        RowLayout {
            spacing: 8

            Text {
                text: "👤"
                font.pixelSize: 14
            }

            Text {
                text: contract ? (contract.tenantName || contract.landlordName) : ""
                font.pixelSize: 14
                color: "#666666"
                Layout.fillWidth: true
            }
        }

        // Rent amount
        Text {
            text: contract ? formatAmount(contract.monthlyRent) + " FCFA/mois" : ""
            font.pixelSize: 18
            font.bold: true
            color: "#4CAF50"
        }

        // Contract period
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
                    text: contract ? contract.startDate + " - " + contract.endDate : ""
                    font.pixelSize: 13
                    color: "#999999"
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
        onClicked: contractCard.clicked()
    }

    function getStatusColor() {
        if (!contract) return "#CCCCCC"
        return statusColors[contract.status] || "#CCCCCC"
    }

    function getStatusText() {
        if (!contract) return ""
        const texts = {
            "pending": "En attente",
            "active": "Actif",
            "expired": "Expiré",
            "terminated": "Résilié"
        }
        return texts[contract.status] || contract.status
    }

    function formatAmount(amount) {
        return amount.toLocaleString(Qt.locale(), 'f', 0)
    }
}
