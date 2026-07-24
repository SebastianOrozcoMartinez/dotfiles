//@ pragma UseQApplication

import Quickshell
import Quickshell.Hyprland
import "panels"

ShellRoot {
    Variants {
        model: Quickshell.screens
        delegate: Scope {
            required property var modelData
            TopBar {
                screen: modelData
            }
        }
    }
}
