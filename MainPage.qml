import QtQuick 2.14
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.2

Page{
    width: mainwindow.width
    height: mainwindow.height

    Rectangle {
        anchors.fill: parent
        color: "#FAFAFA"
    }

    Image {
        id: dropimage
        source: "pic/drop.png"
        anchors.horizontalCenter: parent.horizontalCenter
        property real staticY: parent.width / 2 - parent.height / 1.3
        y: staticY
        width: parent.width / 2.4
        height: parent.width / 2.4
        MouseArea {
            anchors.fill: parent
            onClicked: filedialog.open()
        }
    }
    Label {
        id: droptext1
        y: parent.width / 2.4
        anchors.horizontalCenter: dropimage.horizontalCenter
        color: "#039BE5"
        font.bold: Font.ExtraBold
        font.pixelSize: 40
        text: "COMPRESSOR"
    }

    Label {
        id: droptext2
        anchors.top: droptext1.bottom
        anchors.topMargin: 3
//        y: parent.width / 2
        anchors.horizontalCenter: dropimage.horizontalCenter
        text: "Drop your file here or click to choose one"
        color: "#424242"
        font.bold: Font.Bold
        font.pixelSize: 15

    }

    Row {
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 2
        anchors.horizontalCenter: parent.horizontalCenter
        Label {
            text: "Made With"
            font.bold: Font.Medium
            color: "#616161"
        }
        Label {
            text: " \ue806 "
            font.family: "fontello"
            color: "#D32F2F"
            font.bold: Font.Medium
        }
        Label {
            text: "By SeedPuller & Max Base"
            font.bold: Font.Medium
            color: "#616161"
        }
    }

    FileDialog {
        id: filedialog
        onAccepted: {
            var url = String(filedialog.fileUrl).split("/")
            mainmodel.prepareAndInsert(filedialog.fileUrl)
//            mainwindow.filePaths.push(filedialog.fileUrl)
            stackView.push(secondpage)
        }
    }
    DropArea {
        id: droparea1
        anchors.fill: parent
        onDropped: {
            state = "normal"
            var url = String(drop.urls[0]).split("/")
            mainmodel.prepareAndInsert(drop.urls[0])
            stackView.push(secondpage)
        }
        onEntered: {
            state = "up"
        }
        onExited: {
            state = "normal"
        }

        states: [
            State {
                name: "up"
                PropertyChanges {
                    target: dropimage
                    y: dropimage.staticY - 35
                }
            },
            State {
                name: "normal"
                PropertyChanges {
                    target: dropimage
                    y: dropimage.staticY
                }
            }
        ]

        transitions: [
            Transition {
                from: "normal"
                to: "up"
                NumberAnimation {
                    target: dropimage
                    property: "y"
                    duration: 300
                    easing.type: Easing.OutExpo
                }
            },
            Transition {
                from: "up"
                to: "normal"

                NumberAnimation {
                    target: dropimage
                    property: "y"
                    duration: 1000
                    easing.type: Easing.OutBounce
                }
            }
        ]
    }
}
