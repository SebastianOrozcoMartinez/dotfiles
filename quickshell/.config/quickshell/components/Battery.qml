import QtQuick
import Quickshell
import Quickshell.Io
import "../theme"

MouseArea {
    id: root
    implicitWidth: contentRow.implicitWidth
    implicitHeight: 40
    hoverEnabled: true

    property var targetSector: null

    // File updates for basic percentage and status
    FileView {
        id: capacityFile
        path: "/sys/class/power_supply/BAT1/capacity"
        watchChanges: true
    }

    FileView {
        id: statusFile
        path: "/sys/class/power_supply/BAT1/status"
        watchChanges: true
    }

    // Sysfs doesn't emit inotify events, so poll periodically
    Timer {
        id: batteryPollTimer
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            capacityFile.reload();
            statusFile.reload();
        }
    }

    readonly property int percentage: {
        var p = parseInt(capacityFile.text().trim());
        return isNaN(p) ? 0 : p;
    }

    readonly property string status: statusFile.text().trim()

    readonly property string icon: {
        if (status === "Charging") return "󱐌";
        if (percentage >= 95) return "";
        if (percentage >= 75) return "";
        if (percentage >= 50) return "";
        if (percentage >= 25) return "";
        if (percentage >= 10) return "";
        return "";
    }

    // Diagnostics and detailed info query
    property string timeText: "Time: N/A"
    property string powerMode: "balanced"

    Process {
        id: updateBatteryInfoProc
        command: ["bash", "-c", "TIME=$(upower -i /org/freedesktop/UPower/devices/battery_BAT1 | grep -E \"time to (empty|full)\" | cut -d: -f2- | xargs); if [ -z \"$TIME\" ]; then echo \"Time: N/A\"; else echo \"Time: $TIME\"; fi; echo \"Mode: $(powerprofilesctl get)\""]
        running: false

        stdout: SplitParser {
            onRead: data => {
                var line = data.trim();
                if (line.startsWith("Time: ")) {
                    root.timeText = line;
                } else if (line.startsWith("Mode: ")) {
                    root.powerMode = line.substring(6);
                }
            }
        }
    }

    // Refresh battery details while popup is visible
    Timer {
        id: popupUpdateTimer
        interval: 10000 // 10 seconds
        running: batteryPopup.visible
        repeat: true
        triggeredOnStart: false
        onTriggered: {
            if (!updateBatteryInfoProc.running) {
                updateBatteryInfoProc.running = true;
            }
        }
    }

    onClicked: {
        if (batteryPopup.visible) {
            batteryPopup.close();
        } else {
            batteryPopup.open();
            updateBatteryInfoProc.running = true;
        }
    }

    Row {
        id: contentRow
        spacing: 6
        anchors.verticalCenter: parent.verticalCenter

        Text {
            text: root.icon
            color: root.percentage < 20 && root.status !== "Charging" ? Theme.color9 : Theme.accent
            font.pixelSize: Theme.fontSize
            font.family: Theme.iconFontFamily

            Behavior on color { ColorAnimation { duration: 400 } }
        }

        Text {
            text: root.percentage + "%"
            color: Theme.foreground
            font.pixelSize: Theme.fontSize
            font.bold: true
            font.family: Theme.fontFamily

            Behavior on color { ColorAnimation { duration: 400 } }
        }
    }

    // Popup window for Battery Details - renders as a separate Wayland surface
    PopupWindow {
        id: batteryPopup
        visible: false

        anchor {
            item: root.targetSector
            edges: Edges.Bottom | Edges.Right
            gravity: Edges.Bottom | Edges.Left
            margins {
                top: 8
            }
        }

        implicitWidth: root.targetSector ? root.targetSector.width : 220
        implicitHeight: popupContent.implicitHeight + 24 + 6
        color: "transparent"

        function open() {
            batteryPopup.visible = true;
            openAnimation.start();
        }

        function close() {
            closeAnimation.start();
        }

        SequentialAnimation {
            id: openAnimation
            PropertyAction { target: popupCard; property: "opacity"; value: 0 }
            PropertyAction { target: popupCard; property: "scale"; value: 0.9 }
            ParallelAnimation {
                NumberAnimation { target: popupCard; property: "opacity"; to: 1; duration: 180; easing.type: Easing.OutQuad }
                NumberAnimation { target: popupCard; property: "scale"; to: 1; duration: 180; easing.type: Easing.OutBack }
            }
        }

        SequentialAnimation {
            id: closeAnimation
            ParallelAnimation {
                NumberAnimation { target: popupCard; property: "opacity"; to: 0; duration: 150; easing.type: Easing.OutQuad }
                NumberAnimation { target: popupCard; property: "scale"; to: 0.9; duration: 150; easing.type: Easing.OutQuad }
            }
            PropertyAction { target: batteryPopup; property: "visible"; value: false }
        }

        Rectangle {
            id: popupCard
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: popupContent.implicitHeight + 24
            radius: 10
            color: Qt.rgba(Theme.background.r, Theme.background.g, Theme.background.b, 0.75)
            border.width: 1
            border.color: Qt.rgba(Theme.color8.r, Theme.color8.g, Theme.color8.b, 0.25)

            Behavior on color { ColorAnimation { duration: 400 } }
            Behavior on border.color { ColorAnimation { duration: 400 } }

            Column {
                id: popupContent
                anchors.fill: parent
                anchors.margins: 12
                spacing: 12

                // Ring + Info Row
                Row {
                    width: parent.width
                    spacing: 12

                    // Battery Ring
                    Canvas {
                        id: batteryRing
                        width: 90
                        height: 90

                        property real arcAngle: root.percentage / 100.0

                        readonly property color ringColor: {
                            if (root.status === "Charging") return Theme.color4;
                            if (root.percentage <= 15) return Theme.color3;
                            if (root.percentage <= 30) return Theme.color3;
                            if (root.percentage <= 60) return Theme.color5;
                            return Theme.color4;
                        }

                        onArcAngleChanged: requestPaint()
                        onRingColorChanged: requestPaint()
                        Connections {
                            target: Theme
                            function onForegroundChanged() { batteryRing.requestPaint() }
                            function onColor3Changed() { batteryRing.requestPaint() }
                            function onColor4Changed() { batteryRing.requestPaint() }
                            function onColor5Changed() { batteryRing.requestPaint() }
                        }
                        Component.onCompleted: requestPaint()
                        onPaint: {
                            var ctx = getContext("2d");
                            ctx.reset();

                            var cx = width / 2;
                            var cy = height / 2;
                            var radius = 38;
                            var lineWidth = 6;

                            // Background ring
                            ctx.beginPath();
                            ctx.arc(cx, cy, radius, 0, Math.PI * 2);
                            ctx.strokeStyle = Qt.rgba(Theme.color8.r, Theme.color8.g, Theme.color8.b, 0.2);
                            ctx.lineWidth = lineWidth;
                            ctx.lineCap = "round";
                            ctx.stroke();

                            // Progress arc
                            var startAngle = -Math.PI / 2;
                            var endAngle = startAngle + (Math.PI * 2 * arcAngle);
                            ctx.beginPath();
                            ctx.arc(cx, cy, radius, startAngle, endAngle);
                            ctx.strokeStyle = ringColor;
                            ctx.lineWidth = lineWidth;
                            ctx.lineCap = "round";
                            ctx.stroke();

                            // Percentage text
                            ctx.fillStyle = Theme.foreground;
                            ctx.font = "bold " + (Theme.fontSize + 6) + "px '" + Theme.fontFamily + "'";
                            ctx.textAlign = "center";
                            ctx.textBaseline = "middle";
                            ctx.fillText(root.percentage + "%", cx, cy);
                        }
                    }

                    // Battery Info
                    Column {
                        width: parent.width - 102
                        spacing: 4
                        anchors.verticalCenter: parent.verticalCenter

                        Text {
                            text: "Battery Details"
                            font.pixelSize: Theme.fontSize - 1
                            font.family: Theme.fontFamily
                            font.bold: true
                            color: Theme.accent
                            elide: Text.ElideRight
                            width: parent.width
                            Behavior on color { ColorAnimation { duration: 400 } }
                        }

                        Text {
                            text: root.status !== "" ? root.status : "Unknown"
                            font.pixelSize: Theme.fontSize - 2
                            font.family: Theme.fontFamily
                            color: Theme.muted
                            elide: Text.ElideRight
                            width: parent.width
                            Behavior on color { ColorAnimation { duration: 400 } }
                        }

                        Text {
                            text: root.timeText
                            font.pixelSize: Theme.fontSize - 2
                            font.family: Theme.fontFamily
                            color: Theme.foreground
                            elide: Text.ElideRight
                            width: parent.width
                            Behavior on color { ColorAnimation { duration: 400 } }
                        }
                    }
                }

                // Separator
                Rectangle {
                    width: parent.width
                    height: 1
                    color: Qt.rgba(Theme.color8.r, Theme.color8.g, Theme.color8.b, 0.2)
                    Behavior on color { ColorAnimation { duration: 400 } }
                }

                // Power Mode Row
                Row {
                    width: parent.width
                    spacing: 6

                    Text {
                        text: "Mode:"
                        font.pixelSize: Theme.fontSize - 2
                        font.family: Theme.fontFamily
                        font.bold: true
                        color: Theme.muted
                        Behavior on color { ColorAnimation { duration: 400 } }
                    }

                    Text {
                        text: root.powerMode
                        font.pixelSize: Theme.fontSize - 2
                        font.family: Theme.fontFamily
                        color: Theme.foreground
                        Behavior on color { ColorAnimation { duration: 400 } }
                    }
                }
            }
        }
    }
}
