import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components"

Page {
    id: mediatorProfile
    objectName: "mediatorProfile"

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
                text: "Mon profil"
                font.pixelSize: 20
                font.bold: true
                color: "white"
                Layout.fillWidth: true
            }

            ToolButton {
                text: "✏️"
                onClicked: editMode = !editMode
            }
        }
    }

    ScrollView {
        anchors.fill: parent
        contentWidth: availableWidth
        clip: true

        ColumnLayout {
            width: Math.min(parent.width, 600)
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 16

            // Profile header with badge
            Rectangle {
                Layout.fillWidth: true
                Layout.margins: 16
                Layout.preferredHeight: profileHeaderColumn.height + 32
                radius: 12
                color: "white"

                ColumnLayout {
                    id: profileHeaderColumn
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 16

                    Text {
                        text: "👤"
                        font.pixelSize: 64
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: "Me. Ousmane Sarr"
                        font.pixelSize: 20
                        font.bold: true
                        color: "#333333"
                        Layout.alignment: Qt.AlignHCenter
                    }

                    MediatorBadge {
                        Layout.alignment: Qt.AlignHCenter
                        verified: true
                        rating: 4.7
                        casesHandled: 15
                    }
                }
            }

            // Statistics
            Rectangle {
                Layout.fillWidth: true
                Layout.margins: 16
                Layout.preferredHeight: statsGrid.height + 32
                radius: 12
                color: "white"

                GridLayout {
                    id: statsGrid
                    anchors.fill: parent
                    anchors.margins: 16
                    columns: 2
                    rowSpacing: 16
                    columnSpacing: 16

                    StatCard {
                        Layout.fillWidth: true
                        title: "Médiations"
                        value: "15"
                        icon: "📋"
                        accentColor: "#9C27B0"
                    }

                    StatCard {
                        Layout.fillWidth: true
                        title: "Taux succès"
                        value: "85%"
                        icon: "✅"
                        accentColor: "#4CAF50"
                    }

                    StatCard {
                        Layout.fillWidth: true
                        title: "Note moyenne"
                        value: "4.7/5"
                        icon: "⭐"
                        accentColor: "#FFB300"
                    }

                    StatCard {
                        Layout.fillWidth: true
                        title: "Expérience"
                        value: "8 ans"
                        icon: "📊"
                        accentColor: "#2196F3"
                    }
                }
            }

            // Profile details
            Rectangle {
                Layout.fillWidth: true
                Layout.margins: 16
                Layout.preferredHeight: detailsColumn.height + 32
                radius: 12
                color: "white"

                ColumnLayout {
                    id: detailsColumn
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 16

                    Text {
                        text: "Informations"
                        font.pixelSize: 18
                        font.bold: true
                        color: "#333333"
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 12

                        InfoRow {
                            label: "Email"
                            value: "o.sarr@senlocation.sn"
                        }

                        InfoRow {
                            label: "Téléphone"
                            value: "+221 77 123 45 67"
                        }

                        InfoRow {
                            label: "Spécialisation"
                            value: "Droit immobilier"
                        }

                        InfoRow {
                            label: "Licence"
                            value: "MED-2016-001234"
                        }
                    }
                }
            }

            Item {
                Layout.preferredHeight: 24
            }
        }
    }

    property bool editMode: false

    component InfoRow: RowLayout {
        property string label: ""
        property string value: ""

        Layout.fillWidth: true
        spacing: 8

        Text {
            text: label + ":"
            font.pixelSize: 14
            color: "#999999"
            Layout.preferredWidth: 120
        }

        Text {
            text: value
            font.pixelSize: 14
            color: "#333333"
            Layout.fillWidth: true
        }
    }
}
