import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import "./Popups"

ShellRoot {
    Variants {
        model: Quickshell.screens

        Bar {}
    }
}
