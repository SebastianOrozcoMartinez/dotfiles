pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Io

Item {
    id: root

    property int count: 0
    property bool dnd: false

    function togglePanel() {
        if (!panelProc.running)
            panelProc.running = true;
    }

    function toggleDnd() {
        if (!dndProc.running)
            dndProc.running = true;
    }

    function applyState(line) {
        var trimmed = line.trim();
        if (trimmed === "")
            return;

        try {
            var state = JSON.parse(trimmed);
            if (typeof state.count === "number")
                root.count = state.count;
            if (typeof state.dnd === "boolean")
                root.dnd = state.dnd;
        } catch (e) {
            // Ignore temporary parsing errors
        }
    }

    // Event stream: one JSON object per line with count, dnd, visible and inhibited
    Process {
        id: subscribeProc
        command: ["swaync-client", "-s"]
        running: true

        stdout: SplitParser {
            onRead: data => root.applyState(data)
        }

        onExited: restartTimer.start()
    }

    // Bring the subscription back whenever swaync restarts
    Timer {
        id: restartTimer
        interval: 1000
        repeat: false
        onTriggered: subscribeProc.running = true
    }

    Process {
        id: panelProc
        command: ["swaync-client", "-t"]
        running: false
    }

    Process {
        id: dndProc
        command: ["swaync-client", "-d"]
        running: false
    }
}
