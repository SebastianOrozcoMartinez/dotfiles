pragma Singleton
import QtQuick
import Quickshell.Io

Item {
    id: theme

    FileView {
        id: colorsFile
        path: "/home/sebas/.cache/wal/colors.json"
        watchChanges: true
        blockLoading: true
        onFileChanged: {
            colorsFile.reload();
            colorsUpdateTrigger = !colorsUpdateTrigger;
        }
    }

    property bool colorsUpdateTrigger: false

    readonly property var rawColors: {
        colorsUpdateTrigger; // Access property to establish QML dependency
        try {
            var rawText = colorsFile.text();
            if (rawText && rawText.trim() !== "") {
                return JSON.parse(rawText);
            }
        } catch (e) {
            // Ignore temporary parsing errors during pywal writes
        }
        return null;
    }

    // Default fallbacks matching the user's colors.json values
    readonly property color background: rawColors?.special?.background ?? "#151014"
    readonly property color foreground: rawColors?.special?.foreground ?? "#c4c3c4"
    readonly property color cursor: rawColors?.special?.cursor ?? "#c4c3c4"

    readonly property color color0: rawColors?.colors?.color0 ?? "#151014"
    readonly property color color1: rawColors?.colors?.color1 ?? "#B38478"
    readonly property color color2: rawColors?.colors?.color2 ?? "#DE9574"
    readonly property color color3: rawColors?.colors?.color3 ?? "#FDC578"
    readonly property color color4: rawColors?.colors?.color4 ?? "#997F81"
    readonly property color color5: rawColors?.colors?.color5 ?? "#B79489"
    readonly property color color6: rawColors?.colors?.color6 ?? "#DFAB90"
    readonly property color color7: rawColors?.colors?.color7 ?? "#c4c3c4"
    readonly property color color8: rawColors?.colors?.color8 ?? "#6e5a6e"
    readonly property color color9: rawColors?.colors?.color9 ?? "#B38478"
    readonly property color color10: rawColors?.colors?.color10 ?? "#DE9574"
    readonly property color color11: rawColors?.colors?.color11 ?? "#FDC578"
    readonly property color color12: rawColors?.colors?.color12 ?? "#997F81"
    readonly property color color13: rawColors?.colors?.color13 ?? "#B79489"
    readonly property color color14: rawColors?.colors?.color14 ?? "#DFAB90"
    readonly property color color15: rawColors?.colors?.color15 ?? "#c4c3c4"

    // Theme abstractions
    readonly property color accent: color2
    readonly property color primary: color3
    readonly property color muted: color4

    // Typography
    readonly property string fontFamily: "Google Sans Flex"
    readonly property string iconFontFamily: "Maple Mono NF"
    readonly property real fontSize: 17
}
