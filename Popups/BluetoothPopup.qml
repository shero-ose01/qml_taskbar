import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "../Style"
import "../Components"

PopupWindow {
    id: bluetoothPopup
    required property var bar
    required property var icon
    visible: false
    anchor.window: bar
    anchor.item: icon
    anchor.margins.top: icon.height

    implicitWidth: 250
    implicitHeight: layout.implicitHeight + 2 * Theme.padding

    color: Theme.bg

    property var devices: []
    property var connectedMacs: []

    function isConnected(mac) {
        return connectedMacs.indexOf(mac) >= 0;
    }

    Process {
        id: scanner
        command: ["bluetoothctl", "scan", "on"]
        running: bluetoothPopup.visible
    }

    Process {
        id: deviceList
        command: ["bluetoothctl", "devices"]
        stdout: StdioCollector {
            onStreamFinished: {
                devices = text.trim().split("\n").filter(line => line.startsWith("Device ")).map(line => {
                    const match = line.match(/^Device ([0-9A-Fa-f:]+) (.*)$/);
                    return match ? {
                        mac: match[1],
                        name: match[2]
                    } : null;
                }).filter(d => d !== null);
            }
        }
    }

    Process {
        id: connectedList
        command: ["bluetoothctl", "devices", "Connected"]
        stdout: StdioCollector {
            onStreamFinished: {
                connectedMacs = text.trim().split("\n").filter(line => line.startsWith("Device ")).map(line => line.split(" ")[1]);
            }
        }
    }

    Process {
        id: connector
        onExited: {
            deviceList.running = true;
            connectedList.running = true;
        }
    }

    Timer {
        interval: 3000
        running: bluetoothPopup.visible
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            deviceList.running = true;
            connectedList.running = true;
        }
    }

    ColumnLayout {
        id: layout
        anchors.fill: parent
        anchors.margins: Theme.padding

        Text {
            font.family: Theme.font
            font.pixelSize: Theme.xl
            color: Theme.fg
            text: "Bluetooth"
        }

        Repeater {
            model: bluetoothPopup.devices

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: row.implicitHeight
                color: hover.hovered ? Theme.gray : "transparent"

                HoverHandler {
                    id: hover
                }

                RowLayout {
                    id: row
                    anchors.fill: parent

                    Text {
                        font.family: Theme.font
                        font.pixelSize: Theme.sm
                        color: bluetoothPopup.isConnected(modelData.mac) ? Theme.green : Theme.fg
                        text: bluetoothPopup.isConnected(modelData.mac) ? "󰂱" : "󰂯"
                    }

                    Text {
                        font.family: Theme.font
                        font.pixelSize: Theme.sm
                        color: Theme.fg
                        text: modelData.name
                        Layout.fillWidth: true
                    }
                }

                TapHandler {
                    onTapped: {
                        const connected = bluetoothPopup.isConnected(modelData.mac);
                        connector.command = ["bluetoothctl", connected ? "disconnect" : "connect", modelData.mac];
                        connector.running = true;
                    }
                }
            }
        }
    }
}
