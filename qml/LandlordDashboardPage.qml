import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components"

Page {
    id: landlordDashboard
    objectName: "landlordDashboard"

    header: ToolBar {
        background: Rectangle {
            color: "#4CAF50"
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: 10

            Label {
                text: "Tableau de bord - Bailleur"
                font.pixelSize: 20
                font.bold: true
                color: "white"
                Layout.fillWidth: true
            }

            ToolButton {
                text: "👤"
                onClicked: profileMenu.open()

                Menu {
                    id: profileMenu
                    y: parent.height

                    MenuItem {
                        text: authManager.userName || "Bailleur"
                        enabled: false
                    }
                    MenuItem {
                        text: "Mon profil"
                        onTriggered: stackView.push("ProfilePage.qml")
                    }
                    MenuSeparator {}
                    MenuItem {
                        text: "Déconnexion"
                        onTriggered: authManager.logout()
                    }
                }
            }
        }
    }

    background: Rectangle {
        color: "#f5f5f5"
    }

    ScrollView {
        anchors.fill: parent
        contentWidth: availableWidth
        clip: true

        ColumnLayout {
            width: parent.width
            spacing: 24

            // Statistics Cards
            GridLayout {
                Layout.fillWidth: true
                Layout.margins: 16
                columns: 2
                rowSpacing: 16
                columnSpacing: 16

                StatCard {
                    Layout.fillWidth: true
                    title: "Propriétés actives"
                    value: "5"
                    icon: "🏠"
                    accentColor: "#4CAF50"
                }

                StatCard {
                    Layout.fillWidth: true
                    title: "Contrats actifs"
                    value: "3"
                    icon: "📄"
                    accentColor: "#2196F3"
                }

                StatCard {
                    Layout.fillWidth: true
                    title: "Revenus ce mois"
                    value: "1.2M"
                    icon: "💰"
                    accentColor: "#FF9800"
                }

                StatCard {
                    Layout.fillWidth: true
                    title: "Taux occupation"
                    value: "75%"
                    icon: "📊"
                    accentColor: "#9C27B0"
                }
            }

            // Quick Actions
            Rectangle {
                Layout.fillWidth: true
                Layout.margins: 16
                Layout.preferredHeight: actionsColumn.height + 32
                radius: 12
                color: "white"

                ColumnLayout {
                    id: actionsColumn
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 12

                    Text {
                        text: "Actions rapides"
                        font.pixelSize: 18
                        font.bold: true
                        color: "#333333"
                    }

                    CustomButton {
                        Layout.fillWidth: true
                        text: "🏠 Mes propriétés"
                        primary: true
                        onClicked: stackView.push("MyPropertiesPage.qml")
                    }

                    CustomButton {
                        Layout.fillWidth: true
                        text: "+ Ajouter une propriété"
                        onClicked: stackView.push("AddPropertyPage.qml")
                    }

                    CustomButton {
                        Layout.fillWidth: true
                        text: "💰 Paiements reçus"
                        onClicked: stackView.push("PaymentsReceivedDetailPage.qml")
                    }

                    CustomButton {
                        Layout.fillWidth: true
                        text: "📋 Initier un contrat"
                        onClicked: stackView.push("ContractInitiatePage.qml")
                    }
                }
            }

            // Recent Payments
            Rectangle {
                Layout.fillWidth: true
                Layout.margins: 16
                Layout.preferredHeight: paymentsColumn.height + 32
                radius: 12
                color: "white"

                ColumnLayout {
                    id: paymentsColumn
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 16

                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Paiements récents"
                            font.pixelSize: 18
                            font.bold: true
                            color: "#333333"
                            Layout.fillWidth: true
                        }

                        Button {
                            text: "Voir tout"
                            flat: true
                            onClicked: stackView.push("PaymentsReceivedDetailPage.qml")
                        }
                    }

                    ListView {
                        Layout.fillWidth: true
                        Layout.preferredHeight: contentHeight
                        spacing: 12
                        interactive: false
                        model: ListModel {
                            ListElement {
                                paymentType: "Loyer Novembre"
                                amount: 800000
                                status: "paid"
                                paymentDate: "2025-11-05"
                                paymentMethod: "Wave"
                            }
                            ListElement {
                                paymentType: "Loyer Novembre"
                                amount: 200000
                                status: "paid"
                                paymentDate: "2025-11-03"
                                paymentMethod: "Orange Money"
                            }
                        }

                        delegate: PaymentCard {
                            width: ListView.view.width
                            payment: model
                            onClicked: console.log("Payment clicked:", model.id)
                        }
                    }
                }
            }

            Item {
                Layout.preferredHeight: 24
            }
        }
    }
}
