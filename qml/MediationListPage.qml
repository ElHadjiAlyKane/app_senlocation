import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import "components"

Page {
    id: mediationList
    objectName: "mediationList"

    property bool showEligible: false

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
                text: showEligible ? "Litiges éligibles" : "Mes médiations"
                font.pixelSize: 20
                font.bold: true
                color: "white"
                Layout.fillWidth: true
            }

            ToolButton {
                text: "🔄"
                onClicked: loadMediations()
            }
        }
    }

    background: Rectangle {
        color: "#f5f5f5"
    }

    Component.onCompleted: {
        loadMediations()
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // Filter tabs
        TabBar {
            id: filterTabs
            Layout.fillWidth: true
            visible: !showEligible

            TabButton {
                text: "Toutes"
                onClicked: currentFilter = "all"
            }
            TabButton {
                text: "En cours"
                onClicked: currentFilter = "in_progress"
            }
            TabButton {
                text: "Réussies"
                onClicked: currentFilter = "success"
            }
            TabButton {
                text: "Échouées"
                onClicked: currentFilter = "failed"
            }
        }

        // Mediations list
        ListView {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 12
            clip: true

            model: filteredMediations

            delegate: MediationCard {
                width: ListView.view.width - 32
                anchors.horizontalCenter: parent.horizontalCenter
                mediation: modelData
                onClicked: stackView.push("MediationDetailPage.qml", {mediationId: modelData.id})
            }

            header: Item {
                width: parent.width
                height: 16
            }

            footer: Item {
                width: parent.width
                height: 16
            }

            // Empty state
            Rectangle {
                anchors.centerIn: parent
                width: parent.width - 64
                height: emptyColumn.height + 48
                radius: 12
                color: "white"
                visible: filteredMediations.length === 0

                ColumnLayout {
                    id: emptyColumn
                    anchors.centerIn: parent
                    spacing: 16

                    Text {
                        text: "📋"
                        font.pixelSize: 64
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: showEligible ? "Aucun litige éligible" : "Aucune médiation trouvée"
                        font.pixelSize: 18
                        font.bold: true
                        color: "#333333"
                        Layout.alignment: Qt.AlignHCenter
                    }

                    Text {
                        text: showEligible ? 
                            "Il n'y a pas de litiges éligibles pour le moment." :
                            "Vous n'avez pas encore de médiations."
                        font.pixelSize: 14
                        color: "#666666"
                        Layout.alignment: Qt.AlignHCenter
                    }
                }
            }
        }
    }

    property var allMediations: []
    property var filteredMediations: []
    property string currentFilter: "all"

    onCurrentFilterChanged: {
        filterMediations()
    }

    function loadMediations() {
        if (showEligible) {
            mediationManager.fetchEligibleDisputes()
        } else {
            // For demo, use sample data
            allMediations = [
                {
                    id: 1,
                    landlordName: "Amadou Diop",
                    tenantName: "Fatou Sall",
                    mediatorName: "Me. Ousmane Sarr",
                    status: "in_progress",
                    createdDate: "2025-11-01"
                },
                {
                    id: 2,
                    landlordName: "Moussa Ndiaye",
                    tenantName: "Awa Kane",
                    mediatorName: "Me. Ousmane Sarr",
                    status: "success",
                    createdDate: "2025-10-28"
                },
                {
                    id: 3,
                    landlordName: "Ibrahima Sarr",
                    tenantName: "Coumba Sy",
                    mediatorName: "Me. Ousmane Sarr",
                    status: "in_progress",
                    createdDate: "2025-10-25"
                }
            ]
            filterMediations()
        }
    }

    function filterMediations() {
        if (currentFilter === "all") {
            filteredMediations = allMediations
        } else {
            filteredMediations = allMediations.filter(function(m) {
                return m.status === currentFilter
            })
        }
    }

    Connections {
        target: mediationManager

        function onEligibleDisputesFetched(disputes) {
            allMediations = disputes
            filterMediations()
        }

        function onOperationFailed(error) {
            console.error("Error loading mediations:", error)
        }
    }
}
