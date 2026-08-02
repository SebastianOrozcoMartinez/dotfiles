import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "../theme"

Item {
    id: root
    implicitWidth: contentRow.implicitWidth
    implicitHeight: 40

    property string weatherText: "..."
    property string weatherIcon: "󰖙"

    function parseWeather(data) {
        var trimmed = data.trim();
        if (trimmed === "") return;
        var parts = trimmed.split(":");
        if (parts.length >= 2) {
            var condition = parts[0].toLowerCase();
            var temp = parts[1];

            if (condition.includes("sunny") || condition.includes("clear")) {
                root.weatherIcon = "󰖙"; // Sun
            } else if (condition.includes("cloudy") || condition.includes("overcast") || condition.includes("mist") || condition.includes("fog")) {
                root.weatherIcon = "󰖐"; // Cloud
            } else if (condition.includes("rain") || condition.includes("drizzle") || condition.includes("shower")) {
                root.weatherIcon = "󰖖"; // Rain
            } else if (condition.includes("thunder") || condition.includes("storm")) {
                root.weatherIcon = "󰖓"; // Thunderstorm
            } else if (condition.includes("snow") || condition.includes("sleet") || condition.includes("ice") || condition.includes("hail")) {
                root.weatherIcon = "󰼶"; // Snow
            } else {
                root.weatherIcon = "󰖐";
            }
            root.weatherText = temp.replace(/^\+/, "");
        } else {
            root.weatherText = trimmed;
            root.weatherIcon = "󰖙";
        }
    }

    Process {
        id: weatherProc
        command: ["curl", "-s", "wttr.in?format=%C:%t"]
        running: false

        stdout: SplitParser {
            onRead: data => {
                root.parseWeather(data);
            }
        }
    }

    Timer {
        id: weatherTimer
        interval: 900000 // 15 mins
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            if (!weatherProc.running) {
                weatherProc.running = true;
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            root.weatherText = "...";
            if (!weatherProc.running) {
                weatherProc.running = true;
            }
        }
    }

    RowLayout {
        id: contentRow
        spacing: 6
        anchors.verticalCenter: parent.verticalCenter

        Text {
            text: root.weatherIcon
            color: Theme.primary
            font.pixelSize: Theme.fontSize
            font.family: Theme.iconFontFamily
            Layout.alignment: Qt.AlignBaseline

            Behavior on color { ColorAnimation { duration: 400 } }
        }

        Text {
            text: root.weatherText
            color: Theme.foreground
            font.pixelSize: Theme.fontSize
            font.family: Theme.fontFamily
            Layout.alignment: Qt.AlignBaseline

            Behavior on color { ColorAnimation { duration: 400 } }
        }
    }
}
