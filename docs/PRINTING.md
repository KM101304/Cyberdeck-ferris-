# Ferris FieldDeck 11 Printing Guide

## Materials

Use PETG for the main shell and PETG-CF or nylon for hinge blocks if available.

Recommended baseline:

| Part | Material | Notes |
|---|---|---|
| Lower shell left/right | PETG | Warm grey, matte preferred |
| Lower center spine | PETG or PETG-CF | Structural joiner |
| Upper lid frame | PETG | Use dry filament |
| Upper lid back | PETG | Outer face down |
| Hinge blocks | PETG-CF or nylon | Stronger and stiffer |
| Keyboard plates | PETG-CF or 1.5 mm aluminum | PETG works for prototype |
| Tablet brackets | PETG with TPU/EVA/Poron pads | Print flat; tune hook overlap on fit test |
| Cable covers / strap | PETG | Small utility parts |

## Bambu Lab Slicer Settings

| Setting | Value |
|---|---:|
| Nozzle | 0.4 mm or 0.6 mm |
| Layer height | 0.20 mm |
| Wall loops | 4 |
| Top layers | 5 |
| Bottom layers | 5 |
| Infill | 25% gyroid |
| Sparse infill for hinge blocks | 40% gyroid/cubic |
| Seam | Rear or aligned |
| Supports | Tree/manual supports only where needed |
| PETG nozzle | 245-255 C |
| PETG bed | 75-85 C |
| Brim | Recommended on lower shell halves and lid frame |

## Orientation

| STL | Orientation |
|---|---|
| lower_left.stl | Top face up, rear hinge spine on bed side is acceptable with supports |
| lower_right.stl | Top face up |
| lower_center_spine.stl | Flat face down |
| bottom_cover.stl | Outer face down |
| upper_lid_frame.stl | Screen side up |
| upper_lid_back.stl | Outer face down |
| hinge blocks | Broad screw face down; keep barrel relief horizontal and use local supports if needed |
| keyboard plates | Flat |
| tablet brackets | Flat with hook up; use a small brim if PETG corners lift |

## Post Processing

1. Deburr every screw hole with a 90 degree countersink by hand.
2. Heat-set inserts with a temperature controlled iron.
3. Test M2.5 and M3 screws before final assembly.
4. Add 0.8-1.0 mm TPU, EVA, felt, or Poron pads wherever printed plastic touches the tablet.
5. Dry fit hinge barrels in the printed reliefs and cycle the lid slowly before electronics are installed.

## Export

Run:

```bash
scripts/export_stls.sh
```

This environment may not have OpenSCAD installed. On a workstation with OpenSCAD, the script exports every printable STL to `exports/stl`.
