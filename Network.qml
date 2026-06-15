import Quickshell.Io
import QtQuick
import QtQuick.Layouts

RowLayout {

    property bool connectedToNetwork: false

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

    Timer {
        interval: 4000
        running: true
        repeat: true
        onTriggered: {
            network.running = true;
        }
    }

    Text {
        font.family: Theme.font
        font.pixelSize: Theme.xl
        color: connectedToNetwork ? Theme.green : Theme.red
        text: connectedToNetwork ? "󰖩" : "󱛅"
    }
}
