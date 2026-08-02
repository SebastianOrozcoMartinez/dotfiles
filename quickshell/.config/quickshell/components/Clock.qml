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
        textFormat: Text.RichText

        Behavior on color { ColorAnimation { duration: 400 } }

        function updateTime() {
            var date = new Date();
            var icon = clockArea.containsMouse ? "󰃭" : "󱑎";
            var label = clockArea.containsMouse
                ? date.toLocaleDateString(Qt.locale(), "ddd, MMM d")
                : date.toLocaleTimeString(Qt.locale(), "hh:mm AP");
            timeText.text = "<span style=\"font-family:'" + Theme.iconFontFamily + "', 'Maple Mono NF';\">" + icon + "</span>&nbsp;&nbsp;" + label;
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
