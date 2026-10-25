import QtQuick
import QtQuick.Layouts
import "../theme"
import "../services"

MouseArea {
    id: root
    implicitWidth: contentRow.implicitWidth
    implicitHeight: 40
    hoverEnabled: true
    acceptedButtons: Qt.LeftButton | Qt.RightButton

    readonly property int count: Swaync.count
    readonly property bool dnd: Swaync.dnd

    readonly property string icon: {
        if (dnd) return "󰂛";        // DND on
        if (count > 0) return "󰂚";  // Notifications pending
        return "󰂜";                 // No notifications
    }

    readonly property color stateColor: {
        if (dnd) return Theme.color9;
        if (count > 0) return Theme.color11;
        return Theme.color4;
    }

    RowLayout {
        id: contentRow
        spacing: 6
        anchors.verticalCenter: parent.verticalCenter

        Text {
            text: root.icon
            color: root.stateColor
            font.pixelSize: Theme.fontSize - 2
            font.family: Theme.iconFontFamily
            Layout.alignment: Qt.AlignBaseline

            Behavior on color { ColorAnimation { duration: 400 } }
        }

        Text {
            text: root.count > 99 ? "99+" : root.count
            visible: root.count > 0
            color: root.stateColor
            font.pixelSize: Theme.fontSize
            font.bold: true
            font.family: Theme.fontFamily
            Layout.alignment: Qt.AlignBaseline

            Behavior on color { ColorAnimation { duration: 400 } }
        }
    }

    onClicked: (mouse) => {
        if (mouse.button === Qt.RightButton) {
            Swaync.toggleDnd();
        } else {
            Swaync.togglePanel();
        }
    }
}
