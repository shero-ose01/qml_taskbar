import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick

ShellRoot {
    Variants {
        model: Quickshell.screens

        Bar {}
    }
}
