import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components"

Page {
    id: mediatorRegistration
    objectName: "mediatorRegistration"

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
                text: "Inscription Médiateur"
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
                currentStep: registrationStep
                steps: [
                    {label: "Informations", description: "Vos coordonnées"},
                    {label: "Qualifications", description: "Diplômes et expérience"},
                    {label: "Documents", description: "Upload des justificatifs"}
                ]
            }

            // Form
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

                    // Step 1: Personal Information
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 12
                        visible: registrationStep === 0

                        CustomTextField {
                            Layout.fillWidth: true
                            placeholderText: "Nom complet *"
                            text: mediatorName
                            onTextChanged: mediatorName = text
                        }

                        CustomTextField {
                            Layout.fillWidth: true
                            placeholderText: "Email *"
                            text: mediatorEmail
                            onTextChanged: mediatorEmail = text
                        }

                        CustomTextField {
                            Layout.fillWidth: true
                            placeholderText: "Téléphone *"
                            text: mediatorPhone
                            onTextChanged: mediatorPhone = text
                        }

                        CustomTextField {
                            Layout.fillWidth: true
                            placeholderText: "Adresse"
                            text: mediatorAddress
                            onTextChanged: mediatorAddress = text
                        }
                    }

                    // Step 2: Qualifications
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 12
                        visible: registrationStep === 1

                        Text {
                            text: "Spécialisation *"
                            font.pixelSize: 14
                            color: "#333333"
                        }

                        ComboBox {
                            id: specializationCombo
                            Layout.fillWidth: true
                            model: ["Droit immobilier", "Médiation civile", "Droit des contrats", "Autre"]
                        }

                        CustomTextField {
                            Layout.fillWidth: true
                            placeholderText: "Années d'expérience *"
                            text: yearsExperience
                            onTextChanged: yearsExperience = text
                        }

                        CustomTextField {
                            Layout.fillWidth: true
                            placeholderText: "Numéro de licence/certification"
                            text: licenseNumber
                            onTextChanged: licenseNumber = text
                        }

                        TextArea {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 120
                            placeholderText: "Décrivez votre expérience..."
                            wrapMode: TextArea.Wrap
                            text: mediatorBio
                            onTextChanged: mediatorBio = text
                        }
                    }

                    // Step 3: Documents
                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 16
                        visible: registrationStep === 2

                        DocumentUploader {
                            Layout.fillWidth: true
                            label: "Diplôme ou Certification *"
                            fileName: diplomaFileName
                            onFileSelected: diplomaFileName = filePath
                        }

                        DocumentUploader {
                            Layout.fillWidth: true
                            label: "Carte d'identité *"
                            fileName: idCardFileName
                            onFileSelected: idCardFileName = filePath
                        }

                        DocumentUploader {
                            Layout.fillWidth: true
                            label: "CV (optionnel)"
                            fileName: cvFileName
                            onFileSelected: cvFileName = filePath
                        }
                    }

                    // Navigation buttons
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 12

                        CustomButton {
                            Layout.fillWidth: true
                            text: "Précédent"
                            visible: registrationStep > 0
                            onClicked: registrationStep--
                        }

                        CustomButton {
                            Layout.fillWidth: true
                            text: registrationStep < 2 ? "Suivant" : "Soumettre"
                            primary: true
                            onClicked: {
                                if (registrationStep < 2) {
                                    registrationStep++
                                } else {
                                    submitRegistration()
                                }
                            }
                        }
                    }
                }
            }

            Item {
                Layout.preferredHeight: 24
            }
        }
    }

    property int registrationStep: 0
    property string mediatorName: ""
    property string mediatorEmail: ""
    property string mediatorPhone: ""
    property string mediatorAddress: ""
    property string yearsExperience: ""
    property string licenseNumber: ""
    property string mediatorBio: ""
    property string diplomaFileName: ""
    property string idCardFileName: ""
    property string cvFileName: ""

    function submitRegistration() {
        var mediatorData = {
            name: mediatorName,
            email: mediatorEmail,
            phone: mediatorPhone,
            address: mediatorAddress,
            specialization: specializationCombo.currentText,
            yearsExperience: parseInt(yearsExperience),
            licenseNumber: licenseNumber,
            bio: mediatorBio
        }

        mediationManager.registerMediator(mediatorData)
    }

    Connections {
        target: mediationManager

        function onMediatorRegistered(mediator) {
            messageDialog.text = "Inscription réussie! Votre profil sera vérifié sous peu."
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
        title: "Inscription Médiateur"
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
