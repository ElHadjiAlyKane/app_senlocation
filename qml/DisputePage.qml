import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components"

Page {
    id: disputePage
    objectName: "disputePage"

    header: ToolBar {
        background: Rectangle {
            color: "#F44336"
        }

        RowLayout {
            anchors.fill: parent
            anchors.margins: 10

            ToolButton {
                text: "←"
                onClicked: stackView.pop()
            }

            Label {
                text: "Créer un litige"
                font.pixelSize: 20
                font.bold: true
                color: "white"
                Layout.fillWidth: true
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

            Rectangle {
                Layout.fillWidth: true
                Layout.margins: 16
                Layout.preferredHeight: formColumn.height + 32
                radius: 12
                color: "white"

                ColumnLayout {
                    id: formColumn
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 16

                    Text {
                        text: "Détails du litige"
                        font.pixelSize: 18
                        font.bold: true
                        color: "#333333"
                    }

                    CustomTextField {
                        Layout.fillWidth: true
                        placeholderText: "Objet du litige *"
                        text: disputeTitle
                        onTextChanged: disputeTitle = text
                    }

                    Text {
                        text: "Gravité *"
                        font.pixelSize: 14
                        color: "#333333"
                    }

                    ComboBox {
                        id: severityCombo
                        Layout.fillWidth: true
                        model: ["Faible", "Moyen", "Élevé"]
                    }

                    Text {
                        text: "Description *"
                        font.pixelSize: 14
                        color: "#333333"
                    }

                    TextArea {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 200
                        placeholderText: "Décrivez en détail la nature du litige..."
                        wrapMode: TextArea.Wrap
                        text: disputeDescription
                        onTextChanged: disputeDescription = text
                    }

                    DocumentUploader {
                        Layout.fillWidth: true
                        label: "Pièces justificatives (optionnel)"
                        onFileSelected: attachmentFile = filePath
                    }

                    CustomButton {
                        Layout.fillWidth: true
                        text: "Soumettre le litige"
                        primary: true
                        enabled: disputeTitle.length > 0 && disputeDescription.length > 0
                        onClicked: submitDispute()
                    }
                }
            }

            Item {
                Layout.preferredHeight: 24
            }
        }
    }

    property string disputeTitle: ""
    property string disputeDescription: ""
    property string attachmentFile: ""

    function submitDispute() {
        var disputeData = {
            title: disputeTitle,
            description: disputeDescription,
            severity: severityCombo.currentText.toLowerCase()
        }

        disputeManager.createDispute(disputeData)
    }

    Connections {
        target: disputeManager

        function onDisputeCreated(dispute) {
            messageDialog.text = "Litige créé avec succès. Vous serez notifié des mises à jour."
            messageDialog.open()
        }

        function onOperationFailed(error) {
            messageDialog.text = "Erreur: " + error
            messageDialog.open()
        }
    }

    Dialog {
        id: messageDialog
        anchors.centerIn: parent
        width: Math.min(parent.width * 0.8, 400)
        title: "Litige"
        standardButtons: Dialog.Ok

        property alias text: messageText.text

        Text {
            id: messageText
            width: parent.width
            wrapMode: Text.WordWrap
        }

        onAccepted: stackView.pop()
    }
}
