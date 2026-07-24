import QtQuick
import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import "../theme"

Row {
    id: root
    spacing: 8

    // Bind visibility to the number of instantiated delegate items
    visible: trayRepeater.count > 0

    Repeater {
        id: trayRepeater
        model: SystemTray.items

        delegate: MouseArea {
            id: itemArea
            width: 20
            height: 40 // matches the height of the bar (40px) to resolve vertical offset
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton | Qt.RightButton

            IconImage {
                id: trayIcon
                width: 20
                height: 20
                anchors.centerIn: parent
                source: modelData.icon || ""
                smooth: true
                antialiasing: true
            }

            QsMenuAnchor {
                id: menuAnchor
                menu: modelData.menu
                anchor.item: itemArea
            }

            onClicked: (mouse) => {
                if (mouse.button === Qt.RightButton && modelData.hasMenu) {
                    menuAnchor.open();
                } else {
                    modelData.activate();
                }
            }
        }
    }
}
