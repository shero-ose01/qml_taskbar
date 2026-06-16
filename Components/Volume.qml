import Quickshell.Services.Pipewire
import QtQuick
import "../Style"

Text {
    property PwNode sink: Pipewire.defaultAudioSink
    property PwNodeAudio audio: sink?.audio ?? null
    property real vol: audio?.volume ?? 0
    property bool muted: audio?.muted ?? false

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }

    text: (muted ? "󰝟 " : "󰕾 ") + Math.round(vol * 100) + "%"
    color: muted ? Theme.red : Theme.aqua
    font.family: Theme.font
    font.pixelSize: Theme.sm
}
