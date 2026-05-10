# QMK Pin Plan

This is the firmware-facing pin plan for the FieldDeck Sweep-compatible keyboard.

Use an existing Sweep/Ferris QMK keyboard as the firmware base, then convert the controller target to the selected Pro Micro RP2040 board.

## Direct Pins

The FieldDeck plan keeps the Sweep-style direct-pin circuit: each switch closes one controller GPIO to ground. There are no row/column diodes in this baseline.

```c
// Logical order per half, matching switch_coordinates.csv.
// Replace these labels with the exact QMK pin names for the chosen Pro Micro RP2040 board.
#define DIRECT_PINS { \
  { D2, D3, D4, D5, D6 }, \
  { D7, D8, D9, D10, D14 }, \
  { D15, D16, D18, D19, D20 }, \
  { NO_PIN, NO_PIN, NO_PIN, D21, D22 } \
}
```

## Split Transport

```c
#define SOFT_SERIAL_PIN D1
#define SPLIT_USB_DETECT
#define MASTER_LEFT
```

## Notes

- Confirm pin names against the exact controller package before flashing.
- If using a SparkFun Pro Micro RP2040, use the QMK RP2040 Pro Micro conversion target or equivalent board definition.
- The right half receives power and serial over the internal JST-SH-4 cable.
- Keep reset accessible through the bottom service cover during firmware bring-up.
