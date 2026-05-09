# Ferris FieldDeck 11

A backpack-portable asymmetrical clamshell cyberdeck built around an 11-inch USB-C tablet and a Ferris Sweep-inspired low-profile split keyboard.

This repo contains a parametric OpenSCAD prototype package intended for real 3D printing and mechanical iteration.

## Locked Design

| Feature | Value |
|---|---:|
| Closed footprint | 292 x 188 mm |
| Lower shell height | 31 mm rear structural height |
| Upper lid thickness | 15 mm |
| Opening angle target | 120-125 degrees |
| Tablet envelope | 250 x 178 x 7.5 mm |
| Keyboard | Choc low-profile, Ferris/Sweep-inspired 36 key |
| Shell material | PETG |
| Structural inserts | M2.5 and M3 brass heat-set inserts |
| Hinge style | Dual compact friction hinges |

## Files

```text
scad/fielddeck.scad          Main parametric source
scad/parts/*.scad            One wrapper per printable part
scripts/export_stls.sh       Batch STL export script
exports/stl/                 STL output directory
docs/PRINTING.md             Bambu/PETG print settings
docs/BOM.md                  Hardware, fasteners, and electronics
docs/ASSEMBLY.md             Build sequence and validation checks
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
| `tablet_bracket` | Adjustable tablet retention clip, print 4 |
| `keyboard_plate_left/right` | Choc switch plates |
| `cable_cover_short/long` | Internal cable channel covers |
| `battery_strap` | Retains internal USB-C PD pack/module |
| `fit_coupon` | Insert, screw, slot, and bracket clearance test |

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
- Add 1 mm TPU, EVA, felt, or Poron pads wherever the tablet contacts printed plastic.
- Do not install a raw lithium pack without a protected BMS, fuse, and proper charging board. The intended prototype uses an enclosed slim USB-C PD power bank/module.

## CAD Iteration

The OpenSCAD package is the printable mechanical baseline. For Fusion 360 refinement:

1. Export the part STLs from OpenSCAD.
2. Import into Fusion as reference meshes.
3. Rebuild critical surfaces parametrically if you need production-level CAD.
4. Preserve the dimensions and interface locations from `scad/fielddeck.scad`.

## Current Status

The repo now contains both the parametric OpenSCAD source and generated STL files in `exports/stl/`. The STL export was verified with OpenSCAD CGAL rendering; every exported part reported as a valid simple 3D object.
