// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import org.hildon.components 1.0

Item {
    id: root

    property alias busy: busyIndicator.visible

    height: 56
    anchors { top: parent.top; left: parent.left; right: parent.right }

    Image {
        id: background

        anchors.fill: parent
        fillMode: Image.Stretch
        smooth: true
        source: "image://theme/wmTitleBar"
    }

    Item {
        id: minimizeButton

        property bool enabled: true

        width: screen.inPortrait ? 70 : 112
        height: 56

        Image {
            id: minimizeBackground

            anchors.fill: parent
            source: "image://theme/wmLeftButtonEndPressed"
            visible: false
        }

        Image {
            id: minimizeSeparator

            anchors { top: parent.top; bottom: parent.bottom; right: parent.right }
            source: "image://theme/wmSeparator"
        }

        Image {
            id: minimizeIcon

            anchors.centerIn: parent
            source: "image://theme/wmTaskSwitcherIcon"
        }

        MouseArea {
            id: minimizeMouseArea

            anchors.fill: parent
            enabled: minimizeButton.enabled
            onClicked: mn.minimize()
        }

        states: State {
            name: "pressed"
            when: minimizeMouseArea.pressed
            PropertyChanges { target: minimizeBackground; visible: true }
            PropertyChanges { target: minimizeIcon; source: "image://theme/wmTaskSwitcherIconPressed" }
        }
        anchors { top: parent.top; left: parent.left }
    }

    Item {
        id: statusArea
        signal pressAndHold
        signal clicked

        width: screen.inPortrait ? 150 : 200
        height: 56

        Image {
            id: statusAreaSeparator

            anchors { top: parent.top; bottom: parent.bottom; right: parent.right }
            source: "image://theme/wmSeparator"
        }

        Label {
            id: timeLabel

            anchors { left: parent.left; leftMargin: platformStyle.paddingNormal; verticalCenter: parent.verticalCenter }
            verticalAlignment: Text.AlignVCenter
            text: system.currentTimeString
        }

        Image {
            id: batteryIndicator

            property variant levels: [100, 88, 75, 63, 50, 38, 25, 13]

            function __setIndicator() {
                var i = 0;
                var set = false;

                while ((!set) && (i < levels.length)) {
                    set = system.batteryLevel >= levels[i];

                    if (set) {
                        source = "image://theme/icon/statusarea_battery_full" + levels[i];
                    }

                    i++;
                }

                if (!set) {
                    source = "image://theme/icon/statusarea_battery_low";
                }
            }

            width: 32
            height: 32
            anchors { right: parent.right; rightMargin: 20 /*platformStyle.paddingNormal*/; verticalCenter: parent.verticalCenter }
            source: "image://theme/icon/statusarea_battery_full100"
        }

        MouseArea {
            id: statusAreaMouseArea

            anchors.fill: parent
            onPressAndHold: statusArea.pressAndHold()
            onClicked: statusArea.clicked()
        }

        Connections {
            target: system
            onBatteryLevelChanged: batteryIndicator.__setIndicator()
        }
        anchors { top: parent.top; left: minimizeButton.right }
    }

    Item {
        id: titleArea

        signal pressAndHold
        signal clicked

        height: 56
        clip: true

        anchors { top: parent.top; left: statusArea.right; right: backButton.left }

        Label {
            id: titleLabel

//            property int maximumWidth: appWindow.busy ? parent.width - busyIndicator.width - platformStyle.paddingNormal * 2  : parent.width - platformStyle.paddingNormal * 2

//            width: paintedWidth < maximumWidth ? paintedWidth : maximumWidth
//            anchors { left: parent.left; leftMargin: platformStyle.paddingNormal; verticalCenter: parent.verticalCenter }
//            verticalAlignment: Text.AlignVCenter
//            clip: true
//            text: appWindow.windowTitle
        }

        Image {
            id: menuIndicator

            anchors { left: titleLabel.right; leftMargin: 5; verticalCenter: parent.verticalCenter }
            source: "image://theme/wmMenuIndicator"
//            visible: (pageStack.currentPage !== null) && (pageStack.currentPage.tools !== null) && (!appWindow.busy) && (titleLabel.paintedWidth <= titleLabel.maximumWidth)
        }

        BusyIndicator {
            id: busyIndicator

            anchors { left: titleLabel.right; leftMargin: 5; verticalCenter: parent.verticalCenter }
            visible: false
        }

        MouseArea {
            id: mouseArea

            anchors.fill: parent
            onPressAndHold: titleArea.pressAndHold()
            onClicked: menu.open()
//            enabled: (pageStack.currentPage !== null) && (pageStack.currentPage.tools !== null)
        }
    }


    Item {
        id: backButton
        property bool enabled: true

        signal pressAndHold
        signal clicked

        width: screen.inPortrait ? 70 : 112
        height: 56

        anchors.right: parent.right

        Image {
            id: backBackground

            anchors.fill: parent
            source: "image://theme/wmRightButtonPressed"
            visible: false
        }

        Image {
            id: backSeparator

            anchors {
                top: parent.top
                bottom: parent.bottom
                left: parent.left
            }
            source: "image://theme/wmSeparator"
        }

        Image {
            id: backIcon

            anchors.centerIn: parent
            source: "image://theme/wmCloseIcon" + backButton.state
        }

        MouseArea {
            id: backMouseArea

            anchors.fill: parent
            enabled: backButton.enabled
            onPressAndHold: backButton.pressAndHold()
            onClicked: Qt.quit()
        }

        states: State {
            name: "Pressed"
            when: backMouseArea.pressed
            PropertyChanges { target: backBackground; visible: true }
        }
    }

}
