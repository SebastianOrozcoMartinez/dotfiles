import QtQuick
import "../theme"

Rectangle {
    id: root

    default property alias content: container.data

    color: Qt.rgba(Theme.background.r, Theme.background.g, Theme.background.b, 0.75)
    border.width: 1
    border.color: Qt.rgba(Theme.color8.r, Theme.color8.g, Theme.color8.b, 0.25)
    radius: 12

    Behavior on color { ColorAnimation { duration: 400 } }
    Behavior on border.color { ColorAnimation { duration: 400 } }

    implicitHeight: 40
    implicitWidth: container.implicitWidth + 24

    width: implicitWidth
    Behavior on width {
        NumberAnimation { duration: 250; easing.type: Easing.OutQuad }
    }

    Row {
        id: container

        anchors.centerIn: parent
        spacing: 12
    }
}
