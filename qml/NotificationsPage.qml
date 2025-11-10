import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components"

Page {
    id: notificationsPage
    objectName: "notificationsPage"

    header: ToolBar {
        background: Rectangle {
            color: "#4CAF50"
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: 10

            ToolButton {
                text: "←"
                onClicked: stackView.pop()
            }

            Label {
                text: "Notifications"
                font.pixelSize: 20
                font.bold: true
                color: "white"
                Layout.fillWidth: true
            }

            ToolButton {
                text: "✓"
                onClicked: markAllAsRead()
            }
        }
    }

    ListView {
        anchors.fill: parent
        spacing: 0
        clip: true

        model: ListModel {
            ListElement {
                icon: "💰"
                title: "Paiement reçu"
                message: "Fatou Sall a payé le loyer de Novembre"
                time: "Il y a 2 heures"
                read: false
                type: "payment"
            }
            ListElement {
                icon: "📄"
                title: "Nouveau contrat"
                message: "Un nouveau contrat attend votre validation"
                time: "Il y a 5 heures"
                read: false
                type: "contract"
            }
            ListElement {
                icon: "⚠️"
                title: "Litige créé"
                message: "Un litige a été créé pour la propriété Villa Mermoz"
                time: "Hier"
                read: true
                type: "dispute"
            }
            ListElement {
                icon: "⚖️"
                title: "Médiation programmée"
                message: "Une séance de médiation est programmée pour demain"
                time: "Il y a 2 jours"
                read: true
                type: "mediation"
            }
        }

        delegate: Rectangle {
            width: ListView.view.width
            height: 100
            color: model.read ? "white" : "#E8F5E9"

            RowLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 16

                // Icon
                Rectangle {
                    Layout.preferredWidth: 60
                    Layout.preferredHeight: 60
                    radius: 30
                    color: getTypeColor(model.type)

                    Text {
                        anchors.centerIn: parent
                        text: model.icon
                        font.pixelSize: 28
                    }
                }

                // Content
                ColumnLayout {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 4

                    Text {
                        text: model.title
                        font.pixelSize: 16
                        font.bold: true
                        color: "#333333"
                        Layout.fillWidth: true
                    }

                    Text {
                        text: model.message
                        font.pixelSize: 14
                        color: "#666666"
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                    }

                    Text {
                        text: model.time
                        font.pixelSize: 12
                        color: "#999999"
                    }
                }

                // Unread indicator
                Rectangle {
                    Layout.preferredWidth: 12
                    Layout.preferredHeight: 12
                    radius: 6
                    color: "#4CAF50"
                    visible: !model.read
                }
            }

            Rectangle {
                anchors.bottom: parent.bottom
                width: parent.width
                height: 1
                color: "#E0E0E0"
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    model.read = true
                    handleNotificationClick(model.type)
                }
            }
        }

        // Empty state
        Rectangle {
            anchors.centerIn: parent
            width: parent.width - 64
            height: emptyColumn.height + 48
            radius: 12
            color: "white"
            visible: parent.count === 0

            ColumnLayout {
                id: emptyColumn
                anchors.centerIn: parent
                spacing: 16

                Text {
                    text: "🔔"
                    font.pixelSize: 64
                    Layout.alignment: Qt.AlignHCenter
                }

                Text {
                    text: "Aucune notification"
                    font.pixelSize: 18
                    font.bold: true
                    color: "#333333"
                    Layout.alignment: Qt.AlignHCenter
                }

                Text {
                    text: "Vous êtes à jour!"
                    font.pixelSize: 14
                    color: "#666666"
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }

    function getTypeColor(type) {
        var colors = {
            "payment": "#E8F5E9",
            "contract": "#E3F2FD",
            "dispute": "#FFEBEE",
            "mediation": "#F3E5F5"
        }
        return colors[type] || "#F5F5F5"
    }

    function handleNotificationClick(type) {
        console.log("Notification clicked:", type)
    }

    function markAllAsRead() {
        console.log("Mark all as read")
    }
}
