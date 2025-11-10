import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components"

Page {
    id: paymentHistory
    objectName: "paymentHistory"

    header: ToolBar {
        background: Rectangle {
            color: "#2196F3"
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: 10

            ToolButton {
                text: "←"
                onClicked: stackView.pop()
            }

            Label {
                text: "Historique des paiements"
                font.pixelSize: 20
                font.bold: true
                color: "white"
                Layout.fillWidth: true
            }

            ToolButton {
                text: "🔄"
                onClicked: paymentManager.fetchTenantPayments()
            }
        }
    }

    Component.onCompleted: {
        paymentManager.fetchTenantPayments()
    }

    ListView {
        anchors.fill: parent
        spacing: 12
        clip: true

        model: paymentManager.payments

        delegate: PaymentCard {
            width: ListView.view.width - 32
            anchors.horizontalCenter: parent.horizontalCenter
            payment: modelData
            onClicked: console.log("Payment details:", modelData.id)
        }

        header: Item {
            width: parent.width
            height: 16
        }

        footer: Item {
            width: parent.width
            height: 16
        }

        // Empty state
        Rectangle {
            anchors.centerIn: parent
            width: parent.width - 64
            height: emptyColumn.height + 48
            radius: 12
            color: "white"
            visible: paymentManager.payments.length === 0

            ColumnLayout {
                id: emptyColumn
                anchors.centerIn: parent
                spacing: 16

                Text {
                    text: "💰"
                    font.pixelSize: 64
                    Layout.alignment: Qt.AlignHCenter
                }

                Text {
                    text: "Aucun paiement"
                    font.pixelSize: 18
                    font.bold: true
                    color: "#333333"
                    Layout.alignment: Qt.AlignHCenter
                }

                Text {
                    text: "Vous n'avez pas encore effectué de paiements."
                    font.pixelSize: 14
                    color: "#666666"
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }
}
