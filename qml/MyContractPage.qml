import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components"

Page {
    id: myContract
    objectName: "myContract"

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
                text: "Mon contrat"
                font.pixelSize: 20
                font.bold: true
                color: "white"
                Layout.fillWidth: true
            }

            ToolButton {
                text: "📄"
                onClicked: stackView.push("DocumentsPage.qml")
            }
        }
    }

    ScrollView {
        anchors.fill: parent
        contentWidth: availableWidth
        clip: true

        ColumnLayout {
            width: parent.width
            spacing: 16

            // Contract status
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 60
                color: "#4CAF50"

                Text {
                    anchors.centerIn: parent
                    text: "✓ Contrat actif"
                    font.pixelSize: 18
                    font.bold: true
                    color: "white"
                }
            }

            // Property details
            Rectangle {
                Layout.fillWidth: true
                Layout.margins: 16
                Layout.preferredHeight: propertyColumn.height + 32
                radius: 12
                color: "white"

                ColumnLayout {
                    id: propertyColumn
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 16

                    Text {
                        text: "Propriété"
                        font.pixelSize: 18
                        font.bold: true
                        color: "#333333"
                    }

                    Text {
                        text: "Appartement 2 pièces Sacré-Cœur"
                        font.pixelSize: 16
                        color: "#666666"
                    }

                    Text {
                        text: "📍 Rue 10, Sacré-Cœur 3, Dakar"
                        font.pixelSize: 14
                        color: "#999999"
                    }
                }
            }

            // Contract terms
            Rectangle {
                Layout.fillWidth: true
                Layout.margins: 16
                Layout.preferredHeight: termsColumn.height + 32
                radius: 12
                color: "white"

                ColumnLayout {
                    id: termsColumn
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 12

                    Text {
                        text: "Termes du contrat"
                        font.pixelSize: 18
                        font.bold: true
                        color: "#333333"
                    }

                    InfoRow {
                        label: "Bailleur"
                        value: "Moussa Ndiaye"
                    }

                    InfoRow {
                        label: "Loyer mensuel"
                        value: "350 000 FCFA"
                    }

                    InfoRow {
                        label: "Caution"
                        value: "700 000 FCFA"
                    }

                    InfoRow {
                        label: "Date début"
                        value: "01/06/2024"
                    }

                    InfoRow {
                        label: "Date fin"
                        value: "31/05/2025"
                    }

                    InfoRow {
                        label: "Durée restante"
                        value: "6 mois"
                    }
                }
            }

            // Actions
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
                        text: "Actions"
                        font.pixelSize: 18
                        font.bold: true
                        color: "#333333"
                    }

                    CustomButton {
                        Layout.fillWidth: true
                        text: "📄 Voir le contrat PDF"
                        onClicked: console.log("View contract PDF")
                    }

                    CustomButton {
                        Layout.fillWidth: true
                        text: "💰 Payer mon loyer"
                        primary: true
                        onClicked: stackView.push("PayMyRentPage.qml")
                    }

                    CustomButton {
                        Layout.fillWidth: true
                        text: "⚠️ Signaler un problème"
                        onClicked: stackView.push("DisputePage.qml")
                    }
                }
            }

            Item {
                Layout.preferredHeight: 24
            }
        }
    }

    component InfoRow: RowLayout {
        property string label: ""
        property string value: ""

        Layout.fillWidth: true
        spacing: 8

        Text {
            text: label + ":"
            font.pixelSize: 14
            color: "#999999"
            Layout.preferredWidth: 140
        }

        Text {
            text: value
            font.pixelSize: 14
            font.bold: true
            color: "#333333"
            Layout.fillWidth: true
        }
    }
}
