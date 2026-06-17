import Quickshell
import QtQuick.Layouts
import QtQuick
import "./Components"
import "./Style"
import "./Popups"

PanelWindow {
    id: bar
    required property var modelData
    screen: modelData

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 35

    color: Theme.bg

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        Workspaces {}
        Item {
            Layout.fillWidth: true
        }
        Clock {
            anchors.centerIn: parent
        }
        Item {
            Layout.fillWidth: true
        }
        RowLayout {
            spacing: 20
            SysStats {}
            Volume {}
            Battery {}
            Bluetooth {
                id: bluetooth
                onIconClicked: bluetoothPopup.visible = !bluetoothPopup.visible
            }
            Network {
                id: network
                onIconClicked: networkPopup.visible = !networkPopup.visible
            }
        }
    }
    NetworkPopup {
        id: networkPopup
        bar: bar
        icon: network.icon
    }
    BluetoothPopup {
        id: bluetoothPopup
        bar: bar
        icon: bluetooth.icon
    }
}
