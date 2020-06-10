import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3

Rectangle {
    width: parent.width
    height: 50
    color: "#FAFAFA"
    property alias button: __toolbtn
    property alias text: __text
    RowLayout {
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: 5
        spacing: -1
        ToolButton {
            id: __toolbtn
            text: "‫‪\uf0c9" // hamburger icon
            font.pixelSize: 20
            font.family: "fontello"
            contentItem: Text{
                text: __toolbtn.text
                font: __toolbtn.font
                color: "#616161"
                leftPadding: 8
                topPadding: 8
            }
        }
        Label {
//            Layout.leftMargin: -10
            id: __text
            text: "5Toman"
            color: "#212121"
            font.bold: Font.Bold
        }
    }
}
