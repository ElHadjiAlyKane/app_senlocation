import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components"

Page {
    id: homePage

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
                        text: authManager.userName
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

    ScrollView {
        anchors.fill: parent

        ColumnLayout {
            width: parent.width
            spacing: 20

            // Welcome Section
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 120
                color: "#4CAF50"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 20

                    Text {
                        text: "Bienvenue, " + authManager.userName
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

            // Quick Actions
            GridLayout {
                Layout.fillWidth: true
                Layout.margins: 20
                columns: 2
                rowSpacing: 15
                columnSpacing: 15

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 120
                    radius: 10
                    color: "white"
                    
                    border.color: "#E0E0E0"
                    border.width: 1

                    ColumnLayout {
                        anchors.centerIn: parent
                        spacing: 10

                        Text {
                            text: "📋"
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
                        onClicked: {
                            propertyManager.fetchProperties()
                            stackView.push("PropertyListPage.qml")
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 120
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
                        onClicked: stackView.push("AddPropertyPage.qml")
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 120
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
                        onClicked: stackView.push("RentalAgreementPage.qml")
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 120
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
                        onClicked: stackView.push("ProfilePage.qml")
                    }
                }
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
