# nc-carcontrol

A realistic vehicle control panel NUI for FiveM. Hold `~` to open the panel while in the driver seat. Supports key cylinder ignition, push-button start, drive modes, door lock, seatbelt, and cruise control — all rendered in a modern UI with Three.js and Vue 3.

**Dependencies:** [mst_seatbelt](https://docs.mosotoscripts.com/scripts/mst_seatbelt) (optional)

---

## Preview

![nc-carcontrol Full View 1](https://r2.fivemanage.com/AGIqkS85vq6NpkHypOknK/nc-carcontrol1.png)

![nc-carcontrol Full View 2](https://r2.fivemanage.com/AGIqkS85vq6NpkHypOknK/nc-carcontrol2.png)

---

## Components

### Key Cylinder Ignition

3D animated key cylinder (Three.js) with LOCK → ACC → ON → START states. Rotates with click interaction.

![Key Cylinder Ignition](https://r2.fivemanage.com/AGIqkS85vq6NpkHypOknK/start1.png)

### Push-Button Ignition

Chrome push-button for premium/supercar vehicles. Automatically assigned by model hash or vehicle class.

![Push-Button Ignition](https://r2.fivemanage.com/AGIqkS85vq6NpkHypOknK/start2.png)

### Drive Mode Knob

CSS rotary knob to switch between ECO / STANDARD / SPORTS drive modes with per-class power and speed tuning.

![Drive Mode Knob](https://r2.fivemanage.com/AGIqkS85vq6NpkHypOknK/drivemode.png)

### Door Lock Rocker

Vertical rocker switch with key fob animation and vehicle light flash on toggle.

![Door Lock Rocker](https://r2.fivemanage.com/AGIqkS85vq6NpkHypOknK/lockunlock.png)

### Seatbelt

Click toggle with mst_seatbelt integration. Falls back to built-in ejection system if mst_seatbelt is not installed.

![Seatbelt ON](https://r2.fivemanage.com/AGIqkS85vq6NpkHypOknK/seatbelton.png)
![Seatbelt OFF](https://r2.fivemanage.com/AGIqkS85vq6NpkHypOknK/seatbeltoff.png)

### Cruise Control

Full cruise system with scroll knob (±5), RES / SET+ / CNCL / SET- / LIM buttons, MPH ↔ KMH toggle, natural acceleration, and speed limiter mode.

![Cruise Control](https://r2.fivemanage.com/AGIqkS85vq6NpkHypOknK/cruise.png)

---

## Installation

```cfg
ensure nc-carcontrol
```

## Documentation

[docs.noxcore.me/nc-carcontrol](https://docs.noxcore.me/#/nc-carcontrol/)

## Discord

[discord.gg/noxcore](https://discord.gg/noxcore)


