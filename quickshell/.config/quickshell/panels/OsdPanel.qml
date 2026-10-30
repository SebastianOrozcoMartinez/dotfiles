import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import "../components"
import "../services"
import "../theme"

PanelWindow {
    id: osdWindow

    property bool closing: false

    readonly property var monitor: Hyprland.monitorFor(screen)
    readonly property bool focused: {
        var current = Hyprland.focusedMonitor;
        return monitor !== null && current !== null && monitor.name === current.name;
    }
    readonly property bool active: Osd.active && focused

    visible: active || closing

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    color: "transparent"
    exclusionMode: ExclusionMode.Ignore
    focusable: false

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "quickshell-osd"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None

    // Keep the full-screen surface from swallowing input outside the card.
    mask: Region {
        item: card
        radius: 14
    }

    onActiveChanged: {
        if (active) {
            closing = false;
        } else {
            closing = true;
            closeTimer.restart();
        }
    }

    Timer {
        id: closeTimer
        interval: 160
        repeat: false
        onTriggered: osdWindow.closing = false
    }

    OsdCard {
        id: card

        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            bottomMargin: 64
        }

        transformOrigin: Item.Bottom

        opacity: osdWindow.active ? 1 : 0
        scale: osdWindow.active ? 1 : 0.94

        transform: Translate {
            y: osdWindow.active ? 0 : 24

            Behavior on y {
                NumberAnimation {
                    duration: osdWindow.active ? 200 : 140
                    easing.type: Easing.OutCubic
                }
            }
        }

        kind: Osd.kind
        title: Osd.title
        subtitle: Osd.subtitle
        icon: Osd.icon
        value: Osd.value
        tint: Osd.tint

        Behavior on opacity {
            NumberAnimation {
                duration: osdWindow.active ? 160 : 140
                easing.type: Easing.OutQuad
            }
        }

        Behavior on scale {
            NumberAnimation {
                duration: osdWindow.active ? 200 : 140
                easing.type: Easing.OutBack
            }
        }
    }
}
