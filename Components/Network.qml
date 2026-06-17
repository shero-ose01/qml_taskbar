import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../Style"

RowLayout {

    property bool connectedToNetwork: false
    property int signalToNetwork: 0
    property alias icon: networkIcon

    signal iconClicked()

    Process {
        id: network
        command: ["nmcli", "g"]
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n");
                const values = lines[1].split(/\s+/);
                connectedToNetwork = values[0] === "connected";
            }
        }
        Component.onCompleted: running = true
    }

    Process {
        id: signal
        command: ["sh", "-c", "nmcli -f IN-USE,SIGNAL,SSID device wifi | awk '/^\\*/{if (NR!=1) {print $2}}'"]
        stdout: StdioCollector {
            onStreamFinished: {
                signalToNetwork = parseInt(text.trim());
            }
        }
        Component.onCompleted: running = true
    }

    Timer {
        interval: 4000
        running: true
        repeat: true
        onTriggered: {
            network.running = true;
            signal.running = true;
        }
    }

    SignalIcon {
        id: networkIcon
        strength: signalToNetwork
        connected: connectedToNetwork
        font.pixelSize: Theme.icon_size

        MouseArea {
            anchors.fill: parent
            onClicked: iconClicked()
        }
    }
}
