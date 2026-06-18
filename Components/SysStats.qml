import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "../Style"

RowLayout {
    spacing: 16

    property int cpu: 0
    property int lastIdle: 0
    property int lastTotal: 0

    Process {
        id: cpuProc
        command: ["head", "-1", "/proc/stat"]
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

    property int cpuTemp: 0

    Process {
        id: cpuTempProc
        command: ["sh", "-c", "sensors | awk '/^(Tctl|Package id 0|Tdie):/ {gsub(/[+°C]/, \"\", $2); print $2; exit}'"]
        stdout: StdioCollector {
            onStreamFinished: {
                const v = parseFloat(text.trim());
                cpuTemp = isNaN(v) ? 0 : Math.round(v);
            }
        }
        Component.onCompleted: running = true
    }

    property int gpuTemp: 0
    property int gpuUsage: 0

    Process {
        id: gpuProc
        command: ["sh", "-c", "nvidia-smi --query-gpu=temperature.gpu,utilization.gpu --format=csv,noheader,nounits"]
        stdout: StdioCollector {
            onStreamFinished: {
                const parts = text.trim().split(",");
                const t = parseInt(parts[0]);
                const u = parseInt(parts[1]);
                gpuTemp = isNaN(t) ? 0 : t;
                gpuUsage = isNaN(u) ? 0 : u;
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
            cpuTempProc.running = true;
            gpuProc.running = true;
        }
    }

    Text {
        font.family: Theme.font
        font.pixelSize: Theme.xs
        color: Theme.green
        text: "CPU " + cpu + "% " + cpuTemp + "°C"
    }

    Text {
        font.family: Theme.font
        font.pixelSize: Theme.xs
        color: Theme.green
        text: "RAM " + ram + "%"
    }

    Text {
        font.family: Theme.font
        font.pixelSize: Theme.xs
        color: Theme.green
        text: "GPU " + gpuUsage + "% " + gpuTemp + "°C"
    }
}
