import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import "menus"
import "modules/bar"
import "modules/launcher"

ShellRoot {
    id: root

    Variants {
        model: Hyprland.monitors.values

        delegate: Bar {
            required property HyprlandMonitor modelData

            screen: modelData.screen
        }

    }

    Launcher {
        id: appLauncher
    }

    CustomMenu {
        id: customMenu
    }

    IpcHandler {
        function handle(msg: string) {
            if (msg === "toggle")
                appLauncher.toggle();

        }

        target: "launcher"
    }

    IpcHandler {
        function handle(msg: string) {
            if (msg === "toggle")
                customMenu.toggle();

        }

        target: "custommenu"
    }

}
