import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../Style"

RowLayout {
    id: root

    property bool powered: false
    property bool connectedToDevice: false
    property alias icon: bluetoothIcon

    signal iconClicked()

    Process {
        id: powerCheck
        command: ["sh", "-c", "bluetoothctl show | awk '/Powered:/ {print $2}'"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.powered = text.trim() === "yes";
            }
        }
        Component.onCompleted: running = true
    }

    Process {
        id: connectedCheck
        command: ["sh", "-c", "bluetoothctl devices Connected | wc -l"]
        stdout: StdioCollector {
            onStreamFinished: {
                root.connectedToDevice = parseInt(text.trim()) > 0;
            }
        }
        Component.onCompleted: running = true
    }

    Timer {
        interval: 4000
        running: true
        repeat: true
        onTriggered: {
            powerCheck.running = true;
            connectedCheck.running = true;
        }
    }

    BluetoothIcon {
        id: bluetoothIcon
        powered: root.powered
        connected: root.connectedToDevice
        font.pixelSize: Theme.icon_size

        MouseArea {
            anchors.fill: parent
            onClicked: root.iconClicked()
        }
    }
}
