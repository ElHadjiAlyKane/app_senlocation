import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components"

Page {
    id: mediationDetail
    objectName: "mediationDetail"

    property int mediationId: 0
    property var mediationData: null

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
                text: "Médiation #" + mediationId
                font.pixelSize: 20
                font.bold: true
                color: "white"
                Layout.fillWidth: true
            }

            ToolButton {
                text: "📊"
                onClicked: stackView.push("MediationReportPage.qml", {mediationId: mediationId})
            }
        }
    }

    Component.onCompleted: {
        loadMediationDetails()
    }

    ScrollView {
        anchors.fill: parent
        contentWidth: availableWidth
        clip: true

        ColumnLayout {
            width: parent.width
            spacing: 16

            // Status banner
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 60
                color: getStatusColor()

                Text {
                    anchors.centerIn: parent
                    text: getStatusText()
                    font.pixelSize: 18
                    font.bold: true
                    color: "white"
                }
            }

            // Parties information
            Rectangle {
                Layout.fillWidth: true
                Layout.margins: 16
                Layout.preferredHeight: partiesColumn.height + 32
                radius: 12
                color: "white"

                ColumnLayout {
                    id: partiesColumn
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 16

                    Text {
                        text: "Parties concernées"
                        font.pixelSize: 18
                        font.bold: true
                        color: "#333333"
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 16

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 8

                            Text {
                                text: "Bailleur"
                                font.pixelSize: 12
                                color: "#999999"
                            }
                            Text {
                                text: mediationData ? mediationData.landlordName : ""
                                font.pixelSize: 16
                                font.bold: true
                                color: "#333333"
                            }
                        }

                        Text {
                            text: "⚖️"
                            font.pixelSize: 32
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 8

                            Text {
                                text: "Locataire"
                                font.pixelSize: 12
                                color: "#999999"
                            }
                            Text {
                                text: mediationData ? mediationData.tenantName : ""
                                font.pixelSize: 16
                                font.bold: true
                                color: "#333333"
                            }
                        }
                    }
                }
            }

            // Sessions timeline
            Rectangle {
                Layout.fillWidth: true
                Layout.margins: 16
                Layout.preferredHeight: sessionsColumn.height + 32
                radius: 12
                color: "white"

                ColumnLayout {
                    id: sessionsColumn
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 16

                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "Séances de médiation"
                            font.pixelSize: 18
                            font.bold: true
                            color: "#333333"
                            Layout.fillWidth: true
                        }

                        Button {
                            text: "+ Nouvelle séance"
                            onClicked: stackView.push("MediationSessionPage.qml", {mediationId: mediationId})
                        }
                    }

                    SessionTimeline {
                        Layout.fillWidth: true
                        sessions: mediationData ? mediationData.sessions : []
                    }
                }
            }

            // Actions
            Rectangle {
                Layout.fillWidth: true
                Layout.margins: 16
                Layout.preferredHeight: actionsColumn.height + 32
                radius: 12
                color: "white"

                ColumnLayout {
                    id: actionsColumn
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 12

                    Text {
                        text: "Actions"
                        font.pixelSize: 18
                        font.bold: true
                        color: "#333333"
                    }

                    CustomButton {
                        Layout.fillWidth: true
                        text: "✅ Enregistrer un accord"
                        primary: true
                        onClicked: recordAgreement()
                    }

                    CustomButton {
                        Layout.fillWidth: true
                        text: "❌ Déclarer un échec"
                        onClicked: recordFailure()
                    }

                    CustomButton {
                        Layout.fillWidth: true
                        text: "⚖️ Escalader vers la justice"
                        onClicked: escalateToLegal()
                    }
                }
            }

            Item {
                Layout.preferredHeight: 24
            }
        }
    }

    function loadMediationDetails() {
        // Sample data for demo
        mediationData = {
            id: mediationId,
            landlordName: "Amadou Diop",
            tenantName: "Fatou Sall",
            status: "in_progress",
            sessions: [
                {number: 1, date: "2025-11-05", status: "completed", notes: "Première rencontre - présentation des griefs"},
                {number: 2, date: "2025-11-08", status: "scheduled", notes: "Discussion sur les solutions possibles"}
            ]
        }
    }

    function getStatusColor() {
        if (!mediationData) return "#CCCCCC"
        const colors = {
            "pending": "#FFF3E0",
            "in_progress": "#FF9800",
            "success": "#4CAF50",
            "failed": "#F44336",
            "escalated": "#9C27B0"
        }
        return colors[mediationData.status] || "#CCCCCC"
    }

    function getStatusText() {
        if (!mediationData) return ""
        const texts = {
            "pending": "En attente",
            "in_progress": "En cours",
            "success": "Réussie",
            "failed": "Échouée",
            "escalated": "Escaladée"
        }
        return texts[mediationData.status] || mediationData.status
    }

    function recordAgreement() {
        var agreementData = {mediationId: mediationId}
        mediationManager.recordAgreement(mediationId, agreementData)
    }

    function recordFailure() {
        var failureData = {mediationId: mediationId}
        mediationManager.recordFailure(mediationId, failureData)
    }

    function escalateToLegal() {
        var legalData = {mediationId: mediationId}
        mediationManager.escalateToLegal(mediationId, legalData)
    }
}
