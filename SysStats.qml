import Quickshell.Io
import QtQuick
import QtQuick.Layouts

RowLayout {
    spacing: 16

    property int cpu: 0
    property int lastIdle: 0
    property int lastTotal: 0

    Process {
        id: cpuProc
        command: ["head", "-1", "/proc/stat"]   // only the aggregate line
        stdout: StdioCollector {
            onStreamFinished: {
                const f = text.trim().split(/\s+/);
                const idle = parseInt(f[4]) + parseInt(f[5]);
                const total = f.slice(1).reduce((a, b) => a + parseInt(b), 0);
                if (lastTotal > 0)
                    cpu = Math.round(100 * (1 - (idle - lastIdle) / (total - lastTotal)));
                lastIdle = idle;
                lastTotal = total;
            }
        }
        Component.onCompleted: running = true
    }

    property int ram: 0

    Process {
        id: ramProc
        command: ["head", "-3", "/proc/meminfo"]
        stdout: StdioCollector {
            onStreamFinished: {
                // so MemFree actually isnt the "Free Memory" but just memory not touched by the kernel, memAvailable is the correct value in line 3 of meminfo
                const lines = text.trim().split("\n");

                const memTotal = parseInt(lines[0].split(/\s+/)[1]);
                const memAvailable = parseInt(lines[2].split(/\s+/)[1]);
                ram = Math.round((memTotal - memAvailable) / memTotal * 100);
            }
        }
        Component.onCompleted: running = true
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: {
            cpuProc.running = true;
            ramProc.running = true;
        }
    }

    Text {
        font.family: Theme.font
        font.pixelSize: Theme.xs
        color: Theme.green
        text: "CPU " + cpu + "%"
    }

    Text {
        font.family: Theme.font
        font.pixelSize: Theme.xs
        color: Theme.green
        text: "RAM " + ram + "%"
    }
}
