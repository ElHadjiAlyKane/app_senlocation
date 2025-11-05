import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

Window {
    id: mainWindow
    width: 400
    height: 800
    visible: true
    title: qsTr("SenLocation")

    color: "#f5f5f5"

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: authManager.isAuthenticated ? homePageComponent : loginPageComponent
        focus: true

        Component {
            id: loginPageComponent
            LoginPage {}
        }

        Component {
            id: homePageComponent
            HomePage {}
        }

        Component {
            id: registerPageComponent
            RegisterPage {}
        }

        Component {
            id: propertyListPageComponent
            PropertyListPage {}
        }

        Component {
            id: propertyDetailPageComponent
            PropertyDetailPage {}
        }

        Component {
            id: addPropertyPageComponent
            AddPropertyPage {}
        }

        Component {
            id: rentalAgreementPageComponent
            RentalAgreementPage {}
        }

        Component {
            id: profilePageComponent
            ProfilePage {}
        }

        Keys.onBackPressed: {
            event.accepted = true
            handleBackButton()
        }
    }

    Connections {
        target: authManager
        function onAuthenticationChanged() {
            if (authManager.isAuthenticated) {
                stackView.replace(homePageComponent)
            } else {
                stackView.replace(loginPageComponent)
            }
        }
    }

    // Exit confirmation dialog
    Dialog {
        id: exitDialog
        title: "Quitter l'application"
        modal: true
        anchors.centerIn: parent
        standardButtons: Dialog.No | Dialog.Yes

        Label {
            text: "Voulez-vous vraiment quitter ?"
        }

        onAccepted: {
            Qt.quit()
        }
    }

    function handleBackButton() {
        // If we can go back in the stack, do it
        if (stackView.depth > 1) {
            stackView.pop()
            return
        }

        // Otherwise, check which page we're on
        var currentItem = stackView.currentItem
        if (currentItem) {
            var objName = currentItem.objectName
            // On home page or login page, show exit dialog
            if (objName === "homePage" || objName === "loginPage") {
                exitDialog.open()
            }
        }
    }

    Component.onCompleted: {
        stackView.forceActiveFocus()
    }
}
