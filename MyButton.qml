import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Button {
    id: root
    text: "Button"
    font.capitalization: Font.MixedCase
    property alias bgitem: __background
//    property alias bgborder: __background.border
    property alias contentText: __text
    property alias area: __mousearea
    property alias texticon: __icon
    signal clicked()
    opacity: enabled ? 1.0 : 0.5
    contentItem: Item {
        RowLayout {
            anchors.centerIn: parent
            opacity: {
                if(__mousearea.containsPress){
                    return 0.5
                }
                if(__mousearea.containsMouse){
                    return 0.7
                }
                return 1
            }
            Text {
                id: __icon
                visible: false
//                anchors.right: __text.left
//                anchors.rightMargin: 2
                Layout.bottomMargin: 3
                font.family: "fontello"
                text: "\ue802"
                color: __text.color
            }

            Text {
                id: __text
                text: root.text
                font: root.font
                color: "#f5f5f5"
            }
        }
    }

    background: Rectangle {
        id: __background
        implicitHeight: 30
        implicitWidth: 50
        color: __mousearea.containsPress ? Qt.darker("#3fc1c9") : "#3fc1c9"
        opacity: !root.enabled ? 0.3 : 1
        MouseArea {
            id: __mousearea
            anchors.fill: parent
           // hoverEnabled: true
       //     preventStealing: true
//            onEntered: {
//                __background.opacity = 0.7
//            }

            onExited: __background.opacity = 1
            onPressed: __background.opacity = 0.7
            onReleased: __background.opacity = 1.0
            onClicked: {
                root.clicked()
            }
        }
        radius: 3
        border.width: 0.5
        border.color: Qt.lighter(color)
    }
}
