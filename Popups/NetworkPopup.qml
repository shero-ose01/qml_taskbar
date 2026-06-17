import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import "../Style"
import "../Components"

PopupWindow {
    id: networkPopup
    required property var bar
    required property var icon
    visible: false
    anchor.window: bar
    anchor.item: icon
    anchor.margins.top: icon.height

    implicitWidth: 250
    implicitHeight: layout.implicitHeight + 2 * Theme.padding

    color: Theme.bg

    property var networks: []

    onVisibleChanged: if (visible)
        scan.running = true

    Process {
        id: scan
        command: ["sh", "-c", "nmcli -t -f IN-USE,SIGNAL,SSID device wifi"]
        stdout: StdioCollector {
            onStreamFinished: {
                networks = text.trim().split("\n").filter(line => line.length > 0).map(line => {
                    const parts = line.split(":");
                    return {
                        inUse: parts[0] === "*",
                        signal: parseInt(parts[1]),
                        ssid: parts[2]
                    };
                });
            }
        }
    }

    Process {
        id: connector
        onExited: scan.running = true
    }

    ColumnLayout {
        id: layout
        anchors.fill: parent
        anchors.margins: Theme.padding

        Text {
            font.family: Theme.font
            font.pixelSize: Theme.xl
            color: Theme.fg
            text: "Networks"
        }

        Repeater {
            model: networkPopup.networks

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

                    SignalIcon {
                        strength: modelData.signal
                        color: modelData.inUse ? Theme.green : Theme.fg
                        font.pixelSize: Theme.sm
                    }

                    Text {
                        font.family: Theme.font
                        font.pixelSize: Theme.sm
                        color: Theme.fg
                        text: modelData.ssid
                        Layout.fillWidth: true
                    }
                }

                TapHandler {
                    onTapped: {
                        connector.command = ["nmcli", "device", "wifi", "connect", modelData.ssid];
                        connector.running = true;
                    }
                }
            }
        }
    }
}
