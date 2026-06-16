import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../Style"

RowLayout {

    property bool connectedToNetwork: false
    property int signalToNetwork: 0

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

    Text {
        font.family: Theme.font
        font.pixelSize: Theme.icon_size
        color: connectedToNetwork ? Theme.green : Theme.red
        text: !connectedToNetwork ? "󰤮" : signalToNetwork < 10 ? "󰤯" : signalToNetwork < 25 ? "󰤟" : signalToNetwork < 50 ? "󰤢" : signalToNetwork < 75 ? "󰤥" : "󰤨"

        /*
         * 󰤮
         * 󰤯
         * 󰤟
         * 󰤢
         * 󰤥
         * 󰤨
         * */
    }
}
