# setup-screen: merge plan

## Analysis

**Bug on T14s laptop**: `setup-screen off` uses `brightnessctl set 0` instead of DPMS, bypassing the normal wake cycle. On resume, `brightnessctl -r` restores brightness but the panel never got a DPMS cycle → screen stays dark.

Desktop (B650M) works fine — no backlight device → uses DPMS directly.

## Plan for merged setup-screen

- DPMS off/on: use for **both** laptop and desktop (drop brightness-0 trick)
- Brightness stepping: add `+5%` / `5%-` / `N%` support
- Backend selection: reuse `_detect_backend()` from `brightness` script (brightnessctl on laptop, ddcutil on desktop)
- No OSD, no Apple block, no `omarchy-*` calls
- Optional: lock file to debounce repeated key events (from omarchy script)

## Test on laptop first

Before writing the final script, test these on the T14s:
1. Does `hyprctl dispatch dpms off` / `hyprctl dispatch dpms on` work?
2. Does `brightnessctl -s` / `brightnessctl -r` work reliably?
3. What is the backlight device name on T14s? (`ls /sys/class/backlight/`)
4. Does `brightnessctl` with that device work for stepping?

```bash
# Quick laptop diagnostics
ls /sys/class/backlight/
brightnessctl -s
brightnessctl -r
hyprctl dispatch dpms off
```
