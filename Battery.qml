import Quickshell.Services.UPower
import QtQuick

Text {
    property var battery: UPower.displayDevice

    visible: battery?.isLaptopBattery ?? false
    font.family: Theme.font
    font.pixelSize: Theme.sm
    text: (battery?.state === UPowerDeviceState.Charging ? "󰂄 " : "󰁹 ") + Math.round((battery?.percentage ?? 0) * 100) + "%"

    color: {
        const p = battery?.percentage ?? 1;
        const charging = battery?.state === "Charging" as UPowerDeviceState;
        return charging ? Theme.fg : p < 0.15 ? Theme.red : p < 0.30 ? Theme.yellow : Theme.fg;
    }
}
