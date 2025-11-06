import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components"

Page {
    id: paymentsReceivedPage

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
                text: "Paiements reçus"
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
        paymentManager.fetchReceivedPayments()
    }

    Flickable {
        anchors.fill: parent
        contentHeight: contentColumn.height
        clip: true

        ColumnLayout {
            id: contentColumn
            width: parent.width
            spacing: 0

            // Total section
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 100
                color: "#4CAF50"

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 5

                    Text {
                        text: "Total reçu"
                        font.pixelSize: 16
                        color: "white"
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: calculateTotal() + " FCFA"
                        font.pixelSize: 28
                        font.bold: true
                        color: "white"
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }

            // Payments List
            ListView {
                id: paymentsList
                Layout.fillWidth: true
                Layout.preferredHeight: contentHeight
                Layout.margins: 15
                spacing: 10
                interactive: false

                model: paymentManager.payments

                delegate: Rectangle {
                    width: paymentsList.width
                    height: 150
                    radius: 10
                    color: "white"
                    border.color: "#E0E0E0"
                    border.width: 1

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 15
                        spacing: 15

                        // Payment method logo
                        Rectangle {
                            Layout.preferredWidth: 60
                            Layout.preferredHeight: 60
                            radius: 30
                            color: modelData.paymentMethod === "Wave" ? "#01E3C3" : "#FF7900"

                            Text {
                                anchors.centerIn: parent
                                text: modelData.paymentMethod === "Wave" ? "🌊" : "🍊"
                                font.pixelSize: 30
                            }
                        }

                        // Payment info
                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 5

                            Text {
                                text: modelData.tenantName
                                font.pixelSize: 16
                                font.bold: true
                                color: "#333333"
                            }

                            Text {
                                text: modelData.propertyName
                                font.pixelSize: 14
                                color: "#666666"
                                elide: Text.ElideRight
                                Layout.fillWidth: true
                            }

                            Text {
                                text: modelData.paymentType
                                font.pixelSize: 13
                                color: "#888888"
                            }

                            RowLayout {
                                spacing: 10

                                Text {
                                    text: modelData.paymentMethod
                                    font.pixelSize: 12
                                    color: "#666666"
                                }

                                Text {
                                    text: "•"
                                    color: "#CCCCCC"
                                }

                                Text {
                                    text: Qt.formatDate(new Date(modelData.paymentDate), "dd MMM yyyy")
                                    font.pixelSize: 12
                                    color: "#666666"
                                }
                            }
                        }

                        // Amount
                        ColumnLayout {
                            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                            spacing: 3

                            Text {
                                text: formatAmount(modelData.totalReceived) + " FCFA"
                                font.pixelSize: 18
                                font.bold: true
                                color: "#4CAF50"
                                Layout.alignment: Qt.AlignRight
                            }

                            Text {
                                text: "dont taxe " + formatAmount(modelData.tax) + " FCFA"
                                font.pixelSize: 11
                                color: "#999999"
                                Layout.alignment: Qt.AlignRight
                            }
                        }
                    }
                }
            }

            // Empty state
            Text {
                visible: paymentsList.count === 0
                text: "Aucun paiement reçu"
                font.pixelSize: 16
                color: "#999999"
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 50
            }

            // Bottom spacing
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 20
            }
        }
    }

    function calculateTotal() {
        var total = 0.0
        for (var i = 0; i < paymentManager.payments.length; i++) {
            var payment = paymentManager.payments[i]
            total += payment.totalReceived || 0
        }
        return formatAmount(total)
    }

    function formatAmount(amount) {
        return amount.toLocaleString(Qt.locale(), 'f', 0)
    }
}
