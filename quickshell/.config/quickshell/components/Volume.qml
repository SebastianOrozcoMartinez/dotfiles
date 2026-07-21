import QtQuick
import Quickshell
import Quickshell.Services.Pipewire
import "../theme"

MouseArea {
    id: root
    implicitWidth: contentRow.implicitWidth
    implicitHeight: 40
    hoverEnabled: true

    readonly property PwNode sink: Pipewire.defaultAudioSink

    PwObjectTracker {
        objects: root.sink ? [root.sink] : []
    }

    readonly property real rawVolume: sink?.audio?.volume ?? 0
    readonly property bool muted: sink?.audio?.muted ?? false
    readonly property int percentage: Math.round(rawVolume * 100)

    readonly property string icon: {
        if (muted) return "";
        if (percentage >= 66) return "";
        if (percentage >= 33) return "";
        if (percentage > 0) return "";
        return "";
    }

    Row {
        id: contentRow
        spacing: 6
        anchors.verticalCenter: parent.verticalCenter

        Text {
            text: root.icon
            color: root.muted ? Theme.color9 : Theme.accent
            font.pixelSize: Theme.fontSize
            font.family: Theme.iconFontFamily

            Behavior on color { ColorAnimation { duration: 400 } }
        }

        Text {
            text: root.muted ? "Mute" : root.percentage + "%"
            color: Theme.foreground
            font.pixelSize: Theme.fontSize
            font.family: Theme.fontFamily

            Behavior on color { ColorAnimation { duration: 400 } }
        }
    }

    onClicked: {
        if (sink?.ready && sink?.audio) {
            sink.audio.muted = !sink.audio.muted;
        }
    }

    onWheel: (wheel) => {
        if (sink?.ready && sink?.audio) {
            var current = sink.audio.volume;
            var step = 0.02;
            if (wheel.angleDelta.y > 0) {
                sink.audio.volume = Math.min(1.0, current + step);
            } else {
                sink.audio.volume = Math.max(0.0, current - step);
            }
        }
    }
}
