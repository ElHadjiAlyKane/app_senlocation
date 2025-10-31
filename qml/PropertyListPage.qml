import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components"

Page {
    id: propertyListPage

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
                text: "Propriétés"
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

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Search Bar
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            color: "white"

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10

                TextField {
                    id: searchField
                    Layout.fillWidth: true
                    placeholderText: "Rechercher une propriété..."
                    
                    background: Rectangle {
                        border.color: "#CCCCCC"
                        border.width: 1
                        radius: 20
                        color: "#f5f5f5"
                    }
                }
            }
        }

        // Properties List
        ListView {
            id: listView
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 10
            clip: true

            model: propertyManager.properties

            delegate: PropertyCard {
                width: listView.width - 20
                property var modelData: model.modelData
                
                onClicked: {
                    stackView.push("PropertyDetailPage.qml", {
                        "propertyId": modelData.id,
                        "propertyData": modelData
                    })
                }
            }

            ScrollBar.vertical: ScrollBar {}
        }

        // Empty State
        Text {
            visible: listView.count === 0
            text: "Aucune propriété disponible"
            font.pixelSize: 18
            color: "#999999"
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: 50
        }
    }

    Component.onCompleted: {
        propertyManager.fetchProperties()
    }
}
