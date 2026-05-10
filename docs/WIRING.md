# Ferris FieldDeck 11 Wiring

## Keyboard Architecture

Use a Sweep v2.2-compatible 34-key split keyboard with two Pro Micro-footprint USB-C controllers.

Chosen controller class: SparkFun Pro Micro RP2040 or any pin-compatible USB-C Pro Micro RP2040 board.

Do not use Seeed XIAO RP2040 for this revision. XIAO is smaller, but the available GPIO count is too tight for a direct-pin Sweep-style 17-key half without adding an I/O expander or diode matrix. A Pro Micro-footprint controller keeps the design generic, easy to source, and compatible with existing Sweep firmware work.

## Internal Wiring

| Connection | Cable | Route |
|---|---|---|
| Left keyboard controller USB-C | 100-150 mm right-angle USB-C cable | Left controller to rear keyboard/service USB-C breakout |
| Left-to-right split interconnect | JST-SH 4-pin, 150-180 mm | Central printed cable channel between keyboard wells |
| Tablet power/data lead | Short right-angle USB-C | Lid tablet USB-C to rear hinge service loop |
| PD input | 26-28 AWG silicone wire | Rear USB-C PD board to protected power module |
| USB-A service/accessory | 26-28 AWG silicone wire or short USB pigtail | Rear USB-A board to internal hub/service point |

## JST-SH Split Interconnect Pinout

Use a keyed JST-SH cable instead of an exposed TRRS cable inside the deck.

| JST Pin | Signal | Notes |
|---:|---|---|
| 1 | GND | Common ground between halves |
| 2 | 3V3 or VCC | Match selected controller and firmware wiring |
| 3 | SERIAL | QMK split serial data |
| 4 | RESET | Optional remote reset; may be left NC if not used |

## Controller Placement

The controller envelope in CAD is `34 x 18.5 x 5.0 mm`, which fits a Pro Micro RP2040-class board mounted low behind the left keyboard tray. Keep USB-C connector access pointed toward the rear service port.

## Keyboard PCB Package

Use the vendored Sweep v2.2 Gerber ZIP for first fabrication:

```text
hardware/keyboard/Sweep/Sweep v2.2/sweepv2.2_gerber.zip
```

The cyberdeck-specific placement, wiring, and mechanical carrier design lives here:

```text
hardware/keyboard/fielddeck_sweep_compat/
```

## Build Notes

1. Order the Sweep v2.2 PCB pair from the Gerber ZIP.
2. Populate Choc hotswap or soldered switch footprints according to the Sweep BOM.
3. Socket or solder two Pro Micro RP2040-compatible controllers.
4. Use the left half as USB master.
5. Connect the right half with the keyed JST-SH internal cable.
6. Flash standard Sweep-compatible QMK/ZMK-style firmware adjusted for the selected controller pin names.
7. Install the assembled PCBs into the recessed trays and verify top-of-keycap height is below `22.6 mm` from the lower shell datum.
