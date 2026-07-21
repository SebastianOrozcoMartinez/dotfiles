import QtQuick
import Qt5Compat.GraphicalEffects
import Quickshell
import Quickshell.Io
import "../theme"

MouseArea {
    id: root
    implicitWidth: Math.min(250, contentRow.implicitWidth)
    implicitHeight: 40
    hoverEnabled: true

    property string status: "Stopped"
    property string songTitle: ""
    property string songArtist: ""
    property string artUrl: ""
    
    // Sector reference for width alignment
    property var targetSector: null
    
    // Playback progress variables
    property real trackPosition: 0
    property real trackDuration: 0
    
    // Wave animation counters
    property real timeCounter: 0

    Timer {
        id: waveTimer
        interval: 50
        running: spotifyPopup.visible && root.status === "Playing"
        repeat: true
        onTriggered: root.timeCounter += 0.2
    }

    // Format seconds into MM:SS
    function formatTime(seconds) {
        if (isNaN(seconds) || seconds < 0) return "0:00";
        var mins = Math.floor(seconds / 60);
        var secs = Math.floor(seconds % 60);
        return mins + ":" + (secs < 10 ? "0" : "") + secs;
    }

    // Delimited parsing: Playerctl sends status, title, artist, artUrl, length separated by pipe characters
    function parseOutput(data) {
        var lines = data.trim().split("|");
        if (lines.length >= 5) {
            root.status = lines[0].trim();
            root.songTitle = lines[1].trim();
            root.songArtist = lines[2].trim();
            root.artUrl = lines[3].trim();
            
            // Length is returned in microseconds, convert to seconds
            var lenMicro = parseInt(lines[4].trim());
            root.trackDuration = isNaN(lenMicro) ? 0 : lenMicro / 1000000;
        } else if (lines.length === 1 && lines[0].trim() === "") {
            root.status = "Stopped";
            root.songTitle = "";
            root.songArtist = "";
            root.artUrl = "";
            root.trackDuration = 0;
        }
    }

    Process {
        id: playerProc
        command: ["playerctl", "--player=spotify", "metadata", "--follow", "--format", "{{ status }}|{{ title }}|{{ artist }}|{{ mpris:artUrl }}|{{ mpris:length }}"]
        running: false

        onRunningChanged: {
            if (!running) {
                root.status = "Stopped";
                root.songTitle = "";
                root.songArtist = "";
                root.artUrl = "";
                root.trackDuration = 0;
            }
        }

        stdout: SplitParser {
            onRead: data => {
                root.parseOutput(data);
            }
        }
    }

    // Process to query current playback position
    Process {
        id: positionProc
        command: ["playerctl", "--player=spotify", "position"]
        running: false
        stdout: SplitParser {
            onRead: data => {
                var pos = parseFloat(data.trim());
                if (!isNaN(pos)) {
                    root.trackPosition = pos;
                }
            }
        }
    }

    // Refresh battery/track details while popup is visible and playing
    Timer {
        id: positionTimer
        interval: 1000 // 1 second
        running: spotifyPopup.visible && root.status === "Playing"
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            if (!positionProc.running) {
                positionProc.running = true;
            }
        }
    }

    // Media Control Processes
    Process {
        id: prevProc
        command: ["playerctl", "--player=spotify", "previous"]
        running: false
    }

    Process {
        id: playPauseProc
        command: ["playerctl", "--player=spotify", "play-pause"]
        running: false
    }

    Process {
        id: nextProc
        command: ["playerctl", "--player=spotify", "next"]
        running: false
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            if (!playerProc.running) {
                playerProc.running = true;
            }
        }
    }

    onClicked: {
        if (spotifyPopup.visible) {
            spotifyPopup.close();
        } else {
            // Fetch initial position immediately upon opening
            if (!positionProc.running) {
                positionProc.running = true;
            }
            spotifyPopup.open();
        }
    }

    Row {
        id: contentRow
        spacing: 8
        anchors.verticalCenter: parent.verticalCenter

        Text {
            text: root.status === "Playing" ? "󰓇" : "󰓇"
            color: root.status === "Playing" ? Theme.accent : Theme.muted
            font.pixelSize: Theme.fontSize
            font.family: Theme.iconFontFamily

            Behavior on color { ColorAnimation { duration: 400 } }
        }

        Text {
            id: infoText
            text: root.songTitle !== "" ? root.songTitle : "No Media"
            color: root.status === "Playing" ? Theme.foreground : Theme.muted
            font.pixelSize: Theme.fontSize
            font.family: Theme.fontFamily
            elide: Text.ElideRight
            width: Math.min(180, implicitWidth)

            Behavior on color { ColorAnimation { duration: 400 } }
        }
    }

    PopupWindow {
        id: spotifyPopup
        visible: false

        anchor {
            item: root.targetSector // Anchor relative to the target sector group
            edges: Edges.Bottom | Edges.Left // Align with bottom-left corner of the sector
            gravity: Edges.Bottom | Edges.Right // Expand downwards and rightwards
            margins {
                top: 8
            }
        }

        // Match the width of the entire target sector dynamically
        implicitWidth: root.targetSector ? root.targetSector.width : 220
        implicitHeight: contentColumn.implicitHeight + 24
        color: "transparent"

        function open() {
            spotifyPopup.visible = true;
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
            PropertyAction { target: spotifyPopup; property: "visible"; value: false }
        }

        Rectangle {
            id: popupCard
            anchors.fill: parent
            radius: 10
            color: Qt.rgba(Theme.background.r, Theme.background.g, Theme.background.b, 0.75)
            border.width: 1
            border.color: Qt.rgba(Theme.color8.r, Theme.color8.g, Theme.color8.b, 0.25)

            Behavior on color { ColorAnimation { duration: 400 } }
            Behavior on border.color { ColorAnimation { duration: 400 } }

            Column {
                id: contentColumn
                anchors.fill: parent
                anchors.margins: 12
                spacing: 12

                // Track Info Section (Horizontal Row)
                Row {
                    width: parent.width
                    spacing: 12

                    // Cover Art Image (Left)
                    Item {
                        width: 80
                        height: 80

                        // Dark fallback placeholder
                        Rectangle {
                            anchors.fill: parent
                            radius: 8
                            color: Qt.rgba(Theme.color8.r, Theme.color8.g, Theme.color8.b, 0.1)
                            visible: root.artUrl === ""

                            Text {
                                text: "󰓇"
                                anchors.centerIn: parent
                                font.pixelSize: 32
                                font.family: Theme.iconFontFamily
                                color: Theme.muted
                            }
                        }

                        // Album Cover Image
                        Image {
                            id: coverImage
                            anchors.fill: parent
                            source: root.artUrl
                            fillMode: Image.PreserveAspectCrop
                            visible: false // Masked
                            smooth: true
                            antialiasing: true
                        }

                        Rectangle {
                            id: maskRect
                            anchors.fill: parent
                            radius: 8
                            visible: false
                        }

                        OpacityMask {
                            anchors.fill: parent
                            source: coverImage
                            maskSource: maskRect
                            visible: root.artUrl !== ""
                        }
                    }

                    // Song metadata (Right)
                    Column {
                        width: parent.width - 92 // Subtract cover art width (80) + spacing (12)
                        spacing: 4
                        anchors.verticalCenter: parent.verticalCenter

                        // Song Title
                        Text {
                            text: root.songTitle !== "" ? root.songTitle : "No Song Playing"
                            font.pixelSize: Theme.fontSize - 1
                            font.family: Theme.fontFamily
                            font.bold: true
                            color: Theme.foreground
                            elide: Text.ElideRight
                            width: parent.width
                            Behavior on color { ColorAnimation { duration: 400 } }
                        }

                        // Artist Name
                        Text {
                            text: root.songArtist !== "" ? root.songArtist : "Unknown Artist"
                            font.pixelSize: Theme.fontSize - 2
                            font.family: Theme.fontFamily
                            color: Theme.muted
                            elide: Text.ElideRight
                            width: parent.width
                            Behavior on color { ColorAnimation { duration: 400 } }
                        }
                    }
                }

                // Progress Playing Bar Section
                Column {
                    width: parent.width
                    spacing: 6

                    // Waveform Visualizer (Progress Bar replacement)
                    Row {
                        id: waveRow
                        width: parent.width
                        height: 24
                        spacing: (parent.width - (25 * 4)) / 24 // Evenly space 25 bars (each 4px wide)
                        anchors.horizontalCenter: parent.horizontalCenter

                        Repeater {
                            model: 25

                            delegate: Rectangle {
                                width: 4
                                height: {
                                    if (root.status !== "Playing") return 8;
                                    // Ripple height using sine wave
                                    var wave = Math.sin(root.timeCounter + index * 0.8) * 8;
                                    return 8 + Math.abs(wave);
                                }
                                radius: 2
                                anchors.verticalCenter: parent.verticalCenter // Double-sided symmetrical Cava bounce

                                readonly property bool isCompleted: {
                                    if (root.trackDuration <= 0) return false;
                                    var progressFraction = root.trackPosition / root.trackDuration;
                                    var barFraction = index / 24.0;
                                    return barFraction <= progressFraction;
                                }

                                color: isCompleted ? Theme.accent : Qt.rgba(Theme.color8.r, Theme.color8.g, Theme.color8.b, 0.2)

                                Behavior on color { ColorAnimation { duration: 150 } }
                                Behavior on height {
                                    NumberAnimation { duration: 80; easing.type: Easing.OutQuad }
                                }
                            }
                        }
                    }

                    // Time labels
                    Item {
                        width: parent.width
                        height: positionLabel.implicitHeight

                        Text {
                            id: positionLabel
                            anchors.left: parent.left
                            text: root.formatTime(root.trackPosition)
                            font.pixelSize: Theme.fontSize - 3
                            font.family: Theme.fontFamily
                            color: Theme.muted
                        }

                        Text {
                            anchors.right: parent.right
                            text: root.formatTime(root.trackDuration)
                            font.pixelSize: Theme.fontSize - 3
                            font.family: Theme.fontFamily
                            color: Theme.muted
                        }
                    }
                }

                Rectangle {
                    width: parent.width
                    height: 1
                    color: Qt.rgba(Theme.color8.r, Theme.color8.g, Theme.color8.b, 0.2)
                    Behavior on color { ColorAnimation { duration: 400 } }
                }

                // Media Controls Row
                Row {
                    spacing: 36
                    anchors.horizontalCenter: parent.horizontalCenter

                    // Previous Button
                    MouseArea {
                        width: 24
                        height: 24
                        hoverEnabled: true
                        id: prevBtn
                        onClicked: prevProc.running = true
                        
                        scale: containsPress ? 0.85 : (containsMouse ? 1.15 : 1.0)
                        Behavior on scale { NumberAnimation { duration: 100; easing.type: Easing.OutQuad } }

                        Text {
                            text: "󰒮"
                            anchors.centerIn: parent
                            font.pixelSize: 18
                            font.family: Theme.iconFontFamily
                            color: prevBtn.containsMouse ? Theme.accent : Theme.foreground
                            Behavior on color { ColorAnimation { duration: 150 } }
                        }
                    }

                    // Play/Pause Button
                    MouseArea {
                        width: 28
                        height: 28
                        hoverEnabled: true
                        id: playBtn
                        onClicked: playPauseProc.running = true
                        
                        scale: containsPress ? 0.85 : (containsMouse ? 1.15 : 1.0)
                        Behavior on scale { NumberAnimation { duration: 100; easing.type: Easing.OutQuad } }

                        Text {
                            text: root.status === "Playing" ? "󰏤" : "󰐊"
                            anchors.centerIn: parent
                            font.pixelSize: 22
                            font.family: Theme.iconFontFamily
                            color: playBtn.containsMouse ? Theme.foreground : Theme.accent
                            Behavior on color { ColorAnimation { duration: 150 } }
                        }
                    }

                    // Next Button
                    MouseArea {
                        width: 24
                        height: 24
                        hoverEnabled: true
                        id: nextBtn
                        onClicked: nextProc.running = true
                        
                        scale: containsPress ? 0.85 : (containsMouse ? 1.15 : 1.0)
                        Behavior on scale { NumberAnimation { duration: 100; easing.type: Easing.OutQuad } }

                        Text {
                            text: "󰒭"
                            anchors.centerIn: parent
                            font.pixelSize: 18
                            font.family: Theme.iconFontFamily
                            color: nextBtn.containsMouse ? Theme.accent : Theme.foreground
                            Behavior on color { ColorAnimation { duration: 150 } }
                        }
                    }
                }
            }
        }
    }
}
