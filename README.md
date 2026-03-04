# nc-carcontrol & nc-hud — Update Notes (March 4, 2026)

## nc-carcontrol v1.0.0

### 🚗 New Resource — Vehicle Control Panel NUI

A realistic vehicle control panel for FiveM that opens while holding `~` key.

**Features:**

- **Key Cylinder Ignition** — 3D animated key (Three.js) with LOCK → ACC → ON → START states
- **Push-Button Ignition** — Chrome push-button for premium/supercar vehicles (auto-detected by model hash or vehicle class)
- **Drive Modes** — ECO (60% power, 80km/h cap) / STANDARD (100%) / SPORTS (130%) with rotary CSS knob
- **Door Lock** — Vertical rocker switch with key fob animation and vehicle light flash
- **Seatbelt** — Click toggle with mst_seatbelt integration or built-in ejection system
- **Cruise Control** — Full cruise system with:
  - Scroll knob speed adjustment (±5)
  - RES / SET+ / CNCL / SET- / LIM buttons
  - MPH ↔ KMH unit toggle (click label to switch)
  - Natural acceleration via `SetControlNormal` (no `SetVehicleForwardSpeed` hacks)
  - Vehicle max speed capping via `GetVehicleEstimatedMaxSpeed`
  - Auto-disable on brake, engine off, or vehicle exit
  - Speed limiter mode (caps speed without auto-acceleration)
- **Per-Vehicle State** — Engine, lock, drive mode saved per-vehicle during session
- **Per-Class Performance** — Configurable max gear and power per vehicle class/model
- **Driver Seat Only** — NUI accessible only from driver seat

**Tech Stack:** Vue 3 + TypeScript + Vite + Three.js + Tailwind CSS + Lua (FiveM client/server)

**Dependencies:** [mst_seatbelt](https://docs.mosotoscripts.com/scripts/mst_seatbelt) (optional)

### File Structure

```
nc-carcontrol/
├── config.lua           # All settings
├── fxmanifest.lua
├── server.lua
├── client/
│   └── main.lua         # Vehicle logic, callbacks, cruise thread
└── web/
    ├── src/
    │   ├── App.vue
    │   └── components/
    │       ├── KeyIgnition.vue      # 3D key cylinder
    │       ├── ButtonIgnition.vue   # 3D push-button
    │       ├── DriveKnob.vue        # CSS rotary knob
    │       ├── LockRocker.vue       # Vertical rocker
    │       ├── Seatbelt.vue         # Seatbelt toggle
    │       └── CruiseControl.vue    # Cruise panel
    └── dist/
```

### Exports

| Export | Returns | Description |
|--------|---------|-------------|
| `GetVehicleStates()` | `{ engine, locked, driveMode, isInVehicle }` | Current vehicle states |
| `SetDriveMode(mode)` | — | Set drive mode (`'ECO'`, `'STANDARD'`, `'SPORTS'`) |
| `ToggleEngine()` | `bool/nil` | Toggle engine on/off |
| `ToggleLock()` | `bool/nil` | Toggle door lock |

### Installation

```cfg
ensure nc-carcontrol
```

---

## nc-hud (nox-hud) — Patch

### 🛠️ Speedometer MPH Fix

**File:** `modules/speedometer.lua`

**Change:** Corrected the MPH conversion multiplier from `2.2` to `2.23694`.

```lua
-- Before (inaccurate, ~1.7% off)
local speed = GetEntitySpeed(vehicle) * 2.2

-- After (correct)
local speed = GetEntitySpeed(vehicle) * 2.23694
```

**Impact:** Speed display was reading approximately 1–3 mph lower than actual vehicle speed. This fix aligns nc-hud's speedometer with the real GTA V speed values and ensures consistency with nc-carcontrol's cruise control system.

---

## Documentation

Full documentation available at [docs.noxcore.me](https://docs.noxcore.me):

- [nc-carcontrol](https://docs.noxcore.me/#/nc-carcontrol/) — Installation, Features, Configuration, Exports
- [nox-hud](https://docs.noxcore.me/#/nox-hud/) — Updated changelog with MPH fix

---

**Discord:** [discord.gg/noxcore](https://discord.gg/noxcore)
