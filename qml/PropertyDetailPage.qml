import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components"

Page {
    id: propertyDetailPage

    property string propertyId: ""
    property var propertyData: null

    header: ToolBar {
        background: Rectangle {
            color: "#4CAF50"
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: 10

            ToolButton {
                text: "←"
                font.pixelSize: 24
                onClicked: stackView.pop()
            }

            Label {
                text: "Détails"
                font.pixelSize: 20
                font.bold: true
                color: "white"
                Layout.fillWidth: true
            }
        }
    }

    background: Rectangle {
        color: "#f5f5f5"
    }

    Flickable {
        anchors.fill: parent
        contentHeight: contentColumn.height

        ColumnLayout {
            id: contentColumn
            width: parent.width
            spacing: 0

            // Image Placeholder
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 250
                color: "#CCCCCC"

                Text {
                    anchors.centerIn: parent
                    text: "📷"
                    font.pixelSize: 80
                }
            }

            // Property Details
            Rectangle {
                Layout.fillWidth: true
                Layout.margins: 20
                radius: 10
                color: "white"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 15

                    Text {
                        text: propertyData ? propertyData.title : ""
                        font.pixelSize: 24
                        font.bold: true
                        color: "#333333"
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                    }

                    Text {
                        text: propertyData ? propertyData.price + " FCFA/mois" : ""
                        font.pixelSize: 20
                        font.bold: true
                        color: "#4CAF50"
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: "#E0E0E0"
                    }

                    RowLayout {
                        spacing: 20

                        ColumnLayout {
                            Text {
                                text: "🛏️ " + (propertyData ? propertyData.bedrooms : "0")
                                font.pixelSize: 16
                            }
                            Text {
                                text: "Chambres"
                                font.pixelSize: 12
                                color: "#666666"
                            }
                        }

                        ColumnLayout {
                            Text {
                                text: "🚿 " + (propertyData ? propertyData.bathrooms : "0")
                                font.pixelSize: 16
                            }
                            Text {
                                text: "Salles de bain"
                                font.pixelSize: 12
                                color: "#666666"
                            }
                        }

                        ColumnLayout {
                            Text {
                                text: "📐 " + (propertyData ? propertyData.area : "0") + " m²"
                                font.pixelSize: 16
                            }
                            Text {
                                text: "Surface"
                                font.pixelSize: 12
                                color: "#666666"
                            }
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: "#E0E0E0"
                    }

                    Text {
                        text: "Description"
                        font.pixelSize: 18
                        font.bold: true
                        color: "#333333"
                    }

                    Text {
                        text: propertyData ? propertyData.description : ""
                        font.pixelSize: 16
                        color: "#666666"
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: "#E0E0E0"
                    }

                    Text {
                        text: "Adresse"
                        font.pixelSize: 18
                        font.bold: true
                        color: "#333333"
                    }

                    Text {
                        text: propertyData ? propertyData.address : ""
                        font.pixelSize: 16
                        color: "#666666"
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                    }

                    CustomButton {
                        Layout.fillWidth: true
                        Layout.topMargin: 20
                        text: "Demander une visite"
                        primary: true
                        visible: authManager.userRole === "tenant"
                        onClicked: {
                            // TODO: Implement visit request
                        }
                    }
                }
            }
        }
    }
}
