# FieldDeck Sweep-Compatible Keyboard PCB Package

This folder defines the cyberdeck-specific keyboard integration.

Decision: use the open-source Sweep v2.2 Choc PCB geometry as the manufacturable base, because it is generic, easy to find online, already proven by the keyboard community, and already vendored in this repo with a Gerber ZIP.

The FieldDeck-specific changes are enclosure and wiring decisions:

- Pro Micro-footprint USB-C RP2040 controllers instead of XIAO controllers.
- Internal keyed JST-SH split interconnect instead of exposed TRRS.
- Recessed tray and printed switch plate matched to the cyberdeck shell.
- Lowered keyboard mounting plane for clamshell closure clearance.

## Fab-Ready PCB Source

Use the upstream Sweep v2.2 Gerber ZIP:

```text
../Sweep/Sweep v2.2/sweepv2.2_gerber.zip
```

The archive contains a JLCPCB-ready package named `sweepv2.1_216.92x86.863892mm_for_JLCPCB/`.

## FieldDeck Design Files

| File | Purpose |
|---|---|
| `switch_coordinates.csv` | Switch center coordinates used by the CAD and PCB spec |
| `direct_pin_netlist.csv` | One-GPIO-per-key wiring map for each half |
| `interconnect_pinout.csv` | Internal keyed split interconnect pinout |
| `pcb_mechanical_spec.md` | Mechanical envelope, mounting holes, and clearance rules |
| `fielddeck_keyboard_layout.svg` | Human-readable board/layout drawing |

## Controller

Use SparkFun Pro Micro RP2040 or another Pro Micro-footprint USB-C RP2040 controller with equivalent pin availability. SparkFun lists the board as USB-C, Pro Micro footprint, and `1.3 in x 0.7 in`, which is inside the CAD controller envelope.

## Why Not XIAO

The Seeed XIAO RP2040 is attractive and small, but this design uses a direct-pin Sweep-style circuit. Each 17-key half needs 17 switch GPIO plus split communication and reset/programming support. XIAO pushes that into an avoidable I/O compromise. Pro Micro RP2040 keeps the board generic and sourceable.
