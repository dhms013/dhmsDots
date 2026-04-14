import QtQuick
import Quickshell.Services.UPower
pragma Singleton

QtObject {
    id: root

    function buildTree() {
        var powerProfileChildren = [{
            "icon": "",
            "label": "Power Saver",
            "cmd": "powerprofilesctl set power-saver"
        }, {
            "icon": "",
            "label": "Balanced",
            "cmd": "powerprofilesctl set balanced"
        }];
        if (PowerProfiles.hasPerformanceProfile)
            powerProfileChildren.push({
            "icon": "",
            "label": "Performance",
            "cmd": "powerprofilesctl set performance"
        });

        return [{
            "icon": "",
            "label": "Update",
            "cmd": "floating-terminal dhms-update"
        }, {
            "icon": "",
            "label": "Setup",
            "children": [{
                "icon": "",
                "label": "Background",
                "cmd": "quickshell ipc call openBackgroundPicker handle"
            }, {
                "icon": "󰱔",
                "label": "DNS",
                "cmd": "floating-terminal setup-dns"
            }, {
                "icon": "󰉉",
                "label": "Install",
                "children": [{
                    "icon": "󰣇",
                    "label": "Packages",
                    "cmd": "floating-terminal pkg-install-all"
                }, {
                    "icon": "󰸌",
                    "label": "Themes",
                    "cmd": "floating-terminal theme-install"
                }]
            }, {
                "icon": "󱐋",
                "label": "Power Profile",
                "children": powerProfileChildren
            }, {
                "icon": "󰭌",
                "label": "Remove",
                "cmd": "floating-terminal pkg-remove"
            }, {
                "icon": "󰸌",
                "label": "Themes",
                "cmd": "quickshell ipc call openThemePicker handle"
            }, {
                "icon": "",
                "label": "Security",
                "children": [{
                    "icon": "󰈷",
                    "label": "Fingerprint",
                    "cmd": "floating-terminal setup-fingerprint"
                }, {
                    "icon": "",
                    "label": "Fido2",
                    "cmd": "floating-terminal setup-fido2"
                }]
            }]
        }, {
            "icon": "",
            "label": "System",
            "children": [{
                "icon": "󰒲",
                "label": "Suspend",
                "cmd": "sh -c 'if pgrep -x \"hypridle\" >/dev/null 2>&1; then systemctl suspend; else uwsm-app hypridle & sleep 1; systemctl suspend; fi'"
            }, {
                "icon": "",
                "label": "Lock",
                "cmd": "hyprlock"
            }, {
                "icon": "󰍃",
                "label": "Logout",
                "cmd": "uwsm stop"
            }, {
                "icon": "󰜉",
                "label": "Reboot",
                "cmd": "systemctl reboot --no-wall"
            }, {
                "icon": "󰐥",
                "label": "Shutdown",
                "cmd": "systemctl poweroff"
            }]
        }];
    }

}
