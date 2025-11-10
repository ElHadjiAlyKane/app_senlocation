import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id: mediatorBadge

    property bool verified: false
    property double rating: 0.0
    property int casesHandled: 0

    implicitWidth: content.width + 24
    implicitHeight: content.height + 16
    radius: 8
    color: verified ? "#E8F5E9" : "#F5F5F5"
    border.color: verified ? "#4CAF50" : "#E0E0E0"
    border.width: 1

    RowLayout {
        id: content
        anchors.centerIn: parent
        spacing: 8

        // Verification icon
        Text {
            text: verified ? "✓" : "⚠"
            font.pixelSize: 16
            color: verified ? "#4CAF50" : "#FF9800"
        }

        ColumnLayout {
            spacing: 2

            Text {
                text: verified ? "Médiateur Vérifié" : "Non vérifié"
                font.pixelSize: 12
                font.bold: true
                color: verified ? "#4CAF50" : "#FF9800"
            }

            RowLayout {
                spacing: 6

                // Star rating
                RowLayout {
                    spacing: 2

                    Repeater {
                        model: 5

                        Text {
                            text: index < Math.floor(rating) ? "⭐" : "☆"
                            font.pixelSize: 10
                            color: "#FFB300"
                        }
                    }

                    Text {
                        text: rating.toFixed(1)
                        font.pixelSize: 10
                        color: "#666666"
                    }
                }

                Text {
                    text: "•"
                    font.pixelSize: 10
                    color: "#CCCCCC"
                }

                Text {
                    text: casesHandled + " cas"
                    font.pixelSize: 10
                    color: "#666666"
                }
            }
        }
    }
}
