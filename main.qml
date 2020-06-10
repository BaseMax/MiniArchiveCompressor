import QtQuick 2.12
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.2
import API.Model 1.0

ApplicationWindow {
    id: mainwindow
    visible: true
    width: 890
    height: 550
    minimumWidth: 640
    minimumHeight: 350
    title: qsTr("Compressor")
    FontLoader { source: "font/fontello.ttf" }
    Model { id: mainmodel }

    StackView {
        id: stackView

        initialItem: mainpage
        anchors.fill: parent
    }

    Component {
        id: secondpage
        SecondPage { }
    }

    Component {
        id: mainpage
        MainPage { }
    }

}

