import QtQuick
import "../Style"

Text {
    property int strength: 0
    property bool connected: true

    font.family: Theme.font
    color: connected ? Theme.green : Theme.red
    text: !connected ? "󰤮"
        : strength < 10 ? "󰤯"
        : strength < 25 ? "󰤟"
        : strength < 50 ? "󰤢"
        : strength < 75 ? "󰤥"
        : "󰤨"
}
