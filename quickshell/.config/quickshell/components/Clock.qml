import QtQuick
import "../theme"

MouseArea {
    id: clockArea
    implicitWidth: timeText.implicitWidth
    implicitHeight: 40
    hoverEnabled: true

    Text {
        id: timeText
        anchors.centerIn: parent
        color: Theme.primary
        font.pixelSize: Theme.fontSize
        font.bold: true
        font.family: Theme.fontFamily

        Behavior on color { ColorAnimation { duration: 400 } }

        function updateTime() {
            var date = new Date();
            if (clockArea.containsMouse) {
                timeText.text = "󰃭  " + date.toLocaleDateString(Qt.locale(), "ddd, MMM d");
            } else {
                timeText.text = "󱑎  " + date.toLocaleTimeString(Qt.locale(), "hh:mm AP");

            }
        }

        Timer {
            interval: 1000
            running: true
            repeat: true
            triggeredOnStart: true
            onTriggered: timeText.updateTime()
        }
    }
}
