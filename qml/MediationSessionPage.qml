import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components"

Page {
    id: mediationSession
    objectName: "mediationSession"

    property int mediationId: 0
    property int sessionId: 0
    property bool isEditing: sessionId > 0

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
                text: isEditing ? "Modifier la séance" : "Nouvelle séance"
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
                        text: "Informations de la séance"
                        font.pixelSize: 18
                        font.bold: true
                        color: "#333333"
                    }

                    CustomTextField {
                        Layout.fillWidth: true
                        placeholderText: "Date (YYYY-MM-DD)"
                        text: sessionDate
                        onTextChanged: sessionDate = text
                    }

                    CustomTextField {
                        Layout.fillWidth: true
                        placeholderText: "Heure"
                        text: sessionTime
                        onTextChanged: sessionTime = text
                    }

                    ComboBox {
                        id: statusCombo
                        Layout.fillWidth: true
                        model: ["Programmée", "Terminée", "Annulée"]
                    }

                    Text {
                        text: "Notes de séance"
                        font.pixelSize: 14
                        color: "#333333"
                    }

                    TextArea {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 200
                        placeholderText: "Décrivez le déroulement de la séance, les points discutés, les progrès réalisés..."
                        wrapMode: TextArea.Wrap
                        text: sessionNotes
                        onTextChanged: sessionNotes = text
                    }

                    CustomButton {
                        Layout.fillWidth: true
                        text: "Enregistrer"
                        primary: true
                        onClicked: saveSession()
                    }
                }
            }

            Item {
                Layout.preferredHeight: 24
            }
        }
    }

    property string sessionDate: ""
    property string sessionTime: ""
    property string sessionNotes: ""

    function saveSession() {
        var sessionData = {
            date: sessionDate,
            time: sessionTime,
            status: statusCombo.currentText.toLowerCase(),
            notes: sessionNotes
        }

        if (isEditing) {
            mediationManager.updateSession(mediationId, sessionId, sessionData)
        } else {
            mediationManager.createSession(mediationId, sessionData)
        }
    }

    Connections {
        target: mediationManager

        function onSessionCreated(session) {
            stackView.pop()
        }

        function onSessionUpdated() {
            stackView.pop()
        }

        function onOperationFailed(error) {
            console.error("Error saving session:", error)
        }
    }
}
