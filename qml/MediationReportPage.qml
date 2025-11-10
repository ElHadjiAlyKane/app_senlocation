import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components"

Page {
    id: mediationReport
    objectName: "mediationReport"

    property int mediationId: 0

    header: ToolBar {
        background: Rectangle {
            color: "#9C27B0"
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: 10

            ToolButton {
                text: "←"
                onClicked: stackView.pop()
            }

            Label {
                text: "Rapport de médiation"
                font.pixelSize: 20
                font.bold: true
                color: "white"
                Layout.fillWidth: true
            }

            ToolButton {
                text: "💾"
                onClicked: generateReport()
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

            // Report header
            Rectangle {
                Layout.fillWidth: true
                Layout.margins: 16
                Layout.preferredHeight: headerColumn.height + 32
                radius: 12
                color: "white"

                ColumnLayout {
                    id: headerColumn
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 12

                    Text {
                        text: "Rapport de médiation #" + mediationId
                        font.pixelSize: 20
                        font.bold: true
                        color: "#333333"
                    }

                    Text {
                        text: "Généré le: " + new Date().toLocaleDateString()
                        font.pixelSize: 14
                        color: "#666666"
                    }
                }
            }

            // Report content
            Rectangle {
                Layout.fillWidth: true
                Layout.margins: 16
                Layout.preferredHeight: contentColumn.height + 32
                radius: 12
                color: "white"

                ColumnLayout {
                    id: contentColumn
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 24

                    // Summary section
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Text {
                            text: "Résumé"
                            font.pixelSize: 16
                            font.bold: true
                            color: "#333333"
                        }

                        Text {
                            text: "Nombre de séances: 2"
                            font.pixelSize: 14
                            color: "#666666"
                        }

                        Text {
                            text: "Durée totale: 3 heures"
                            font.pixelSize: 14
                            color: "#666666"
                        }

                        Text {
                            text: "Résultat: En cours"
                            font.pixelSize: 14
                            color: "#666666"
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: "#E0E0E0"
                    }

                    // Sessions summary
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Text {
                            text: "Séances"
                            font.pixelSize: 16
                            font.bold: true
                            color: "#333333"
                        }

                        Text {
                            text: "Séance 1 (05/11/2025):\nPremière rencontre - présentation des griefs"
                            font.pixelSize: 14
                            color: "#666666"
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                        }

                        Text {
                            text: "Séance 2 (08/11/2025):\nDiscussion sur les solutions possibles"
                            font.pixelSize: 14
                            color: "#666666"
                            wrapMode: Text.WordWrap
                            Layout.fillWidth: true
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: "#E0E0E0"
                    }

                    // Recommendations
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 8

                        Text {
                            text: "Recommandations"
                            font.pixelSize: 16
                            font.bold: true
                            color: "#333333"
                        }

                        TextArea {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 150
                            placeholderText: "Entrez vos recommandations..."
                            wrapMode: TextArea.Wrap
                        }
                    }
                }
            }

            CustomButton {
                Layout.fillWidth: true
                Layout.margins: 16
                text: "Générer et télécharger PDF"
                primary: true
                onClicked: generateReport()
            }

            Item {
                Layout.preferredHeight: 24
            }
        }
    }

    function generateReport() {
        mediationManager.fetchReport(mediationId)
    }

    Connections {
        target: mediationManager

        function onReportFetched(report) {
            console.log("Report generated:", JSON.stringify(report))
        }
    }
}
