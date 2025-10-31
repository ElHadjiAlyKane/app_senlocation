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
}
