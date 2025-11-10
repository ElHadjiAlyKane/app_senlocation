import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: paymentCard

    property var payment: null
    signal clicked()

    readonly property var statusColors: ({
        "pending": "#FF9800",
        "paid": "#4CAF50",
        "failed": "#F44336",
        "refunded": "#2196F3"
    })

    height: 110
    radius: 10
    color: "white"
    border.color: "#E0E0E0"
    border.width: 1

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 8

        // Header with status
        RowLayout {
            Layout.fillWidth: true
            spacing: 12

            Text {
                text: payment ? payment.paymentType || "Paiement" : ""
                font.pixelSize: 16
                font.bold: true
                color: "#333333"
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

        // Amount
        Text {
            text: payment ? formatAmount(payment.amount) + " FCFA" : ""
            font.pixelSize: 20
            font.bold: true
            color: "#4CAF50"
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
                    text: payment ? payment.paymentDate || payment.dueDate : ""
                    font.pixelSize: 13
                    color: "#999999"
                }
            }

            Item { Layout.fillWidth: true }

            Text {
                text: payment ? payment.paymentMethod || "" : ""
                font.pixelSize: 12
                color: "#666666"
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
        onClicked: paymentCard.clicked()
    }

    function getStatusColor() {
        if (!payment) return "#CCCCCC"
        return statusColors[payment.status] || "#CCCCCC"
    }

    function getStatusText() {
        if (!payment) return ""
        const texts = {
            "pending": "En attente",
            "paid": "Payé",
            "failed": "Échoué",
            "refunded": "Remboursé"
        }
        return texts[payment.status] || payment.status
    }

    function formatAmount(amount) {
        return amount.toLocaleString(Qt.locale(), 'f', 0)
    }
}
