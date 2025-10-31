import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components"

Page {
    id: rentalAgreementPage

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
                text: "Contrats de location"
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

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20
        spacing: 20

        CustomButton {
            Layout.fillWidth: true
            text: "Créer un nouveau contrat"
            primary: true
            visible: authManager.userRole === "landlord" || authManager.userRole === "lawyer"
            onClicked: newAgreementDialog.open()
        }

        ListView {
            id: agreementsList
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 10
            clip: true

            model: ListModel {
                id: agreementsModel
            }

            delegate: Rectangle {
                width: agreementsList.width
                height: 120
                radius: 10
                color: "white"
                border.color: "#E0E0E0"
                border.width: 1

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 15
                    spacing: 8

                    Text {
                        text: model.propertyTitle
                        font.pixelSize: 18
                        font.bold: true
                        color: "#333333"
                    }

                    Text {
                        text: "Bailleur: " + model.landlordName
                        font.pixelSize: 14
                        color: "#666666"
                    }

                    Text {
                        text: "Locataire: " + model.tenantName
                        font.pixelSize: 14
                        color: "#666666"
                    }

                    Text {
                        text: "Durée: " + model.duration + " mois"
                        font.pixelSize: 14
                        color: "#666666"
                    }

                    Text {
                        text: "Statut: " + model.status
                        font.pixelSize: 14
                        font.bold: true
                        color: model.status === "Actif" ? "#4CAF50" : "#999999"
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        // TODO: Show agreement details
                    }
                }
            }

            ScrollBar.vertical: ScrollBar {}
        }

        Text {
            visible: agreementsList.count === 0
            text: "Aucun contrat disponible"
            font.pixelSize: 18
            color: "#999999"
            Layout.alignment: Qt.AlignHCenter
        }
    }

    Dialog {
        id: newAgreementDialog
        title: "Nouveau contrat de location"
        modal: true
        anchors.centerIn: parent
        width: parent.width * 0.9

        ColumnLayout {
            spacing: 15
            width: parent.width

            CustomTextField {
                id: propertyIdField
                Layout.fillWidth: true
                placeholderText: "ID de la propriété"
            }

            CustomTextField {
                id: tenantIdField
                Layout.fillWidth: true
                placeholderText: "ID du locataire"
            }

            CustomTextField {
                id: durationField
                Layout.fillWidth: true
                placeholderText: "Durée (mois)"
                inputMethodHints: Qt.ImhDigitsOnly
            }

            CustomTextField {
                id: startDateField
                Layout.fillWidth: true
                placeholderText: "Date de début (AAAA-MM-JJ)"
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 10

                CustomButton {
                    Layout.fillWidth: true
                    text: "Annuler"
                    onClicked: newAgreementDialog.close()
                }

                CustomButton {
                    Layout.fillWidth: true
                    text: "Créer"
                    primary: true
                    onClicked: {
                        var agreementData = {
                            "propertyId": propertyIdField.text,
                            "tenantId": tenantIdField.text,
                            "duration": parseInt(durationField.text),
                            "startDate": startDateField.text
                        }
                        userManager.createRentalAgreement(agreementData)
                        newAgreementDialog.close()
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        userManager.fetchRentalAgreements()
    }

    Connections {
        target: userManager
        function onRentalAgreementCreated() {
            userManager.fetchRentalAgreements()
        }
    }
}
