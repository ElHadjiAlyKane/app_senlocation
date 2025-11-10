import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components"

Page {
    id: myProperties
    objectName: "myProperties"

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
                text: "Mes propriétés"
                font.pixelSize: 20
                font.bold: true
                color: "white"
                Layout.fillWidth: true
            }

            ToolButton {
                text: "+"
                onClicked: stackView.push("AddPropertyPage.qml")
            }
        }
    }

    Component.onCompleted: {
        propertyManager.fetchProperties()
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Filter tabs
        TabBar {
            id: filterTabs
            Layout.fillWidth: true

            TabButton {
                text: "Toutes"
            }
            TabButton {
                text: "Disponibles"
            }
            TabButton {
                text: "Louées"
            }
        }

        // Properties list
        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 12
            clip: true

            model: propertyManager.properties

            delegate: PropertyCard {
                width: ListView.view.width - 32
                anchors.horizontalCenter: parent.horizontalCenter
                modelData: model.modelData
                onClicked: stackView.push("PropertyDetailPage.qml", {propertyId: modelData.id})
            }

            header: Item {
                width: parent.width
                height: 16
            }

            footer: Item {
                width: parent.width
                height: 16
            }
        }
    }
}
