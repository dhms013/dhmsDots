import QtQuick
import Quickshell.Io

Item {
    id: root

    property bool showing: false
    property string icon: "󰕾"
    property string title: "Volume"
    property string subtitle: ""
    property string valueText: "0%"
    property string artUrl: ""
    property bool mediaMode: false
    property int value: 0
    property int savedBrightness: 50
    property string tone: "accent"
    property int waveBars: 22
    property var wave: _emptyWave()
    property var cavaInputs: ["pipewire", "pulse"]
    property int cavaInputIdx: 0
    property string _cavaCarry: ""
    property var _cavaTokens: []
    property bool hasWpctl: false
    property bool hasBrightnessctl: false
    property bool hasCava: false

    function _clamp(v, lo, hi) {
        return Math.max(lo, Math.min(hi, v));
    }

    function _emptyWave() {
        const arr = [];
        for (let i = 0; i < waveBars; i++) arr.push(0)
        return arr;
    }

    function _show(iconGlyph, titleText, valuePercent, toneName) {
        icon = iconGlyph;
        title = titleText;
        subtitle = "";
        value = _clamp(Math.round(valuePercent), 0, 100);
        valueText = value + "%";
        artUrl = "";
        mediaMode = false;
        tone = toneName;
        hideTimer.interval = 1400;
        showing = true;
        hideTimer.restart();
    }

    function _formatSeconds(totalSeconds) {
        const secs = Math.max(0, Math.floor(totalSeconds || 0));
        const minutes = Math.floor(secs / 60);
        const seconds = secs % 60;
        return minutes + ":" + (seconds < 10 ? "0" : "") + seconds;
    }

    

    function _volumeIcon(level, muted) {
        if (muted || level <= 0)
            return "󰝟";

        if (level < 34)
            return "󰕿";

        if (level < 67)
            return "󰖀";

        return "󰕾";
    }

    function _applyCavaFrame(parts) {
        const out = [];
        for (let i = 0; i < waveBars; i++) {
            const idx = Math.floor(i * (parts.length - 1) / Math.max(1, waveBars - 1));
            const n = parseInt(parts[idx]);
            const target = isNaN(n) ? 0 : _clamp(n / 1000, 0, 1);
            const prev = (wave && i < wave.length) ? wave[i] : 0;
            out.push((prev * 0.58) + (target * 0.42));
        }
        wave = out;
    }

    function _applyCavaChunk(data) {
        const chunks = (_cavaCarry + (data || "")).split(";");
        _cavaCarry = chunks.pop();
        for (const c of chunks) {
            const n = parseInt((c || "").trim());
            if (!isNaN(n))
                _cavaTokens.push(n);

        }
        while (_cavaTokens.length >= waveBars) {
            const frame = _cavaTokens.slice(0, waveBars);
            _cavaTokens = _cavaTokens.slice(waveBars);
            _applyCavaFrame(frame);
        }
    }

    function _cavaCommand(inputMethod) {
        return "CFG=/tmp/quickshell-osd-cava.conf; " + "cat > \"$CFG\" <<'EOF'\n" + "[general]\n" + "bars = 22\n" + "framerate = 60\n" + "sensitivity = 100\n" + "lower_cutoff_freq = 45\n" + "higher_cutoff_freq = 10000\n" + "\n" + "[input]\n" + "method = " + inputMethod + "\n" + "source = auto\n" + "\n" + "[output]\n" + "method = raw\n" + "raw_target = /dev/stdout\n" + "data_format = ascii\n" + "ascii_max_range = 1000\n" + "bar_delimiter = 59\n" + "channels = mono\n" + "EOF\n" + "exec cava -p \"$CFG\" 2>/dev/null";
    }

    function _parseWpctlVolume(raw) {
        const line = (raw || "").trim();
        const n = line.match(/([0-9]*\.?[0-9]+)/);
        const muted = /\bMUTED\b/i.test(line);
        const pct = n ? Math.round(parseFloat(n[1]) * 100) : 0;
        return {
            "value": muted ? 0 : _clamp(pct, 0, 100),
            "muted": muted
        };
    }

    

    function _runShell(cmd, done) {
        const proc = Qt.createQmlObject('import Quickshell.Io; Process { command: ["bash","-lc",""]; running: false; stdout: SplitParser { property string buf: ""; onRead: d => buf += d + "\\n" } }', root, "osdProc" + Math.random().toString().slice(2));
        proc.command = ["bash", "-lc", cmd];
        proc.onExited.connect(function() {
            const out = proc.stdout && proc.stdout.buf ? proc.stdout.buf : "";
            if (done)
                done(out);

            proc.destroy();
        });
        proc.running = true;
    }

    function _showUnavailable(titleText) {
        _show("󰧧", titleText, 0, "muted");
    }

    

    function showVolume() {
        if (!hasWpctl) {
            _showUnavailable("Audio unavailable");
            return ;
        }
        _runShell("wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null", function(out) {
            const p = _parseWpctlVolume(out);
            _show(_volumeIcon(p.value, p.muted), "Volume", p.value, p.muted ? "red" : "accent");
        });
    }

    function showBrightness() {
        if (!hasBrightnessctl) {
            _showUnavailable("Brightness unavailable");
            return ;
        }
        _show("󰃠", "Brightness", _clamp(savedBrightness, 0, 100), "highlight");
        _runShell("bash -lc '/home/dhms/.dhmsDots/bin/brightness get'", function(out) {
            const m = out.match(/"percentage":\s*(\d+)/);
            const v = m ? parseInt(m[1]) : -1;
            if (v >= 0) {
                savedBrightness = v;
                _show("󰃠", "Brightness", _clamp(v, 0, 100), "highlight");
            }
        });
    }

    function showMic() {
        if (!hasWpctl) {
            _showUnavailable("Mic unavailable");
            return ;
        }
        _runShell("wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null", function(out) {
            const p = _parseWpctlVolume(out);
            _show(p.muted ? "󰍭" : "󰍬", "Mic", p.value, p.muted ? "red" : "green");
        });
    }

    function volumeStep(delta) {
        if (!hasWpctl) {
            _showUnavailable("Audio unavailable");
            return ;
        }
        const sign = delta >= 0 ? "+" : "-";
        const pct = Math.abs(Math.round(delta));
        _runShell("wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ " + pct + "%" + sign + " 2>/dev/null; " + "wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null", function(out) {
            const p = _parseWpctlVolume(out);
            _show(_volumeIcon(p.value, p.muted), "Volume", p.value, p.muted ? "red" : "accent");
        });
    }

    function toggleMute() {
        if (!hasWpctl) {
            _showUnavailable("Audio unavailable");
            return ;
        }
        _runShell("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle 2>/dev/null; " + "wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null", function(out) {
            const p = _parseWpctlVolume(out);
            _show(_volumeIcon(p.value, p.muted), "Volume", p.value, p.muted ? "red" : "accent");
        });
    }

    function brightnessStep(delta) {
        if (!hasBrightnessctl) {
            _showUnavailable("Brightness unavailable");
            return ;
        }
        const dir = delta >= 0 ? "up" : "down";
        savedBrightness = _clamp(savedBrightness + delta, 0, 100);
        // Apply brightness FIRST, before showing toast
        var proc = Qt.createQmlObject('import Quickshell.Io; Process { command: ["bash","-lc","/home/dhms/.dhmsDots/bin/brightness ' + dir + '"]; running: false }', root, "brightProc" + Date.now());
        proc.running = true;
        // Then show toast
        _show("󰃠", "Brightness", savedBrightness, "highlight");
    }

    Process {
        id: depsProbe

        command: ["bash", "-lc", "printf 'wpctl=%s\\n' \"$(command -v wpctl >/dev/null 2>&1 && echo 1 || echo 0)\"; " + "printf 'brightnessctl=%s\\n' \"$( [ -x \"$HOME/.dhmsDots/bin/brightness\" ] && echo 1 || echo 0)\"; " + "printf 'cava=%s\\n' \"$(command -v cava >/dev/null 2>&1 && echo 1 || echo 0)\""]
        running: true
        onExited: {
            if (root.hasCava)
                cavaProc.running = true;

        }

        stdout: SplitParser {
            onRead: (data) => {
                const parts = data.trim().split("=");
                if (parts.length !== 2)
                    return ;

                const enabled = parts[1].trim() === "1";
                if (parts[0] === "wpctl")
                    root.hasWpctl = enabled;
                else if (parts[0] === "brightnessctl")
                    root.hasBrightnessctl = enabled;
                else if (parts[0] === "cava")
                    root.hasCava = enabled;
            }
        }

    }

    Process {
        id: cavaProc

        command: ["bash", "-lc", root._cavaCommand(root.cavaInputs[root.cavaInputIdx])]
        running: false
        onExited: {
            if (!root.hasCava)
                return ;

            root.wave = root._emptyWave();
            root._cavaCarry = "";
            root._cavaTokens = [];
            root.cavaInputIdx = (root.cavaInputIdx + 1) % root.cavaInputs.length;
            cavaRestart.restart();
        }

        stdout: SplitParser {
            onRead: (data) => {
                root._applyCavaChunk(data);
            }
        }

    }

    Timer {
        id: cavaRestart

        interval: 1200
        repeat: false
        onTriggered: {
            if (!root.hasCava)
                return ;

            cavaProc.command = ["bash", "-lc", root._cavaCommand(root.cavaInputs[root.cavaInputIdx])];
            cavaProc.running = true;
        }
    }

    Timer {
        id: hideTimer

        interval: 1400
        repeat: false
        onTriggered: root.showing = false
    }

}
