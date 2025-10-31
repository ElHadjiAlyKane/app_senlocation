import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components"

Page {
    id: addPropertyPage

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
                text: "Ajouter une propriété"
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
                        text: "Informations de la propriété"
                        font.pixelSize: 20
                        font.bold: true
                        color: "#333333"
                    }

                    CustomTextField {
                        id: titleField
                        Layout.fillWidth: true
                        placeholderText: "Titre de la propriété"
                    }

                    CustomTextField {
                        id: descriptionField
                        Layout.fillWidth: true
                        placeholderText: "Description"
                    }

                    CustomTextField {
                        id: addressField
                        Layout.fillWidth: true
                        placeholderText: "Adresse"
                    }

                    ComboBox {
                        id: typeComboBox
                        Layout.fillWidth: true
                        model: ["Appartement", "Maison", "Studio", "Villa"]
                        
                        background: Rectangle {
                            border.color: "#CCCCCC"
                            border.width: 1
                            radius: 8
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        CustomTextField {
                            id: bedroomsField
                            Layout.fillWidth: true
                            placeholderText: "Chambres"
                            inputMethodHints: Qt.ImhDigitsOnly
                        }

                        CustomTextField {
                            id: bathroomsField
                            Layout.fillWidth: true
                            placeholderText: "Salles de bain"
                            inputMethodHints: Qt.ImhDigitsOnly
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        CustomTextField {
                            id: areaField
                            Layout.fillWidth: true
                            placeholderText: "Surface (m²)"
                            inputMethodHints: Qt.ImhDigitsOnly
                        }

                        CustomTextField {
                            id: priceField
                            Layout.fillWidth: true
                            placeholderText: "Prix (FCFA/mois)"
                            inputMethodHints: Qt.ImhDigitsOnly
                        }
                    }

                    CheckBox {
                        id: availableCheckbox
                        text: "Disponible immédiatement"
                        checked: true
                    }

                    CustomButton {
                        Layout.fillWidth: true
                        Layout.topMargin: 20
                        text: "Ajouter la propriété"
                        primary: true
                        onClicked: {
                            if (validateForm()) {
                                var propertyData = {
                                    "title": titleField.text,
                                    "description": descriptionField.text,
                                    "address": addressField.text,
                                    "type": typeComboBox.currentText,
                                    "bedrooms": parseInt(bedroomsField.text),
                                    "bathrooms": parseInt(bathroomsField.text),
                                    "area": parseFloat(areaField.text),
                                    "price": parseFloat(priceField.text),
                                    "available": availableCheckbox.checked
                                }
                                propertyManager.addProperty(propertyData)
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
        if (!titleField.text) {
            errorText.text = "Le titre est requis"
            return false
        }
        if (!descriptionField.text) {
            errorText.text = "La description est requise"
            return false
        }
        if (!addressField.text) {
            errorText.text = "L'adresse est requise"
            return false
        }
        if (!bedroomsField.text || !bathroomsField.text) {
            errorText.text = "Veuillez remplir tous les champs"
            return false
        }
        if (!areaField.text || !priceField.text) {
            errorText.text = "Veuillez remplir tous les champs"
            return false
        }
        errorText.text = ""
        return true
    }

    Connections {
        target: propertyManager
        function onPropertyAdded() {
            stackView.pop()
        }
        function onOperationFailed(error) {
            errorText.text = error
        }
    }
}
