# Ferris FieldDeck 11 Parts Lock

This revision locks the mechanical design around real, inexpensive, orderable parts rather than generic placeholders.

## Tablet

**Chosen part:** Samsung Galaxy Tab A9+ Wi-Fi, 64 GB, Graphite, model family SM-X210.

Source: Samsung product/spec pages list the Tab A9+ at 168.7 x 257.1 x 6.9 mm with an 11.0 inch display.

| Parameter | Value |
|---|---:|
| Body | 257.1 x 168.7 x 6.9 mm |
| Display | 11.0 in, 1920 x 1200 |
| USB | USB-C, USB 2.0 |
| Reason | Cheap, common in the US, thin, relatively small bezels for a budget tablet, and stable Samsung supply chain. |

Design clearance in CAD:

| Interface | Value |
|---|---:|
| Tablet recess clearance | +0.7 mm total |
| Soft pad thickness | 0.8-1.0 mm TPU/EVA/felt |
| Bracket overlap | 2.0-2.5 mm nominal |
| Bracket adjustment slot | 14 x 3.2 mm |

## Keyboard PCB

**Chosen board:** Sweep v2.2 low-profile Choc PCB by David Philip Barr, inspired by Ferris.

Source: https://github.com/davidphilipbarr/Sweep

The repo now vendors the upstream hardware source and gerbers:

```text
hardware/keyboard/Sweep/Sweep v2.2/sweepv2.kicad_pcb
hardware/keyboard/Sweep/Sweep v2.2/sweepv2_plate.kicad_pcb
hardware/keyboard/Sweep/Sweep v2.2/sweepv2.2_gerber.zip
```

Use `sweepv2.2_gerber.zip` for PCB ordering. Use the printed shell trays as the mechanical carrier, not the original open keyboard case.

FieldDeck-specific keyboard files:

```text
hardware/keyboard/fielddeck_sweep_compat/
```

This folder defines switch coordinates, direct-pin netlist, internal JST interconnect pinout, and the mechanical PCB envelope used by the shell.

## Controller

**Chosen part:** SparkFun Pro Micro RP2040 or pin-compatible USB-C Pro Micro RP2040 controller.

Source: SparkFun lists the Pro Micro RP2040 with USB-C, Pro Micro footprint, 20 multifunction GPIO pins, and 1.3 x 0.7 in dimensions.

| Parameter | Value |
|---|---:|
| Board envelope used in CAD | 34 x 18.5 x 5.0 mm |
| USB | USB-C |
| Role | Split keyboard controller |

Reason: Pro Micro-footprint controllers match the existing Sweep v2.2 PCB and have enough GPIO for a direct-pin 17-key half. XIAO RP2040 is rejected for this revision because it would require an I/O expander or a matrix redesign.

## USB / Power Boards

| Function | Part | CAD Envelope |
|---|---|---:|
| Keyboard USB-C service | Adafruit USB Type-C Breakout 4090 | 20.4 x 14.2 x 5.0 mm |
| PD input selector | Adafruit HUSB238 USB-C PD Switchable Breakout 5991 | 29.1 x 20.3 x 10.1 mm |
| USB-A accessory/service | Generic USB-A panel/breakout board | 24 x 18 x 6 mm |

Sources:

- Adafruit 4090: https://www.adafruit.com/product/4090
- Adafruit 5991: https://www.adafruit.com/product/5991

## Exterior Ports

Rear edge, left-to-right:

1. USB-C keyboard/service
2. USB-A accessory/service
3. USB-C PD input/charge
4. small power switch

## Hinge

**Chosen class:** two compact laptop-style friction hinges.

Minimum spec:

| Parameter | Value |
|---|---:|
| Torque | 0.25-0.45 N-m each |
| Barrel diameter | 9-10 mm |
| Barrel length | 28-35 mm |
| Screws | M3 |

CAD baseline:

| Interface | Value |
|---|---:|
| Hinge X centers | +/-88 mm |
| Modeled barrel | 8.2 mm diameter x 30 mm long |
| Barrel relief | +0.8 mm clearance |
| Lower block | 34 x 20 x 14 mm |
| Upper block | 32 x 17 x 9 mm |
| Opening hard stop | 122 degrees nominal |

The printed hinge blocks are intentionally still parametric because cheap replacement laptop hinges vary. Match the final screw pattern to the hinge you buy before printing the final lid and hinge blocks.
