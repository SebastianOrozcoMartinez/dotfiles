import QtQuick
import Quickshell.Hyprland
import "../theme"

Row {
    id: root
    spacing: 10
    anchors.verticalCenter: parent.verticalCenter

    Repeater {
        model: Hyprland.workspaces

        delegate: Item {
            id: wsContainer
            height: 24

            readonly property bool isAssigned: modelData.id >= 1 && modelData.id <= 5

            // Filter workspaces: only show workspaces assigned to the same monitor as this TopBar window
            readonly property bool isCorrectMonitor: {
                var barMonitor = Hyprland.monitorFor(topbarWindow.screen);
                if (!barMonitor) return true; // Startup fallback
                return modelData.monitor && modelData.monitor.name === barMonitor.name;
            }

            visible: isCorrectMonitor
            width: isCorrectMonitor ? (modelData.focused ? 36 : (isAssigned ? 24 : 10)) : 0

            Behavior on width {
                NumberAnimation { duration: 10; easing.type: Easing.OutBack }
            }

            Rectangle {
                id: pill
                anchors.centerIn: parent

                // Animate width, height, and radius uniformly to match the container's layout
                width: modelData.focused ? 36 : (wsContainer.isAssigned ? 24 : 10)
                height: modelData.focused ? 24 : (wsContainer.isAssigned ? 24 : 10)
                radius: height / 2

                color: modelData.focused ? Theme.accent :
                       (wsContainer.isAssigned ? (wsArea.containsMouse ? Qt.rgba(Theme.color8.r, Theme.color8.g, Theme.color8.b, 0.12) : "transparent") :
                       (wsArea.containsMouse ? Theme.foreground : Theme.color8))

                Behavior on width {
                    NumberAnimation { duration: 250; easing.type: Easing.OutBack }
                }
                Behavior on height {
                    NumberAnimation { duration: 250; easing.type: Easing.OutBack }
                }
                Behavior on radius {
                    NumberAnimation { duration: 250; easing.type: Easing.OutBack }
                }
                Behavior on color {
                    ColorAnimation { duration: 200 }
                }

                Text {
                    id: wsText
                    anchors.centerIn: parent
                    font.pixelSize: Theme.fontSize
                    font.family: Theme.iconFontFamily
                    color: modelData.focused ? Theme.background : (wsArea.containsMouse ? Theme.foreground : Theme.muted)
                    visible: wsContainer.isAssigned

                    text: {
                        var id = modelData.id;
                        if (id === 1) return "󰣇";
                        if (id === 2) return "";
                        if (id === 3) return "";
                        if (id === 4) return "";
                        if (id === 5) return "󰓇";
                        return "";
                    }

                    Behavior on color { ColorAnimation { duration: 200 } }
                }
            }

            MouseArea {
                id: wsArea
                anchors.fill: parent
                hoverEnabled: true
                onClicked: modelData.activate()
            }
        }
    }
}
