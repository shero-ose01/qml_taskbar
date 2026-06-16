import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts
import "../Style"

RowLayout {
    spacing: 5
    Repeater {
        model: 9

        Rectangle {
            property int wsId: index + 1
            property bool exists: Hyprland.workspaces.values.some(w => w.id === wsId)
            property bool active: Hyprland.focusedWorkspace?.id === wsId

            Layout.preferredWidth: active ? 22 : 10
            Layout.preferredHeight: 10
            radius: 4
            color: active ? Theme.yellow : exists ? Theme.fg : Theme.gray

            Behavior on width {
                NumberAnimation {
                    duration: 120
                }
            }

            MouseArea {
                anchors.fill: parent
                onClicked: Hyprland.dispatch("workspace " + wsId)
            }
        }
    }
}
