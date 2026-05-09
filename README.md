# Ferris FieldDeck 11

A backpack-portable asymmetrical clamshell cyberdeck built around an 11-inch USB-C tablet and a Ferris Sweep-inspired low-profile split keyboard.

This repo contains a parametric OpenSCAD prototype package intended for real 3D printing and mechanical iteration.

## Locked Design

| Feature | Value |
|---|---:|
| Closed footprint | 282 x 176 mm |
| Lower shell height | 24.8 mm rear structural height |
| Upper lid thickness | 11.2 mm |
| Opening angle target | 122 degrees nominal, 120-125 degree working range |
| Tablet envelope | Samsung Galaxy Tab A9+, 257.1 x 168.7 x 6.9 mm |
| Keyboard | Sweep v2.2 Choc low-profile 34 key |
| Shell material | PETG |
| Structural inserts | M2.5 and M3 brass heat-set inserts |
| Hinge style | Dual compact friction hinges |

## Files

```text
scad/fielddeck.scad          Main parametric source
scad/parts/*.scad            One wrapper per printable part
scripts/export_stls.sh       Batch STL export script
scripts/export_web_models.sh Batch website model export script
exports/stl/                 STL output directory
docs/PRINTING.md             Bambu/PETG print settings
docs/BOM.md                  Hardware, fasteners, and electronics
docs/ASSEMBLY.md             Build sequence and validation checks
docs/AUDIT.md                Engineering audit and remaining prototype checks
docs/PARTS_LOCK.md           Real selected parts and mechanical envelopes
hardware/keyboard/Sweep/     Vendored Sweep v2.2 PCB source and gerbers
```

## Printable Parts

| Part | Purpose |
|---|---|
| `lower_left` | Left lower shell with left keyboard tray |
| `lower_right` | Right lower shell with right keyboard tray |
| `lower_center_spine` | Mechanical joiner, hinge spine reinforcement, central seam cover |
| `bottom_cover` | Removable service panel |
| `upper_lid_frame` | Tablet retention frame |
| `upper_lid_back` | Ribbed lid back panel |
| `lower_hinge_block_left/right` | Lower hinge mounts |
| `upper_hinge_block_left/right` | Upper hinge mounts |
| `tablet_bracket` | Hooked sliding tablet retention bracket, print 4 |
| `keyboard_plate_left/right` | Choc switch plates |
| `cable_cover_short/long` | Internal cable channel covers |
| `battery_strap` | Retains internal USB-C PD pack/module |
| `fit_coupon` | Insert, screw, slot, and bracket clearance test |

## Simulated Components

The assembly preview and web viewer include simulated internal components:

- 11-inch tablet massing
- split keyboard PCBs
- Kailh Choc switch bodies
- keycaps
- controller board
- USB-C port boards
- protected battery module
- hinge hardware
- keyboard, battery, and hinge-loop cable runs

The GitHub Pages viewer has an `Internals` mode that makes the shell transparent so those simulated components can be inspected.

## Real Parts Locked

This revision is built around a Samsung Galaxy Tab A9+ Wi-Fi tablet and a Sweep v2.2 Choc PCB. See [docs/PARTS_LOCK.md](docs/PARTS_LOCK.md) for selected parts, dimensions, and source links.

## Export STLs

Install OpenSCAD, then run:

```bash
scripts/export_stls.sh
```

The generated files will be placed in:

```text
exports/stl/
```

You can also open any file in `scad/parts/` directly in OpenSCAD and export that individual part.

## Preview The Design

Rendered previews are generated from the same OpenSCAD assembly source as the printable parts.

The GitHub Pages site lives in `docs/` and includes an interactive Three.js STL viewer:

```text
https://km101304.github.io/Cyberdeck-ferris-/
```

```bash
scripts/render_previews.sh
```

Open these files:

| View | File |
|---|---|
| Keyboard/open isometric | [exports/preview/fielddeck_keyboard_iso.png](exports/preview/fielddeck_keyboard_iso.png) |
| Keyboard/top layout | [exports/preview/fielddeck_keyboard_top.png](exports/preview/fielddeck_keyboard_top.png) |
| Display/rear isometric | [exports/preview/fielddeck_open_iso.png](exports/preview/fielddeck_open_iso.png) |
| Display/rear front | [exports/preview/fielddeck_open_front.png](exports/preview/fielddeck_open_front.png) |
| Side profile | [exports/preview/fielddeck_open_side.png](exports/preview/fielddeck_open_side.png) |

## Print First

Before committing to the large shell pieces, print these validation parts:

1. `tablet_bracket`
2. `lower_hinge_block_left`
3. `keyboard_plate_left`
4. `cable_cover_short`
5. `fit_coupon`

Confirm insert fit, hinge hardware spacing, Choc switch fit, and cable clearance.

## Manufacturing Notes

- Use PETG for the main structure.
- Use PETG-CF or nylon for hinge blocks when possible.
- Use 4 wall loops and 25% gyroid infill for shell parts.
- Use 40% infill and 5 wall loops for hinge blocks.
- Add 0.8-1.0 mm TPU, EVA, felt, or Poron pads wherever the tablet contacts printed plastic.
- Tune the tablet bracket slots so the hooks overlap the glass/edge by 2.0-2.5 mm after pads are installed.
- Do not install a raw lithium pack without a protected BMS, fuse, and proper charging board. The intended prototype uses an enclosed slim USB-C PD power bank/module.

## CAD Iteration

The OpenSCAD package is the printable mechanical baseline. For Fusion 360 refinement:

1. Export the part STLs from OpenSCAD.
2. Import into Fusion as reference meshes.
3. Rebuild critical surfaces parametrically if you need production-level CAD.
4. Preserve the dimensions and interface locations from `scad/fielddeck.scad`.

## Current Status

The repo now contains both the parametric OpenSCAD source and generated STL files in `exports/stl/`. The STL export was verified with OpenSCAD CGAL rendering; every exported part reported as a valid simple 3D object. See [docs/AUDIT.md](docs/AUDIT.md) for the latest engineering audit.
