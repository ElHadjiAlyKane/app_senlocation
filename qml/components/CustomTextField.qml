import QtQuick 2.15
import QtQuick.Controls 2.15

TextField {
    id: customTextField

    height: 50
    font.pixelSize: 16
    color: "#333333"

    background: Rectangle {
        radius: 8
        color: customTextField.activeFocus ? "#F5F5F5" : "white"
        border.color: customTextField.activeFocus ? "#4CAF50" : "#CCCCCC"
        border.width: customTextField.activeFocus ? 2 : 1

        Behavior on border.color {
            ColorAnimation {
                duration: 200
            }
        }

        Behavior on color {
            ColorAnimation {
                duration: 200
            }
        }
    }

    placeholderTextColor: "#999999"
}
