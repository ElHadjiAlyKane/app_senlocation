import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components"

Page {
    id: profilePage

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
                text: "Mon Profil"
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
        contentHeight: contentColumn.height + 100

        ColumnLayout {
            id: contentColumn
            width: parent.width
            spacing: 20

            // Profile Header
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 150
                color: "#4CAF50"

                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 10

                    Rectangle {
                        Layout.alignment: Qt.AlignHCenter
                        width: 80
                        height: 80
                        radius: 40
                        color: "white"

                        Text {
                            anchors.centerIn: parent
                            text: authManager.userName.charAt(0).toUpperCase()
                            font.pixelSize: 36
                            font.bold: true
                            color: "#4CAF50"
                        }
                    }

                    Text {
                        text: authManager.userName
                        font.pixelSize: 22
                        font.bold: true
                        color: "white"
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: getRoleText()
                        font.pixelSize: 16
                        color: "white"
                        opacity: 0.9
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }

            // Profile Information
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
                        text: "Informations personnelles"
                        font.pixelSize: 20
                        font.bold: true
                        color: "#333333"
                    }

                    CustomTextField {
                        id: nameField
                        Layout.fillWidth: true
                        placeholderText: "Nom complet"
                        text: authManager.userName
                    }

                    CustomTextField {
                        id: emailField
                        Layout.fillWidth: true
                        placeholderText: "Email"
                        inputMethodHints: Qt.ImhEmailCharactersOnly
                    }

                    CustomTextField {
                        id: phoneField
                        Layout.fillWidth: true
                        placeholderText: "Téléphone"
                        inputMethodHints: Qt.ImhDialableCharactersOnly
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        height: 1
                        color: "#E0E0E0"
                        Layout.topMargin: 10
                    }

                    Text {
                        text: "Modifier le mot de passe"
                        font.pixelSize: 18
                        font.bold: true
                        color: "#333333"
                        Layout.topMargin: 10
                    }

                    CustomTextField {
                        id: currentPasswordField
                        Layout.fillWidth: true
                        placeholderText: "Mot de passe actuel"
                        echoMode: TextInput.Password
                    }

                    CustomTextField {
                        id: newPasswordField
                        Layout.fillWidth: true
                        placeholderText: "Nouveau mot de passe"
                        echoMode: TextInput.Password
                    }

                    CustomTextField {
                        id: confirmNewPasswordField
                        Layout.fillWidth: true
                        placeholderText: "Confirmer le nouveau mot de passe"
                        echoMode: TextInput.Password
                    }

                    CustomButton {
                        Layout.fillWidth: true
                        Layout.topMargin: 20
                        text: "Enregistrer les modifications"
                        primary: true
                        onClicked: {
                            if (validateForm()) {
                                var profileData = {
                                    "name": nameField.text,
                                    "email": emailField.text,
                                    "phone": phoneField.text
                                }
                                if (newPasswordField.text) {
                                    profileData["password"] = newPasswordField.text
                                }
                                userManager.updateProfile(profileData)
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

                    Text {
                        id: successText
                        text: ""
                        color: "#4CAF50"
                        font.pixelSize: 14
                        Layout.alignment: Qt.AlignHCenter
                        visible: text !== ""
                    }
                }
            }
        }
    }

    function getRoleText() {
        if (authManager.userRole === "landlord") return "Bailleur"
        if (authManager.userRole === "tenant") return "Locataire"
        if (authManager.userRole === "lawyer") return "Juriste"
        return ""
    }

    function validateForm() {
        if (newPasswordField.text && newPasswordField.text !== confirmNewPasswordField.text) {
            errorText.text = "Les mots de passe ne correspondent pas"
            successText.text = ""
            return false
        }
        errorText.text = ""
        return true
    }

    Connections {
        target: userManager
        function onProfileUpdated() {
            successText.text = "Profil mis à jour avec succès"
            errorText.text = ""
        }
        function onOperationFailed(error) {
            errorText.text = error
            successText.text = ""
        }
    }

    Component.onCompleted: {
        userManager.fetchProfile()
    }

    Connections {
        target: userManager
        function onProfileFetched(profile) {
            nameField.text = profile.name || ""
            emailField.text = profile.email || ""
            phoneField.text = profile.phone || ""
        }
    }
}
