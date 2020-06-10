import QtQuick 2.12
import QtQuick.Controls 2.14
import QtQuick.Layouts 1.12
import QtQuick.Dialogs 1.2
import API.FileProcessor 1.0

Page {
    id: secpage
    width: mainwindow.width
    height: mainwindow.height
    property bool processing: false
    Keys.onDeletePressed: filelist.removeMode ? filelist.removeIndexList() : 0

    MyToolBar {
        id: toolbar
        button.visible: false
        anchors.left: parent.left
        anchors.leftMargin: 10
        text.color: "#616161"
        text.text: "Compressor"
        text.font.pixelSize: 16
        MyButton {
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            enabled: !cancelbutton.enabled
            text: "Compose"
            width: 100
            height: 40
            bgitem.color: "#039BE5"
            bgitem.border.width: 1
            bgitem.border.color: "#0288D1"
            bgitem.radius: 7
            contentText.color: "#FFFFFF"
            font.bold: Font.Medium
            font.pixelSize: 13
            texticon.text: "\ue805"
            texticon.visible: true
            onClicked: filedialog.open()
        }
    }

    Rectangle {
        anchors.top: toolbar.bottom
        width: parent.width
        height: 2
        color: "#EEEEEE"
    }

    RowLayout {
        id: titles
        anchors.top: toolbar.bottom
        anchors.left: parent.left
        width: parent.width
        height: 60
        anchors.leftMargin: 30

        Text {
            text: "Name"
            font.bold: Font.Bold
            font.pixelSize: 15
            Layout.preferredWidth: 27
            color: "#424242"

        }
        Text {
            text: "Size"
            font.bold: Font.Bold
            font.pixelSize: 15
            Layout.preferredWidth: 12
            color: "#424242"

        }
        Text {
            text: "Type"
            font.bold: Font.Bold
            font.pixelSize: 15
            Layout.preferredWidth: 9
            color: "#424242"

        }
        Text {
            text: "MimeType"
            font.bold: Font.Bold
            font.pixelSize: 15
            Layout.preferredWidth: 13
            color: "#424242"

        }
    }

    Rectangle {
        id: titlesline
        anchors.top: titles.bottom
        x: 8
        width: parent.width - 16
        height: 2
        color: "#EEEEEE"
//        opacity: 0.9
    }

    Rectangle {
        id: filelistbackground
        width: parent.width
        anchors.top: titlesline.bottom
        anchors.topMargin: 5
        height: footerrect.y - titlesline.y
        color: "#FAFAFA"
        FileView { id: filelist }
    }



    StaticProgressBar { id: staticcanvas }
    DynamicProgressBar { id: progresscanvas }

    Rectangle {
        id: footerrect
        width: parent.width
        height: 80
        property bool isenabled: height != 0 ? true : false
        anchors.bottom: parent.bottom
        color: "#FAFAFA"
        Behavior on height {
            NumberAnimation {
                duration: 300
            }
        }

        Label {
            id: compressionratetext
            anchors.bottom: compressionrate.top
            anchors.bottomMargin: -10
            anchors.horizontalCenter: compressionrate.horizontalCenter
            property var cstates: ["Low", "Medium", "Extreme"]
            text: "Compression Rate: " + cstates[compressionrate.value]
            font.bold: Font.Bold
            color: "#424242"
        }

        Slider {
            id: compressionrate
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 5
            anchors.horizontalCenter: parent.horizontalCenter
            from: 0
            to: 2
            stepSize: 1
            snapMode: Slider.SnapOnRelease
        }

        MyButton {
            id: startbutton
            enabled: filelist.removeMode || secpage.processing ? false : true
            anchors.right: cancelbutton.left
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            text: "Compress"
            width: 120
            height: 50
            bgitem.color: "#039BE5"
            bgitem.border.width: 1
            bgitem.border.color: "#0288D1"
            bgitem.radius: 7
            contentText.color: "#FFFFFF"
            font.bold: Font.Medium

            font.pixelSize: 15
            onClicked:  {
                filep.started = true
                secpage.processing = true
//                startbutton.enabled = false
//                filep.startprocess()
            }
        }

        // don't know how this button should cancel the real compression
        MyButton {
            id: cancelbutton
            enabled: !startbutton.enabled
            width: 120
            height: 50
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.verticalCenter: parent.verticalCenter

            text: filelist.removeMode ? "Remove" : "Cancel"
            bgitem.color: "transparent"
            bgitem.radius: 7
            contentText.color: "#D32F2F"
            bgitem.border.color: "#D32F2F"
            font.bold: Font.Medium
            font.pixelSize: 15
            texticon.visible: true
            texticon.text: "\ue800"
            texticon.font.pixelSize: 18
            onClicked:  {
                if (filelist.removeMode) {
                    filelist.removeIndexList()
                    return
                }
                filep.started = false
//                startbutton.enabled = true
                secpage.processing = false
                progresscanvas.value = 0
                progresscanvas.requestPaint()
            }
        }

        Rectangle {
            id: estimatedtime
            width: 150
            height: 30
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 20
            color: "transparent"
            radius: 10
            Text {
                id: estimatedtimetext
                anchors.centerIn: parent
                text: "Estimated Size: 5MB"
                font.bold: Font.Bold
                font.pixelSize: 15
                color: "#424242"
            }
        }
    }

    FileProcessor {
        id: filep
        property bool started: false
        function startprocess() {
            var count = filelist.count
            filep.started = true
            var percent = 100 / count
            for (var i=0; i < count; ++i) {
                if (filep.copy(mainmodel.getFileInfo(i))){
                    progresscanvas.value += percent
                    progresscanvas.requestPaint()
                }
            }
            startbutton.enabled = true
            progresscanvas.value = 0
            progresscanvas.requestPaint()
            popup.open()
        }
    }

    // comment whole this component and use FileProcessor for performing actual compressing
    // and real progressbar job
    Timer {
        id: timer
        interval: 200
        onTriggered: {
            if (!filep.started) {
                return
            }

            if (progresscanvas.value >= 100) {
                filep.started = false
                popup.open()
                startbutton.enabled = true
                progresscanvas.value = 0
                progresscanvas.requestPaint()
                return
            }
            var value = progresscanvas.value
            value += 4
            value = value > 100 ? 100 : value
            progresscanvas.value = value
            progresscanvas.requestPaint()
        }
        repeat: true
        running: true
    }

    Popup {
        id: popup
        width: mainwindow.width * 0.8 ; height: mainwindow.height * 0.7
        anchors.centerIn: parent
        focus: true
        modal: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside
        background: Rectangle {
            anchors.fill: parent
            border.width: 5
            border.color: "#1C70E4"
            radius: 10
            Image {
                id: completeimg
                asynchronous: true
                source: "pic/Group 10.svg"
                anchors.centerIn: parent
                width: parent.width / 3
                height: parent.height / 3
            }
            Label {
                anchors.bottom: completeimg.top
                anchors.bottomMargin: 20
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Hooray! Job Done!"
                font.bold: Font.Bold
                font.pixelSize: 30
            }
            MyButton {
                anchors.top: completeimg.bottom
                anchors.topMargin: 20
                anchors.horizontalCenter: parent.horizontalCenter
                width: 200
                height: 70
                text: "OK"
                bgitem.color: "#1C70E4"
                bgitem.radius: 10
                contentText.color: "#FFFFFF"
                font.bold: Font.Bold
                font.pixelSize: 20
                onClicked:  {
                    popup.close()
//                    stackView.pop()
                }
            }
        }
    }

    ListModel {
        id: model1
        ListElement {
            filename: "Desktop/2020-04-05_22-48.jpg"
            size: "45 GB"
            type: "JPG"
            mimetype: "image/jpeg"
        }
        ListElement {
            filename: "Desktop/new.jpg"
            size: "45 GB"
            type: "JPG"
            mimetype: "image/jpeg"
        }
        ListElement {
            filename: "Desktop/new.jpg"
            size: "45 GB"
            type: "JPG"
            mimetype: "image/jpeg"
        }
        ListElement {
            filename: "Desktop/new.jpg"
            size: "45 GB"
            type: "JPG"
            mimetype: "image/jpeg"
        }
        ListElement {
            filename: "Desktop/new.jpg"
            size: "45 GB"
            type: "JPG"
            mimetype: "image/jpeg"
        }
        ListElement {
            filename: "Desktop/new.jpg"
            size: "45 GB"
            type: "JPG"
            mimetype: "image/jpeg"
        }
        ListElement {
            filename: "Desktop/new.jpg"
            size: "45 GB"
            type: "JPG"
            mimetype: "image/jpeg"
        }
        ListElement {
            filename: "Desktop/new.jpg"
            size: "45 GB"
            type: "JPG"
            mimetype: "image/jpeg"
        }
        ListElement {
            filename: "Desktop/new.jpg"
            size: "45 GB"
            type: "JPG"
            mimetype: "image/jpeg"
        }

    }
    FileDialog {
        id: filedialog
        folder: shortcuts.home + "/Pictures"
        onAccepted: {
            var url = String(filedialog.fileUrl).split("/")
//            model1.insert(0, {filename: url[url.length - 1], size: "10GB", type: "JPG"})
            mainmodel.prepareAndInsert(filedialog.fileUrl)
        }
    }

    Rectangle {
        id: dropshadow
        color: "#212121"
        opacity: 0.0
        anchors.fill: parent
        z: 2
        Label {
            anchors.centerIn: parent
            text: "Drop Here"
            font.bold: Font.ExtraBold
            font.pixelSize: 45
        }
        Behavior on opacity {
            NumberAnimation {
                duration: 100
            }
        }
    }

    DropArea {
        id: droparea
        anchors.fill: parent
        onDropped: {
            dropshadow.opacity = 0.0
            var url = String(drop.urls[0]).split("/")
//            model1.insert(0, {filename: url[url.length - 2] + "/" + url[url.length - 1], size: "10GB", type: "JPG", mimetype: "image/jpeg"})
            mainmodel.prepareAndInsert(drop.urls[0])
        }
        onEntered: {
            dropshadow.opacity = 0.6
        }
        onExited: {
            dropshadow.opacity = 0.0
        }
    }
}
