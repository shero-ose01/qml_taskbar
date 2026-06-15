import Quickshell
import Quickshell.Wayland
import QtQuick.Layouts
import QtQuick

PanelWindow {
    required property var modelData
    screen: modelData

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 35

    color: Theme.bg

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        Workspaces {}
        Item {
            Layout.fillWidth: true
        }
        Clock {
            anchors.centerIn: parent
        }
        Item {
            Layout.fillWidth: true
        }
        SysStats {}
    }
}
