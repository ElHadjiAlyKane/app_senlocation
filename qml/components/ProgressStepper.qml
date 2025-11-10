import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    id: progressStepper

    property var steps: []
    property int currentStep: 0

    implicitHeight: 100

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Repeater {
            model: steps

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 12

                    // Step indicator row
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 0

                        // Circle
                        Rectangle {
                            Layout.preferredWidth: 40
                            Layout.preferredHeight: 40
                            radius: 20
                            color: getStepColor(index)
                            border.color: "#FFFFFF"
                            border.width: 2

                            Text {
                                anchors.centerIn: parent
                                text: getStepIcon(index)
                                font.pixelSize: 18
                                color: "white"
                            }
                        }

                        // Connecting line (except for last step)
                        Rectangle {
                            Layout.fillWidth: true
                            Layout.preferredHeight: 3
                            color: index < currentStep ? "#4CAF50" : "#E0E0E0"
                            visible: index < steps.length - 1
                        }
                    }

                    // Step label
                    Text {
                        text: modelData.label || ""
                        font.pixelSize: 12
                        font.bold: index === currentStep
                        color: index <= currentStep ? "#333333" : "#999999"
                        wrapMode: Text.WordWrap
                        horizontalAlignment: Text.AlignHCenter
                        Layout.fillWidth: true
                        Layout.preferredWidth: 80
                    }

                    // Step description
                    Text {
                        text: modelData.description || ""
                        font.pixelSize: 10
                        color: "#666666"
                        wrapMode: Text.WordWrap
                        horizontalAlignment: Text.AlignHCenter
                        Layout.fillWidth: true
                        visible: index === currentStep
                    }
                }
            }
        }
    }

    function getStepColor(index) {
        if (index < currentStep) {
            return "#4CAF50" // Completed
        } else if (index === currentStep) {
            return "#2196F3" // Current
        } else {
            return "#E0E0E0" // Future
        }
    }

    function getStepIcon(index) {
        if (index < currentStep) {
            return "✓"
        } else {
            return (index + 1).toString()
        }
    }
}
