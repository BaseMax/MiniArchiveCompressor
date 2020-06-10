import QtQuick 2.0
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.14

Item {
    width: filelist.width
    height: 50
    Rectangle {
        id: delegatebackground
        anchors.centerIn: parent
        width: parent.width
//        width: 0
        height: 48
//        color: "#039BE5"
    }

    Rectangle {
//                    color: "#039BE5"
        color: "transparent"
        width: parent.width
        height: 48
        anchors.left: parent.left
        anchors.leftMargin: 20
        radius: 10
        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 15
            spacing: 15
//            Text {
//                Layout.preferredWidth: 15
//                color: "#616161"
//                text: "\uf15b"
//                font.family: "fontello"
//                font.pixelSize: 20
//            }
            CheckBox {
                id: checkbox
                Layout.preferredWidth: 15
                Layout.rightMargin: -15
//                checked: true
            }

            Text {
                id: fname
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: 30
                color: "#616161"
                text: model.filename
                font.pixelSize: 15
            }

            Text {
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: 15
                color: "#616161"
                text: model.size
                font.pixelSize: 15
            }
            Text {
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: 10
                color: "#616161"
                text: model.type
                font.pixelSize: 15
            }
            Text {
                Layout.alignment: Qt.AlignVCenter
                Layout.preferredWidth: 15
                color: "#616161"
                text: model.mimetype
                font.pixelSize: 15
            }
        }
        states: [
            State {
                name: "choosed"
                PropertyChanges {
                    target: delegatebackground
//                    color: "#D32F2F"
                    color: "#039BE5"
                }
                PropertyChanges {
                    target: delegatebackground
                    width: parent.width
                }
                PropertyChanges {
                    target: delegatebackground
                    opacity: 0.5
                }
            },
            State {
                name: "not-choosed"
                PropertyChanges {
                    target: delegatebackground
                    color: "transparent"
                }
            }
        ]
        transitions: [
            Transition {
                from: "not-choosed"
                to: "choosed"

                ColorAnimation {
//                    from: "white"
//                    to: "black"
                    duration: 200
                }
                PropertyAnimation {
//                    target: delegatebackground
                    property: "width"
                    from: 0
                    duration: 150
                    easing: Easing.OutQuart
                }
            },
            Transition {
                from: "choosed"
                to: "not-choosed"

                ColorAnimation {
                    target: delegatebackground
                    duration: 200
                    easing: Easing.OutQuart
                }
//                PropertyAnimation {
////                    target: delegatebackground
//                    property: "width"
//                    duration: 200
////                    easing:
//                }
            }
        ]
        state: checkbox.checked ? "choosed" : "not-choosed"
        onStateChanged: {
            if (state == "choosed") {
              filelist.fileIndex.push(index)
                filelist.removeMode = true
                return
            }
            filelist.fileIndex.splice(filelist.fileIndex.indexOf(index), 1)
            filelist.removeMode = fileIndex.length > 0 ? true : false
        }
    }
}
