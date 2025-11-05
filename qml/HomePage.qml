import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components"

Page {
    id: homePage
    objectName: "homePage"

    header: ToolBar {
        background: Rectangle {
            color: "#4CAF50"
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: 10

            Label {
                text: "SenLocation"
                font.pixelSize: 22
                font.bold: true
                color: "white"
                Layout.fillWidth: true
            }

            ToolButton {
                icon.source: "qrc:/icons/person.png"
                onClicked: profileMenu.open()

                Menu {
                    id: profileMenu
                    y: parent.height

                    MenuItem {
                        text: authManager.userName || "Utilisateur"
                        enabled: false
                    }
                    MenuItem {
                        text: "Profil"
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

    Flickable {
        anchors.fill: parent
        contentHeight: contentColumn.height
        clip: true

        ColumnLayout {
            id: contentColumn
            width: parent.width
            spacing: 0

            // Welcome Section
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 140
                color: "#4CAF50"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 20

                    Text {
                        text: "Bienvenue, " + (authManager.userName || "Utilisateur")
                        font.pixelSize: 24
                        font.bold: true
                        color: "white"
                    }

                    Text {
                        text: getRoleText()
                        font.pixelSize: 16
                        color: "white"
                        opacity: 0.9
                    }
                }
            }

            // Spacing
            Item {
                Layout.fillWidth: true
                Layout.preferredHeight: 20
            }

            // Cards Layout
            ColumnLayout {
                Layout.fillWidth: true
                Layout.leftMargin: 15
                Layout.rightMargin: 15
                spacing: 15

                // Row 1
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 15

                    // Card Propriétés
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 130
                        radius: 10
                        color: "white"
                        border.color: "#E0E0E0"
                        border.width: 1

                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 10

                            Text {
                                text: "🏠"
                                font.pixelSize: 40
                                Layout.alignment: Qt.AlignHCenter
                            }

                            Text {
                                text: "Propriétés"
                                font.pixelSize: 16
                                font.bold: true
                                color: "#333333"
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onPressed: parent.opacity = 0.7
                            onReleased: parent.opacity = 1.0
                            onClicked: {
                                propertyManager.fetchProperties()
                                stackView.push("PropertyListPage.qml")
                            }
                        }
                    }

                    // Card Ajouter (visible si landlord)
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 130
                        radius: 10
                        color: "white"
                        border.color: "#E0E0E0"
                        border.width: 1
                        visible: authManager.userRole === "landlord"

                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 10

                            Text {
                                text: "➕"
                                font.pixelSize: 40
                                Layout.alignment: Qt.AlignHCenter
                            }

                            Text {
                                text: "Ajouter"
                                font.pixelSize: 16
                                font.bold: true
                                color: "#333333"
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onPressed: parent.opacity = 0.7
                            onReleased: parent.opacity = 1.0
                            onClicked: stackView.push("AddPropertyPage.qml")
                        }
                    }

                    // Placeholder si pas landlord
                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 130
                        visible: authManager.userRole !== "landlord"
                    }
                }

                // Row 2
                RowLayout {
                    Layout.fillWidth: true
                    spacing: 15

                    // Card Contrats
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 130
                        radius: 10
                        color: "white"
                        border.color: "#E0E0E0"
                        border.width: 1

                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 10

                            Text {
                                text: "📄"
                                font.pixelSize: 40
                                Layout.alignment: Qt.AlignHCenter
                            }

                            Text {
                                text: "Contrats"
                                font.pixelSize: 16
                                font.bold: true
                                color: "#333333"
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onPressed: parent.opacity = 0.7
                            onReleased: parent.opacity = 1.0
                            onClicked: stackView.push("RentalAgreementPage.qml")
                        }
                    }

                    // Card Profil
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 130
                        radius: 10
                        color: "white"
                        border.color: "#E0E0E0"
                        border.width: 1

                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 10

                            Text {
                                text: "👤"
                                font.pixelSize: 40
                                Layout.alignment: Qt.AlignHCenter
                            }

                            Text {
                                text: "Profil"
                                font.pixelSize: 16
                                font.bold: true
                                color: "#333333"
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onPressed: parent.opacity = 0.7
                            onReleased: parent.opacity = 1.0
                            onClicked: stackView.push("ProfilePage.qml")
                        }
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

    function getRoleText() {
        if (authManager.userRole === "landlord") return "Bailleur"
        if (authManager.userRole === "tenant") return "Locataire"
        if (authManager.userRole === "lawyer") return "Juriste"
        return ""
    }
}
