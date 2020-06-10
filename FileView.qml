import QtQuick 2.12
import QtQuick.Controls 2.12

ListView {
    id: root
    anchors.fill: parent
    boundsBehavior: Flickable.OvershootBounds
    bottomMargin: 26
    ScrollIndicator.vertical: ScrollIndicator { }
    property bool removeMode: fileIndex.length > 0 ? true : false
    property var fileIndex: []
    clip: true
    model: mainmodel
//    model: model1
    delegate: FileDelegate { }
    add: Transition {
        NumberAnimation {
            property: "x"
            from: -300
            duration: 200
        }
    }

    removeDisplaced: Transition {
        NumberAnimation {
            properties: "y"
            duration: 400
        }
    }
    addDisplaced: Transition {
        NumberAnimation {
            properties: "y"
            duration: 200
        }
    }
    remove: Transition {
        NumberAnimation {
            property: "x"
            to: -parent.width
            duration: 200
        }
    }

    function removeIndexList() {
        fileIndex.sort()
        for (var i = 0; i < fileIndex.length; ++i) {
            mainmodel.remove(fileIndex[i] - i)
        }
        fileIndex = []
        removeMode = false
    }
}
