# nc-carcontrol

A realistic vehicle control panel NUI for FiveM. Hold `~` to open the panel while in the driver seat. Supports key cylinder ignition, push-button start, drive modes, door lock, seatbelt, and cruise control — all rendered in a modern UI with Three.js and Vue 3.

**Dependencies:** [mst_seatbelt](https://docs.mosotoscripts.com/scripts/mst_seatbelt) (optional)

---

## Preview

![nc-carcontrol Full View 1](screenshots/full-1.png)

![nc-carcontrol Full View 2](screenshots/full-2.png)

---

## Components

### Key Cylinder Ignition

3D animated key cylinder (Three.js) with LOCK → ACC → ON → START states. Rotates with click interaction.

![Key Cylinder Ignition](screenshots/key-ignition.png)

### Push-Button Ignition

Chrome push-button for premium/supercar vehicles. Automatically assigned by model hash or vehicle class.

![Push-Button Ignition](screenshots/button-ignition.png)

### Drive Mode Knob

CSS rotary knob to switch between ECO / STANDARD / SPORTS drive modes with per-class power and speed tuning.

![Drive Mode Knob](screenshots/drive-knob.png)

### Door Lock Rocker

Vertical rocker switch with key fob animation and vehicle light flash on toggle.

![Door Lock Rocker](screenshots/lock-rocker.png)

### Seatbelt

Click toggle with mst_seatbelt integration. Falls back to built-in ejection system if mst_seatbelt is not installed.

![Seatbelt](screenshots/seatbelt.png)

### Cruise Control

Full cruise system with scroll knob (±5), RES / SET+ / CNCL / SET- / LIM buttons, MPH ↔ KMH toggle, natural acceleration, and speed limiter mode.

![Cruise Control](screenshots/cruise-control.png)

---

## Installation

```cfg
ensure nc-carcontrol
```

## Documentation

[docs.noxcore.me/nc-carcontrol](https://docs.noxcore.me/#/nc-carcontrol/)

## Discord

[discord.gg/noxcore](https://discord.gg/noxcore)
