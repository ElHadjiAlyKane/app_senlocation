import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components"

Page {
    id: registerPage

    background: Rectangle {
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#4CAF50" }
            GradientStop { position: 1.0; color: "#2E7D32" }
        }
    }

    header: ToolBar {
        background: Rectangle {
            color: "transparent"
        }

        RowLayout {
            anchors.fill: parent

            ToolButton {
                text: "←"
                font.pixelSize: 24
                onClicked: stackView.pop()
            }

            Label {
                text: "Retour"
                font.pixelSize: 18
                Layout.fillWidth: true
            }
        }
    }

    Flickable {
        anchors.fill: parent
        contentHeight: contentColumn.height + 100

        ColumnLayout {
            id: contentColumn
            anchors.centerIn: parent
            width: parent.width * 0.85
            spacing: 20

            Text {
                text: "Créer un compte"
                font.pixelSize: 28
                font.bold: true
                color: "white"
                Layout.alignment: Qt.AlignHCenter
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 520
                radius: 15
                color: "white"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 30
                    spacing: 15

                    CustomTextField {
                        id: nameField
                        Layout.fillWidth: true
                        placeholderText: "Nom complet"
                    }

                    CustomTextField {
                        id: emailField
                        Layout.fillWidth: true
                        placeholderText: "Email"
                        inputMethodHints: Qt.ImhEmailCharactersOnly
                    }

                    CustomTextField {
                        id: passwordField
                        Layout.fillWidth: true
                        placeholderText: "Mot de passe"
                        echoMode: TextInput.Password
                    }

                    CustomTextField {
                        id: confirmPasswordField
                        Layout.fillWidth: true
                        placeholderText: "Confirmer le mot de passe"
                        echoMode: TextInput.Password
                    }

                    Text {
                        text: "Type de compte"
                        font.pixelSize: 16
                        font.bold: true
                        color: "#333333"
                    }

                    ComboBox {
                        id: roleComboBox
                        Layout.fillWidth: true
                        model: ["Bailleur", "Locataire", "Juriste"]
                        
                        background: Rectangle {
                            border.color: "#CCCCCC"
                            border.width: 1
                            radius: 8
                        }
                    }

                    CustomButton {
                        Layout.fillWidth: true
                        text: "S'inscrire"
                        primary: true
                        onClicked: {
                            if (validateForm()) {
                                var role = roleComboBox.currentIndex === 0 ? "landlord" : 
                                          roleComboBox.currentIndex === 1 ? "tenant" : "lawyer"
                                authManager.register_(nameField.text, emailField.text, 
                                                     passwordField.text, role)
                            }
                        }
                    }

                    Text {
                        id: errorText
                        text: ""
                        color: "#F44336"
                        font.pixelSize: 14
                        Layout.alignment: Qt.AlignHCenter
                        visible: text !== ""
                    }
                }
            }
        }
    }

    function validateForm() {
        if (!nameField.text) {
            errorText.text = "Le nom est requis"
            return false
        }
        if (!emailField.text) {
            errorText.text = "L'email est requis"
            return false
        }
        if (!passwordField.text) {
            errorText.text = "Le mot de passe est requis"
            return false
        }
        if (passwordField.text !== confirmPasswordField.text) {
            errorText.text = "Les mots de passe ne correspondent pas"
            return false
        }
        errorText.text = ""
        return true
    }

    Connections {
        target: authManager
        function onRegistrationSuccess() {
            stackView.pop()
        }
        function onRegistrationFailed(error) {
            errorText.text = error
        }
    }
}
