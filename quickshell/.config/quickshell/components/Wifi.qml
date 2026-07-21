import QtQuick
import Quickshell
import Quickshell.Io
import "../theme"

Item {
    id: root
    implicitWidth: contentRow.implicitWidth
    implicitHeight: 40

    property string ssid: "Disconnected"
    property int signal: 0
    property string icon: "󰤮"

    function parseOutput(data) {
        var lines = data.trim().split("\n");
        if (lines.length > 0 && lines[0] !== "") {
            var parts = lines[0].split(":");
            if (parts.length >= 2) {
                root.ssid = parts[0];
                var sig = parseInt(parts[1]);
                root.signal = isNaN(sig) ? 0 : sig;

                if (root.signal >= 75) root.icon = "󰤨";
                else if (root.signal >= 50) root.icon = "󰤥";
                else if (root.signal >= 25) root.icon = "󰤢";
                else root.icon = "󰤟";
                return;
            }
        }
        root.ssid = "Disconnected";
        root.signal = 0;
        root.icon = "󰤮";
    }

    Process {
        id: wifiProc
        command: ["sh", "-c", "nmcli -t -f active,ssid,signal dev wifi | grep '^yes' | cut -d: -f2,3"]
        running: false

        stdout: SplitParser {
            onRead: data => {
                root.parseOutput(data);
            }
        }
    }

    Timer {
        interval: 8000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            if (!wifiProc.running) {
                wifiProc.running = true;
            }
        }
    }

    Row {
        id: contentRow
        spacing: 6
        anchors.verticalCenter: parent.verticalCenter

        Text {
            text: root.icon
            color: root.ssid === "Disconnected" ? Theme.color9 : Theme.accent
            font.pixelSize: Theme.fontSize
            font.family: Theme.iconFontFamily

            Behavior on color { ColorAnimation { duration: 400 } }
        }

        Text {
            text: root.ssid
            color: Theme.foreground
            font.pixelSize: Theme.fontSize
            font.family: Theme.fontFamily

            Behavior on color { ColorAnimation { duration: 400 } }
        }
    }
}
