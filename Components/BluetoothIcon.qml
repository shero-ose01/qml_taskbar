import QtQuick
import "../Style"

Text {
    property bool powered: false
    property bool connected: false

    font.family: Theme.font
    color: !powered ? Theme.red : connected ? Theme.green : Theme.blue
    text: !powered ? "󰂲" : connected ? "󰂱" : "󰂯"
}
