import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components"

Page {
    id: loginPage

    background: Rectangle {
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#4CAF50" }
            GradientStop { position: 1.0; color: "#2E7D32" }
        }
    }

    ColumnLayout {
        anchors.centerIn: parent
        width: parent.width * 0.85
        spacing: 20

        // Logo/Title
        Text {
            text: "SenLocation"
            font.pixelSize: 36
            font.bold: true
            color: "white"
            Layout.alignment: Qt.AlignHCenter
        }

        Text {
            text: "Bienvenue"
            font.pixelSize: 20
            color: "white"
            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: 20
        }

        // Login Form
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 350
            radius: 15
            color: "white"

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 30
                spacing: 20

                Text {
                    text: "Connexion"
                    font.pixelSize: 24
                    font.bold: true
                    color: "#333333"
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

                CustomButton {
                    id: loginButton
                    Layout.fillWidth: true
                    text: "Se connecter"
                    primary: true
                    onClicked: {
                        if (emailField.text && passwordField.text) {
                            authManager.login(emailField.text, passwordField.text)
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

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 5

                    Text {
                        text: "Pas encore de compte ?"
                        color: "#666666"
                        font.pixelSize: 14
                    }

                    Text {
                        text: "S'inscrire"
                        color: "#4CAF50"
                        font.pixelSize: 14
                        font.bold: true

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            onClicked: {
                                stackView.push("RegisterPage.qml")
                            }
                        }
                    }
                }
            }
        }
    }

    Connections {
        target: authManager
        function onLoginFailed(error) {
            errorText.text = error
        }
    }

    BusyIndicator {
        anchors.centerIn: parent
        running: false
        visible: running
    }
}
