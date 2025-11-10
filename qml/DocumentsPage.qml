import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components"

Page {
    id: documentsPage
    objectName: "documentsPage"

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
                text: "Documents"
                font.pixelSize: 20
                font.bold: true
                color: "white"
                Layout.fillWidth: true
            }

            ToolButton {
                text: "+"
                onClicked: uploadDialog.open()
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Filter tabs
        TabBar {
            id: filterTabs
            Layout.fillWidth: true

            TabButton {
                text: "Tous"
            }
            TabButton {
                text: "Contrats"
            }
            TabButton {
                text: "Paiements"
            }
            TabButton {
                text: "Médiations"
            }
        }

        // Documents list
        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 0
            clip: true

            model: ListModel {
                ListElement {
                    icon: "📄"
                    name: "Contrat de location - Villa Mermoz"
                    type: "contract"
                    date: "2024-01-01"
                    size: "245 KB"
                }
                ListElement {
                    icon: "💰"
                    name: "Reçu de paiement - Novembre 2025"
                    type: "payment"
                    date: "2025-11-05"
                    size: "120 KB"
                }
                ListElement {
                    icon: "⚖️"
                    name: "Rapport de médiation #1"
                    type: "mediation"
                    date: "2025-10-28"
                    size: "340 KB"
                }
                ListElement {
                    icon: "📄"
                    name: "État des lieux d'entrée"
                    type: "contract"
                    date: "2024-01-01"
                    size: "890 KB"
                }
            }

            delegate: Rectangle {
                width: ListView.view.width
                height: 90
                color: "white"

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 16

                    // Icon
                    Rectangle {
                        Layout.preferredWidth: 60
                        Layout.preferredHeight: 60
                        radius: 8
                        color: getTypeColor(model.type)

                        Text {
                            anchors.centerIn: parent
                            text: model.icon
                            font.pixelSize: 32
                        }
                    }

                    // Content
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 4

                        Text {
                            text: model.name
                            font.pixelSize: 15
                            font.bold: true
                            color: "#333333"
                            elide: Text.ElideRight
                            Layout.fillWidth: true
                        }

                        RowLayout {
                            spacing: 16

                            Text {
                                text: "📅 " + model.date
                                font.pixelSize: 13
                                color: "#666666"
                            }

                            Text {
                                text: "💾 " + model.size
                                font.pixelSize: 13
                                color: "#666666"
                            }
                        }
                    }

                    // Actions
                    ToolButton {
                        text: "⬇️"
                        onClicked: downloadDocument(model.name)
                    }

                    ToolButton {
                        text: "👁️"
                        onClicked: viewDocument(model.name)
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
                    onClicked: viewDocument(model.name)
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
                        text: "📁"
                        font.pixelSize: 64
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: "Aucun document"
                        font.pixelSize: 18
                        font.bold: true
                        color: "#333333"
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: "Vos documents apparaîtront ici"
                        font.pixelSize: 14
                        color: "#666666"
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }
        }
    }

    Dialog {
        id: uploadDialog
        anchors.centerIn: parent
        width: Math.min(parent.width * 0.9, 500)
        title: "Télécharger un document"
        standardButtons: Dialog.Ok | Dialog.Cancel

        DocumentUploader {
            width: parent.width
            label: "Sélectionner un document"
        }

        onAccepted: {
            console.log("Document uploaded")
        }
    }

    function getTypeColor(type) {
        var colors = {
            "contract": "#E3F2FD",
            "payment": "#E8F5E9",
            "mediation": "#F3E5F5"
        }
        return colors[type] || "#F5F5F5"
    }

    function downloadDocument(name) {
        console.log("Downloading:", name)
    }

    function viewDocument(name) {
        console.log("Viewing:", name)
    }
}
