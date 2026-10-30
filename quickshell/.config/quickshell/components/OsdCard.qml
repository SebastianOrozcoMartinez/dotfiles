import QtQuick
import "../theme"

Rectangle {
    id: root

    property string kind: ""
    property string title: ""
    property string subtitle: ""
    property string icon: ""
    property real value: -1
    property color tint: Theme.color2

    implicitWidth: 320
    implicitHeight: root.value >= 0 ? 78 : 62
    radius: 14

    color: Qt.rgba(Theme.background.r, Theme.background.g, Theme.background.b, 0.84)
    border.width: 1
    border.color: Qt.rgba(Theme.color8.r, Theme.color8.g, Theme.color8.b, 0.35)

    Behavior on implicitHeight { NumberAnimation { duration: 120; easing.type: Easing.OutQuad } }
    Behavior on color { ColorAnimation { duration: 400 } }
    Behavior on border.color { ColorAnimation { duration: 400 } }

    Row {
        id: header

        anchors {
            left: parent.left
            right: parent.right
            verticalCenter: parent.verticalCenter
            verticalCenterOffset: root.value >= 0 ? -6 : 0
            leftMargin: 16
            rightMargin: 16
        }

        spacing: 12

        Text {
            id: iconText
            anchors.verticalCenter: parent.verticalCenter
            text: root.icon
            color: root.tint
            font.pixelSize: 28
            font.family: Theme.iconFontFamily

            Behavior on color { ColorAnimation { duration: 300 } }
        }

        Column {
            width: Math.max(0, header.width - iconText.implicitWidth - header.spacing)
            anchors.verticalCenter: parent.verticalCenter
            spacing: 1

            Text {
                width: parent.width
                text: root.title
                color: Theme.foreground
                font.pixelSize: Theme.fontSize
                font.family: Theme.fontFamily
                font.bold: true
                elide: Text.ElideRight
            }

            Text {
                width: parent.width
                text: root.subtitle
                color: Theme.muted
                font.pixelSize: Theme.fontSize - 2
                font.family: Theme.fontFamily
                elide: Text.ElideRight
                visible: text !== ""
            }
        }
    }

    Rectangle {
        id: track

        visible: root.value >= 0

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            leftMargin: 16
            rightMargin: 16
            bottomMargin: 10
        }

        height: 4
        radius: 2
        color: Qt.rgba(Theme.color8.r, Theme.color8.g, Theme.color8.b, 0.25)

        Rectangle {
            width: parent.width * Math.max(0, Math.min(1, root.value))
            height: parent.height
            radius: parent.radius
            color: root.tint

            Behavior on width { NumberAnimation { duration: 120; easing.type: Easing.OutQuad } }
            Behavior on color { ColorAnimation { duration: 300 } }
        }
    }
}
