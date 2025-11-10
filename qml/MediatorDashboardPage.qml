import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components"

Page {
    id: mediatorDashboard
    objectName: "mediatorDashboard"

    header: ToolBar {
        background: Rectangle {
            color: "#9C27B0"
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: 10

            Label {
                text: "Tableau de bord - Médiateur"
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
                        text: authManager.userName || "Médiateur"
                        enabled: false
                    }
                    MenuItem {
                        text: "Mon profil"
                        onTriggered: stackView.push("MediatorProfilePage.qml")
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
                    title: "Médiations actives"
                    value: "3"
                    icon: "⚖️"
                    accentColor: "#FF9800"
                }

                StatCard {
                    Layout.fillWidth: true
                    title: "Médiations réussies"
                    value: "12"
                    icon: "✅"
                    accentColor: "#4CAF50"
                }

                StatCard {
                    Layout.fillWidth: true
                    title: "Taux de succès"
                    value: "85%"
                    icon: "📊"
                    accentColor: "#2196F3"
                }

                StatCard {
                    Layout.fillWidth: true
                    title: "Note moyenne"
                    value: "4.7"
                    icon: "⭐"
                    accentColor: "#FFB300"
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
                        text: "📋 Mes médiations"
                        primary: true
                        onClicked: stackView.push("MediationListPage.qml")
                    }

                    CustomButton {
                        Layout.fillWidth: true
                        text: "🔍 Litiges éligibles"
                        onClicked: {
                            mediationManager.fetchEligibleDisputes()
                            stackView.push("MediationListPage.qml", {showEligible: true})
                        }
                    }

                    CustomButton {
                        Layout.fillWidth: true
                        text: "📊 Générer un rapport"
                        onClicked: stackView.push("MediationReportPage.qml")
                    }
                }
            }

            // Recent Mediations
            Rectangle {
                Layout.fillWidth: true
                Layout.margins: 16
                Layout.preferredHeight: recentColumn.height + 32
                radius: 12
                color: "white"

                ColumnLayout {
                    id: recentColumn
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 16

                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Médiations récentes"
                            font.pixelSize: 18
                            font.bold: true
                            color: "#333333"
                            Layout.fillWidth: true
                        }

                        Button {
                            text: "Voir tout"
                            flat: true
                            onClicked: stackView.push("MediationListPage.qml")
                        }
                    }

                    ListView {
                        Layout.fillWidth: true
                        Layout.preferredHeight: contentHeight
                        spacing: 12
                        interactive: false
                        model: ListModel {
                            ListElement {
                                id: 1
                                landlordName: "Amadou Diop"
                                tenantName: "Fatou Sall"
                                mediatorName: "Me. Ousmane Sarr"
                                status: "in_progress"
                                createdDate: "2025-11-01"
                            }
                            ListElement {
                                id: 2
                                landlordName: "Moussa Ndiaye"
                                tenantName: "Awa Kane"
                                mediatorName: "Me. Ousmane Sarr"
                                status: "success"
                                createdDate: "2025-10-28"
                            }
                        }

                        delegate: MediationCard {
                            width: ListView.view.width
                            mediation: model
                            onClicked: stackView.push("MediationDetailPage.qml", {mediationId: model.id})
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
