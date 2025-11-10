import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components"

Page {
    id: contractValidation
    objectName: "contractValidation"

    property int contractId: 0

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
                text: "Validation du contrat"
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
            spacing: 24

            // Progress indicator
            ProgressStepper {
                Layout.fillWidth: true
                Layout.margins: 16
                Layout.preferredHeight: 100
                currentStep: validationStep
                steps: [
                    {label: "Réception SMS", description: "Code envoyé"},
                    {label: "Validation", description: "Entrer le code"},
                    {label: "Confirmé", description: "Contrat validé"}
                ]
            }

            // Validation form
            Rectangle {
                Layout.fillWidth: true
                Layout.margins: 16
                Layout.preferredHeight: validationColumn.height + 32
                radius: 12
                color: "white"

                ColumnLayout {
                    id: validationColumn
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 24

                    Text {
                        text: validationStep === 0 ? 
                            "Un code de validation a été envoyé à votre numéro de téléphone." :
                            validationStep === 1 ?
                            "Entrez le code de validation pour confirmer le contrat." :
                            "Contrat validé avec succès!"
                        font.pixelSize: 16
                        color: "#666666"
                        wrapMode: Text.WordWrap
                        Layout.fillWidth: true
                        horizontalAlignment: Text.AlignHCenter
                    }

                    ValidationCodeInput {
                        Layout.alignment: Qt.AlignHCenter
                        visible: validationStep === 1
                        onCodeEntered: function(code) {
                            validateContract(code)
                        }
                    }

                    Text {
                        text: "✅"
                        font.pixelSize: 64
                        Layout.alignment: Qt.AlignHCenter
                        visible: validationStep === 2
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 12
                        visible: validationStep < 2

                        CustomButton {
                            Layout.fillWidth: true
                            text: validationStep === 0 ? "Continuer" : "Valider"
                            primary: true
                            onClicked: {
                                if (validationStep === 0) {
                                    validationStep = 1
                                }
                            }
                        }
                    }

                    CustomButton {
                        Layout.fillWidth: true
                        text: "Terminer"
                        primary: true
                        visible: validationStep === 2
                        onClicked: stackView.pop()
                    }

                    Button {
                        Layout.alignment: Qt.AlignHCenter
                        text: "Renvoyer le code"
                        flat: true
                        visible: validationStep === 1
                        onClicked: resendCode()
                    }
                }
            }

            Item {
                Layout.preferredHeight: 24
            }
        }
    }

    property int validationStep: 0

    function validateContract(code) {
        contractManager.validateContractTenant(contractId, code)
    }

    function resendCode() {
        console.log("Resending validation code...")
    }

    Connections {
        target: contractManager

        function onContractValidated() {
            validationStep = 2
        }

        function onOperationFailed(error) {
            errorDialog.text = error
            errorDialog.open()
        }
    }

    Dialog {
        id: errorDialog
        anchors.centerIn: parent
        width: Math.min(parent.width * 0.8, 400)
        title: "Erreur"
        standardButtons: Dialog.Ok

        property alias text: errorText.text

        Text {
            id: errorText
            width: parent.width
            wrapMode: Text.WordWrap
        }
    }
}
