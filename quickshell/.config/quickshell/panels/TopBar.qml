import QtQuick
import Quickshell
import Quickshell.Wayland
import "../components"
import "../theme"

PanelWindow {
    id: topbarWindow

    anchors {
        top: true
        left: true
        right: true
    }

    margins {
        top: 14
    }

    implicitHeight: 52
    exclusionMode: ExclusionMode.Auto
    color: "transparent"

    Item {
        anchors.fill: parent

        // Left section (Clock, Media, Weather)
        FloatingGroup {
            id: leftGroup
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.verticalCenter: parent.verticalCenter

            Clock {}

            // Visual separator
            Rectangle {
                width: 1
                height: 14
                color: Qt.rgba(Theme.color8.r, Theme.color8.g, Theme.color8.b, 0.4)
                anchors.verticalCenter: parent.verticalCenter
            }

            Spotify {
                targetSector: leftGroup
            }

            // Visual separator
            Rectangle {
                width: 1
                height: 14
                color: Qt.rgba(Theme.color8.r, Theme.color8.g, Theme.color8.b, 0.4)
                anchors.verticalCenter: parent.verticalCenter
            }

            Weather {}
        }

        // Center section (Workspaces)
        FloatingGroup {
            anchors.centerIn: parent

            Workspaces {}
        }

        // Right section (System Tray, Network, Volume, Battery)
        FloatingGroup {
            id: rightGroup
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.verticalCenter: parent.verticalCenter

            Tray {
                id: trayWidget
            }

            // Visual separator if tray is populated
            Rectangle {
                width: 1
                height: 14
                color: Qt.rgba(Theme.color8.r, Theme.color8.g, Theme.color8.b, 0.4)
                anchors.verticalCenter: parent.verticalCenter
                visible: trayWidget.visible
            }

            Wifi {}

            Rectangle {
                width: 1
                height: 14
                color: Qt.rgba(Theme.color8.r, Theme.color8.g, Theme.color8.b, 0.4)
                anchors.verticalCenter: parent.verticalCenter
            }

            Volume {}

            Rectangle {
                width: 1
                height: 14
                color: Qt.rgba(Theme.color8.r, Theme.color8.g, Theme.color8.b, 0.4)
                anchors.verticalCenter: parent.verticalCenter
            }

            Battery {
                targetSector: rightGroup
            }
        }
    }
}
