pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.Pipewire
import Quickshell.Services.UPower
import "../theme"

Item {
    id: root

    // State consumed by OsdPanel/OsdCard
    property bool active: false
    property string kind: ""
    property string title: ""
    property string subtitle: ""
    property string icon: ""
    property real value: -1
    property color tint: Theme.color2
    property int hideDelay: 1500

    // Suppress the initial state sync after startup
    property bool initialized: false

    // Baselines used to detect real changes
    property real _lastVolume: -1
    property bool _lastMuted: false
    property bool _lastSourceMuted: false
    property string _lastLayout: ""
    property int _batteryWarned: 100
    property int _pendingBrightness: 0

    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property PwNode source: Pipewire.defaultAudioSource

    // ── Public API ─────────────────────────────────────────────

    function show(opts) {
        if (!root.initialized && !opts.force)
            return;

        root.kind = opts.kind ?? "";
        root.title = opts.title ?? "";
        root.subtitle = opts.subtitle ?? "";
        root.icon = opts.icon ?? "";
        root.value = opts.value ?? -1;
        root.tint = opts.tint ?? Theme.color2;
        root.hideDelay = opts.hideDelay ?? 1500;
        root.active = true;

        hideTimer.interval = root.hideDelay;
        hideTimer.restart();
    }

    function hide() {
        root.active = false;
    }

    function showVolume(volume, muted) {
        var percent = Math.round(volume * 100);
        var icon = "";
        var color = Theme.color9;

        if (!muted && percent >= 66) {
            icon = "";
            color = Theme.color4;
        } else if (!muted && percent >= 33) {
            icon = "";
            color = Theme.color2;
        } else if (!muted && percent > 0) {
            icon = "";
            color = Theme.color11;
        }

        show({
            kind: "volume",
            title: muted ? "Muted" : "Volume",
            subtitle: percent + "%",
            icon: icon,
            value: percent / 100.0,
            tint: color
        });
    }

    function showBrightness(percent) {
        var icon = "󰃞";
        var color = Theme.color11;

        if (percent >= 70) {
            icon = "󰃠";
            color = Theme.color3;
        } else if (percent >= 35) {
            icon = "󰃟";
            color = Theme.color2;
        }

        show({
            kind: "brightness",
            title: "Brightness",
            subtitle: percent + "%",
            icon: icon,
            value: percent / 100.0,
            tint: color,
            force: true
        });
    }

    function showMicMuted(muted) {
        show({
            kind: "mic",
            title: muted ? "Microphone muted" : "Microphone",
            subtitle: muted ? "Off" : "On",
            icon: muted ? "󰍭" : "󰍬",
            value: -1,
            tint: muted ? Theme.color9 : Theme.color4
        });
    }

    function showLayout(name) {
        show({
            kind: "layout",
            title: "Keyboard layout",
            subtitle: name,
            icon: "󰌌",
            value: -1,
            tint: Theme.color5
        });
    }

    function showMonitor(connected, name) {
        show({
            kind: "display",
            title: connected ? "Display connected" : "Display disconnected",
            subtitle: name,
            icon: connected ? "󰍹" : "󰍺",
            value: -1,
            tint: connected ? Theme.color4 : Theme.color9,
            hideDelay: 3000
        });
    }

    function showBattery(percent, threshold) {
        show({
            kind: "battery",
            title: "Battery low",
            subtitle: Math.round(percent) + "% remaining",
            icon: threshold <= 10 ? "" : "",
            value: percent / 100.0,
            tint: threshold <= 10 ? Theme.color9 : Theme.color11,
            hideDelay: 4000
        });
    }

    // ── Change handling ────────────────────────────────────────

    function handleVolume() {
        var audio = root.sink?.audio ?? null;
        if (!audio)
            return;

        var volume = audio.volume;
        var muted = audio.muted;

        if (root._lastVolume < 0) {
            root._lastVolume = volume;
            root._lastMuted = muted;
            return;
        }

        if (Math.abs(volume - root._lastVolume) < 0.0001 && muted === root._lastMuted)
            return;

        root._lastVolume = volume;
        root._lastMuted = muted;

        if (root.initialized)
            root.showVolume(volume, muted);
    }

    function handleSource() {
        var audio = root.source?.audio ?? null;
        if (!audio)
            return;

        var muted = audio.muted;
        if (muted === root._lastSourceMuted)
            return;

        root._lastSourceMuted = muted;

        if (root.initialized)
            root.showMicMuted(muted);
    }

    function handleBattery() {
        var device = UPower.displayDevice;
        if (!device || !device.ready)
            return;

        var charging = device.state === UPowerDeviceState.Charging
            || device.state === UPowerDeviceState.FullyCharged
            || device.state === UPowerDeviceState.PendingCharge;

        if (charging) {
            root._batteryWarned = 100;
            return;
        }

        if (device.state !== UPowerDeviceState.Discharging
                && device.state !== UPowerDeviceState.PendingDischarge)
            return;

        // Quickshell's UPower percentage is a fraction in the range 0-1
        // (e.g. 0.99 == 99%), so convert it to a whole percentage before use.
        var percent = device.percentage * 100;

        var threshold = root.batteryThreshold(percent);
        if (threshold === 0 || threshold >= root._batteryWarned)
            return;

        root._batteryWarned = threshold;

        if (root.initialized)
            root.showBattery(percent, threshold);
    }

    function batteryThreshold(percent) {
        if (percent <= 5)
            return 5;
        if (percent <= 10)
            return 10;
        if (percent <= 20)
            return 20;
        return 0;
    }

    function handleLayout(event) {
        var layout = "";

        try {
            var parts = event.parse(2);
            layout = parts.length > 1 ? parts[1] : parts[0];
        } catch (e) {
            layout = event.data;
        }

        if (!layout || layout === root._lastLayout)
            return;

        root._lastLayout = layout;

        if (root.initialized)
            root.showLayout(layout);
    }

    function handleRawEvent(event) {
        if (event.name === "activelayout") {
            root.handleLayout(event);
        } else if (event.name === "monitoradded" || event.name === "monitoraddedv2") {
            var added = event.data.split(",")[0];
            if (root.initialized && added !== "")
                root.showMonitor(true, added);
        } else if (event.name === "monitorremoved" || event.name === "monitorremovedv2") {
            var removed = event.data.split(",")[0];
            if (root.initialized && removed !== "")
                root.showMonitor(false, removed);
        }
    }

    function seedBaselines() {
        root.handleVolume();
        root._lastSourceMuted = root.source?.audio?.muted ?? false;

        var device = UPower.displayDevice;
        if (device && device.ready) {
            if (device.state === UPowerDeviceState.Discharging
                    || device.state === UPowerDeviceState.PendingDischarge)
                root._batteryWarned = root.batteryThreshold(device.percentage * 100);
            else
                root._batteryWarned = 100;
        }
    }

    // ── Brightness ─────────────────────────────────────────────

    function adjustBrightness(delta) {
        root._pendingBrightness += delta;
        root.runBrightnessStep();
    }

    function runBrightnessStep() {
        if (brightnessProc.running || root._pendingBrightness === 0)
            return;

        var step = root._pendingBrightness > 0 ? 5 : -5;
        root._pendingBrightness -= step;
        var arg = step > 0 ? "5%+" : "5%-";

        brightnessProc.command = [
            "bash", "-c",
            "brightnessctl -e4 -n2 set " + arg + " >/dev/null 2>&1; brightnessctl -e4 -m 2>/dev/null"
        ];
        brightnessProc.running = true;
    }

    function parseBrightness(output) {
        var match = /([0-9]+)%/.exec(output);
        if (!match)
            return;

        root.showBrightness(parseInt(match[1], 10));
    }

    // ── Watchers ───────────────────────────────────────────────

    PwObjectTracker {
        objects: root.sink ? [root.sink] : []
    }

    PwObjectTracker {
        objects: root.source ? [root.source] : []
    }

    Connections {
        target: root.sink && root.sink.audio ? root.sink.audio : null

        function onVolumeChanged() { root.handleVolume(); }
        function onMutedChanged() { root.handleVolume(); }
    }

    Connections {
        target: root.source && root.source.audio ? root.source.audio : null

        function onMutedChanged() { root.handleSource(); }
    }

    Connections {
        target: Hyprland

        function onRawEvent(event) { root.handleRawEvent(event); }
    }

    Connections {
        target: UPower.displayDevice

        function onPercentageChanged() { root.handleBattery(); }
        function onStateChanged() { root.handleBattery(); }
        function onReadyChanged() { root.handleBattery(); }
    }

    onSinkChanged: {
        root._lastVolume = -1;
        root._lastMuted = false;
    }

    onSourceChanged: {
        root._lastSourceMuted = root.source?.audio?.muted ?? false;
    }

    Timer {
        id: hideTimer
        repeat: false
        onTriggered: root.active = false
    }

    Timer {
        id: initTimer
        interval: 1000
        repeat: false
        onTriggered: {
            root.seedBaselines();
            root.initialized = true;
        }
    }

    // UPower property notifications are usually enough; this is a cheap safety net.
    Timer {
        interval: 60000
        repeat: true
        running: true
        onTriggered: root.handleBattery()
    }

    Process {
        id: brightnessProc
        command: ["brightnessctl", "-m"]
        running: false

        stdout: StdioCollector {
            id: brightnessOut
            waitForEnd: true
            onStreamFinished: root.parseBrightness(brightnessOut.text)
        }

        onExited: {
            if (root._pendingBrightness !== 0)
                root.runBrightnessStep();
        }
    }

    Component.onCompleted: initTimer.start()

    IpcHandler {
        target: "osd"

        function brightnessUp(): void { root.adjustBrightness(5); }
        function brightnessDown(): void { root.adjustBrightness(-5); }
        function showBrightness(value: int): void { root.showBrightness(value); }
    }
}
