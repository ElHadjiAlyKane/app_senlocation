import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components"

Page {
    id: tenantDashboard
    objectName: "tenantDashboard"

    header: ToolBar {
        background: Rectangle {
            color: "#2196F3"
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: 10

            Label {
                text: "Tableau de bord - Locataire"
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
                        text: authManager.userName || "Locataire"
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
                    title: "Loyer mensuel"
                    value: "350K"
                    icon: "💰"
                    accentColor: "#4CAF50"
                }

                StatCard {
                    Layout.fillWidth: true
                    title: "Prochain paiement"
                    value: "5 jours"
                    icon: "📅"
                    accentColor: "#FF9800"
                }

                StatCard {
                    Layout.fillWidth: true
                    title: "Contrat expire"
                    value: "6 mois"
                    icon: "📄"
                    accentColor: "#2196F3"
                }

                StatCard {
                    Layout.fillWidth: true
                    title: "Historique"
                    value: "3 mois"
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
                        text: "💰 Payer mon loyer"
                        primary: true
                        onClicked: stackView.push("PayMyRentPage.qml")
                    }

                    CustomButton {
                        Layout.fillWidth: true
                        text: "📄 Mon contrat"
                        onClicked: stackView.push("MyContractPage.qml")
                    }

                    CustomButton {
                        Layout.fillWidth: true
                        text: "📋 Historique paiements"
                        onClicked: stackView.push("PaymentHistoryPage.qml")
                    }

                    CustomButton {
                        Layout.fillWidth: true
                        text: "⚠️ Créer un litige"
                        onClicked: stackView.push("DisputePage.qml")
                    }

                    CustomButton {
                        Layout.fillWidth: true
                        text: "🔍 Chercher un logement"
                        onClicked: stackView.push("PropertyListPage.qml")
                    }
                }
            }

            // Current Contract
            Rectangle {
                Layout.fillWidth: true
                Layout.margins: 16
                Layout.preferredHeight: contractColumn.height + 32
                radius: 12
                color: "white"

                ColumnLayout {
                    id: contractColumn
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 16

                    Text {
                        text: "Mon contrat actuel"
                        font.pixelSize: 18
                        font.bold: true
                        color: "#333333"
                    }

                    ContractCard {
                        Layout.fillWidth: true
                        contract: {
                            "propertyTitle": "Appartement 2 pièces Sacré-Cœur",
                            "landlordName": "Moussa Ndiaye",
                            "monthlyRent": 350000,
                            "startDate": "2024-06-01",
                            "endDate": "2025-05-31",
                            "status": "active"
                        }
                        onClicked: stackView.push("MyContractPage.qml")
                    }
                }
            }

            Item {
                Layout.preferredHeight: 24
            }
        }
    }
}
