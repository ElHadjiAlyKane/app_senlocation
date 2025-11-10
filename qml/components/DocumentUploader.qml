import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs 1.3

Rectangle {
    id: documentUploader

    property string label: "Télécharger un document"
    property string fileName: ""
    property bool uploading: false

    signal fileSelected(string filePath)
    signal uploadClicked()

    implicitHeight: content.height + 24
    radius: 8
    color: "#F5F5F5"
    border.color: dragArea.containsDrag ? "#4CAF50" : "#E0E0E0"
    border.width: 2

    ColumnLayout {
        id: content
        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        // Label
        Text {
            text: label
            font.pixelSize: 14
            font.bold: true
            color: "#333333"
        }

        // Upload area
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 100
            radius: 6
            color: dragArea.containsDrag ? "#E8F5E9" : "white"
            border.color: "#E0E0E0"
            border.width: 1
            border.style: Qt.DashLine

            ColumnLayout {
                anchors.centerIn: parent
                spacing: 8

                Text {
                    text: fileName ? "📄" : "📁"
                    font.pixelSize: 32
                    Layout.alignment: Qt.AlignHCenter
                }

                Text {
                    text: fileName || "Glissez-déposez ou cliquez pour sélectionner"
                    font.pixelSize: 13
                    color: "#666666"
                    Layout.alignment: Qt.AlignHCenter
                }

                Text {
                    text: "PDF, PNG, JPG (max 5 MB)"
                    font.pixelSize: 11
                    color: "#999999"
                    Layout.alignment: Qt.AlignHCenter
                    visible: !fileName
                }
            }

            MouseArea {
                id: clickArea
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: fileDialog.open()
            }

            DropArea {
                id: dragArea
                anchors.fill: parent

                onDropped: {
                    if (drop.hasUrls) {
                        fileName = drop.urls[0].toString().split('/').pop()
                        fileSelected(drop.urls[0].toString())
                    }
                }
            }
        }

        // Upload button
        Button {
            Layout.fillWidth: true
            Layout.preferredHeight: 44
            text: uploading ? "Téléchargement..." : "Télécharger"
            enabled: fileName && !uploading

            contentItem: Text {
                text: parent.text
                font.pixelSize: 14
                font.bold: true
                color: parent.enabled ? "white" : "#999999"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            background: Rectangle {
                radius: 22
                color: parent.enabled ? (parent.pressed ? "#388E3C" : "#4CAF50") : "#CCCCCC"
            }

            onClicked: uploadClicked()
        }
    }

    FileDialog {
        id: fileDialog
        title: "Sélectionner un document"
        nameFilters: ["Documents (*.pdf *.png *.jpg *.jpeg)"]
        onAccepted: {
            fileName = fileUrl.toString().split('/').pop()
            fileSelected(fileUrl.toString())
        }
    }

    BusyIndicator {
        anchors.centerIn: parent
        running: uploading
        visible: uploading
    }
}
