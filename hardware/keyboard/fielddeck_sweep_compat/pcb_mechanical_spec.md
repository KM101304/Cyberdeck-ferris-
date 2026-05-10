# FieldDeck Sweep-Compatible PCB Mechanical Spec

## Board Envelope

| Item | Value |
|---|---:|
| Per-half PCB target envelope | 108 x 86 x 1.6 mm |
| Printed tray pocket | 116 x 90 mm |
| Printed switch plate | 112 x 88 x 1.6 mm |
| Controller keepout | 34 x 18.5 x 5.0 mm |
| Mounting screws | M2.5, 4 per half |
| Mounting hole centers | +/-46 x +/-32 mm from each half local origin |

## Vertical Stack

| Stack Item | CAD Z |
|---|---:|
| Lower shell top rear datum | 24.8 mm |
| Keyboard PCB underside | 12.0 mm |
| Keyboard plate underside | 17.0 mm |
| Nominal keycap top | 22.6 mm |
| Closed lid clearance target | 2.0 mm minimum |

The keyboard stack now clears the lower shell rear datum by about `2.2 mm` before soft pads, print tolerance, and lid inner relief are considered.

## Layout

The layout is a Sweep/Ferris-style 17-key half:

- 5 columns x 3 rows
- 2 thumb keys
- 18 mm column pitch
- 17 mm row pitch
- 11 degree half splay in the enclosure

## Fabrication Notes

Use 1.6 mm FR-4, 1 oz copper, ENIG or HASL finish. Order the first boards from the vendored Sweep v2.2 Gerbers before commissioning a cosmetic custom PCB spin.

If a custom FieldDeck PCB spin is made later, preserve:

- Switch centers from `switch_coordinates.csv`
- Mount hole centers from this file
- Per-half envelope under `108 x 86 mm`
- Controller connector toward the rear/service side
- No components taller than the controller USB-C shell inside the keyboard tray
