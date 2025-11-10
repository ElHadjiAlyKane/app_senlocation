import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: validationCodeInput

    property int codeLength: 6
    property alias code: codeField.text

    signal codeEntered(string code)

    implicitWidth: 300
    implicitHeight: 80

    ColumnLayout {
        anchors.fill: parent
        spacing: 12

        Text {
            text: "Code de validation"
            font.pixelSize: 14
            font.bold: true
            color: "#333333"
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 50
            radius: 8
            color: "#F5F5F5"
            border.color: codeField.activeFocus ? "#4CAF50" : "#E0E0E0"
            border.width: 2

            TextField {
                id: codeField
                anchors.fill: parent
                anchors.margins: 8
                font.pixelSize: 20
                font.letterSpacing: 8
                font.bold: true
                horizontalAlignment: Text.AlignHCenter
                maximumLength: codeLength
                inputMethodHints: Qt.ImhDigitsOnly
                placeholderText: "0".repeat(codeLength)
                color: "#333333"
                background: Rectangle {
                    color: "transparent"
                }

                validator: RegExpValidator {
                    regExp: new RegExp("\\d{0," + codeLength + "}")
                }

                onTextChanged: {
                    if (text.length === codeLength) {
                        codeEntered(text)
                    }
                }
            }
        }

        Text {
            text: code.length + " / " + codeLength + " chiffres"
            font.pixelSize: 12
            color: "#999999"
            Layout.alignment: Qt.AlignRight
        }
    }
}
