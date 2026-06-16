import Quickshell
import QtQuick
import "../Style"

Text {

    text: Qt.formatDateTime(clock.date, "ddd dd MMM   HH:mm")
    color: Theme.fg
    font.family: Theme.font
    font.weight: 800
    font.pixelSize: Theme.xl
    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}
