import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components"

Page {
    id: payMyRentPage

    property var currentRent: null
    property var paymentHistory: []

    header: ToolBar {
        background: Rectangle {
            color: "#4CAF50"
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: 10

            ToolButton {
                text: "←"
                font.pixelSize: 24
                onClicked: stackView.pop()
            }

            Label {
                text: "Payer ma location"
                font.pixelSize: 20
                font.bold: true
                color: "white"
                Layout.fillWidth: true
            }
        }
    }

    background: Rectangle {
        color: "#f5f5f5"
    }

    Component.onCompleted: {
        paymentManager.fetchTenantPayments()
        updatePaymentData()
    }

    Connections {
        target: paymentManager
        function onPaymentsChanged() {
            updatePaymentData()
        }
    }

    Flickable {
        anchors.fill: parent
        contentHeight: contentColumn.height
        clip: true

        ColumnLayout {
            id: contentColumn
            width: parent.width
            spacing: 15

            // Spacing
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 15
            }

            // Current rent section
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: currentRentColumn.height + 30
                Layout.leftMargin: 15
                Layout.rightMargin: 15
                radius: 10
                color: "white"
                border.color: "#E0E0E0"
                border.width: 1

                ColumnLayout {
                    id: currentRentColumn
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 10

                    Text {
                        text: "Loyer du mois"
                        font.pixelSize: 18
                        font.bold: true
                        color: "#333333"
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 1
                        color: "#E0E0E0"
                    }

                    property var currentRent: payMyRentPage.currentRent

                    Text {
                        text: currentRentColumn.currentRent ? currentRentColumn.currentRent.propertyName : ""
                        font.pixelSize: 16
                        font.bold: true
                        color: "#333333"
                    }

                    Text {
                        text: currentRentColumn.currentRent ? "Propriétaire: " + currentRentColumn.currentRent.landlordName : ""
                        font.pixelSize: 14
                        color: "#666666"
                    }

                    Item { Layout.preferredHeight: 5 }

                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Loyer:"
                            font.pixelSize: 14
                            color: "#666666"
                            Layout.fillWidth: true
                        }

                        Text {
                            text: currentRentColumn.currentRent ? formatAmount(currentRentColumn.currentRent.amount) + " FCFA" : ""
                            font.pixelSize: 14
                            font.bold: true
                            color: "#333333"
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Taxe (5%):"
                            font.pixelSize: 14
                            color: "#666666"
                            Layout.fillWidth: true
                        }

                        Text {
                            text: currentRentColumn.currentRent ? formatAmount(currentRentColumn.currentRent.tax) + " FCFA" : ""
                            font.pixelSize: 14
                            color: "#666666"
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 1
                        color: "#E0E0E0"
                    }

                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Total à payer:"
                            font.pixelSize: 16
                            font.bold: true
                            color: "#333333"
                            Layout.fillWidth: true
                        }

                        Text {
                            text: currentRentColumn.currentRent ? formatAmount(currentRentColumn.currentRent.total) + " FCFA" : ""
                            font.pixelSize: 18
                            font.bold: true
                            color: "#4CAF50"
                        }
                    }
                }
            }

            // Payment buttons section
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: paymentButtonsColumn.height + 30
                Layout.leftMargin: 15
                Layout.rightMargin: 15
                radius: 10
                color: "white"
                border.color: "#E0E0E0"
                border.width: 1

                ColumnLayout {
                    id: paymentButtonsColumn
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 15

                    Text {
                        text: "Choisir un mode de paiement"
                        font.pixelSize: 16
                        font.bold: true
                        color: "#333333"
                    }

                    // Wave button
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 60
                        radius: 8
                        color: "#01E3C3"

                        RowLayout {
                            anchors.centerIn: parent
                            spacing: 15

                            Text {
                                text: "🌊"
                                font.pixelSize: 30
                            }

                            Text {
                                text: "Payer avec Wave"
                                font.pixelSize: 18
                                font.bold: true
                                color: "white"
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onPressed: parent.opacity = 0.7
                            onReleased: parent.opacity = 1.0
                            onClicked: showPaymentConfirmation("Wave")
                        }
                    }

                    // Orange Money button
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 60
                        radius: 8
                        color: "#FF7900"

                        RowLayout {
                            anchors.centerIn: parent
                            spacing: 15

                            Text {
                                text: "🍊"
                                font.pixelSize: 30
                            }

                            Text {
                                text: "Payer avec Orange Money"
                                font.pixelSize: 18
                                font.bold: true
                                color: "white"
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onPressed: parent.opacity = 0.7
                            onReleased: parent.opacity = 1.0
                            onClicked: showPaymentConfirmation("Orange Money")
                        }
                    }
                }
            }

            // Payment history section
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: historyColumn.height + 30
                Layout.leftMargin: 15
                Layout.rightMargin: 15
                radius: 10
                color: "white"
                border.color: "#E0E0E0"
                border.width: 1

                ColumnLayout {
                    id: historyColumn
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 15

                    Text {
                        text: "Historique des paiements"
                        font.pixelSize: 16
                        font.bold: true
                        color: "#333333"
                    }

                    ListView {
                        id: historyList
                        Layout.fillWidth: true
                        Layout.preferredHeight: contentHeight
                        spacing: 10
                        interactive: false

                        model: payMyRentPage.paymentHistory

                        delegate: Rectangle {
                            width: historyList.width
                            height: 90
                            radius: 8
                            color: "#f9f9f9"
                            border.color: "#E0E0E0"
                            border.width: 1

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 12
                                spacing: 12

                                // Payment method icon
                                Rectangle {
                                    Layout.preferredWidth: 45
                                    Layout.preferredHeight: 45
                                    radius: 23
                                    color: modelData.paymentMethod === "Wave" ? "#01E3C3" : "#FF7900"

                                    Text {
                                        anchors.centerIn: parent
                                        text: modelData.paymentMethod === "Wave" ? "🌊" : "🍊"
                                        font.pixelSize: 22
                                    }
                                }

                                // Payment info
                                ColumnLayout {
                                    Layout.fillWidth: true
                                    spacing: 4

                                    Text {
                                        text: modelData.paymentType
                                        font.pixelSize: 14
                                        font.bold: true
                                        color: "#333333"
                                    }

                                    Text {
                                        text: formatAmount(modelData.total) + " FCFA"
                                        font.pixelSize: 15
                                        color: "#4CAF50"
                                        font.bold: true
                                    }

                                    Text {
                                        text: modelData.paymentMethod + " • " + Qt.formatDate(new Date(modelData.paymentDate), "dd MMM yyyy")
                                        font.pixelSize: 12
                                        color: "#999999"
                                    }
                                }

                                // Status
                                Rectangle {
                                    Layout.preferredWidth: 60
                                    Layout.preferredHeight: 26
                                    radius: 13
                                    color: "#E8F5E9"

                                    Text {
                                        anchors.centerIn: parent
                                        text: "✓ Payé"
                                        font.pixelSize: 11
                                        font.bold: true
                                        color: "#4CAF50"
                                    }
                                }
                            }
                        }
                    }

                    // Empty state
                    Text {
                        visible: historyList.count === 0
                        text: "Aucun paiement effectué"
                        font.pixelSize: 14
                        color: "#999999"
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }

            // Bottom spacing
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 20
            }
        }
    }

    // Payment confirmation dialog
    Dialog {
        id: confirmationDialog
        title: "Confirmer le paiement"
        modal: true
        anchors.centerIn: parent
        standardButtons: Dialog.Cancel | Dialog.Ok

        property string paymentMethod: ""

        ColumnLayout {
            spacing: 10
            width: 300

            Text {
                text: "Vous allez payer avec " + confirmationDialog.paymentMethod
                font.pixelSize: 14
                color: "#333333"
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }

            property var currentRent: payMyRentPage.currentRent

            Text {
                text: "Montant: " + formatAmount(confirmationDialog.currentRent ? confirmationDialog.currentRent.total : 0) + " FCFA"
                font.pixelSize: 16
                font.bold: true
                color: "#4CAF50"
            }
        }

        onAccepted: {
            // Show success dialog
            successDialog.open()
        }
    }

    // Success dialog
    Dialog {
        id: successDialog
        title: "Paiement réussi"
        modal: true
        anchors.centerIn: parent
        standardButtons: Dialog.Ok

        ColumnLayout {
            spacing: 15
            width: 300

            Text {
                text: "✓"
                font.pixelSize: 60
                color: "#4CAF50"
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                text: "Votre paiement a été effectué avec succès!"
                font.pixelSize: 16
                color: "#333333"
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
            }

            Text {
                text: "(Mode démo - Aucun paiement réel n'a été effectué)"
                font.pixelSize: 12
                color: "#999999"
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
                horizontalAlignment: Text.AlignHCenter
            }
        }

        onAccepted: {
            // Refresh payment list
            paymentManager.fetchTenantPayments()
        }
    }

    function updatePaymentData() {
        // Update current rent
        if (paymentManager.payments.length > 0) {
            var payment = paymentManager.payments[0]
            if (payment.status === "En attente") {
                currentRent = payment
            } else {
                currentRent = null
            }
        } else {
            currentRent = null
        }
        
        // Update payment history
        var history = []
        for (var i = 0; i < paymentManager.payments.length; i++) {
            var p = paymentManager.payments[i]
            if (p.status === "Payé") {
                history.push(p)
            }
        }
        paymentHistory = history
    }

    function showPaymentConfirmation(method) {
        confirmationDialog.paymentMethod = method
        confirmationDialog.open()
    }

    function formatAmount(amount) {
        return amount.toLocaleString(Qt.locale(), 'f', 0)
    }
}
