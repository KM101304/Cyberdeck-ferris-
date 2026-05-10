# Ferris FieldDeck 11 Design Audit

## Summary

The current prototype is suitable for first-round printed fit testing after one functional correction: the keyboard stack has been lowered so the keycap tops no longer sit above the lower shell rear datum. The remaining risk is concentrated around final purchased hinge screw pattern, physical USB-C cable bend behavior, and exact controller pin mapping during firmware bring-up.

## Functional Audit

| System | Result | Evidence | Required Action |
|---|---|---|---|
| Hinge open angle | Pass for CAD prototype | Lid is modeled around the hinge axis at 122 degrees with printed hard stops at the rear spine. | Match final metal hinge leaf screw pattern before final hinge-block print. |
| Hinge closure | Conditional pass | Added `closed_preview` so the closed envelope can be inspected. Hinge barrels are coaxial in CAD and relief diameter is `hinge_barrel_d + 0.8 mm`. | Print one hinge block pair and hand-cycle with the purchased hinges before printing full shells. |
| Keyboard closed clearance | Fixed | Previous keycap top was about `27.2 mm`, above the `24.8 mm` lower shell height. CAD now sets `keyboard_mount_z = 13.8 mm` and nominal keycap top to `22.6 mm`. | Verify real PCB, socket, switch, and keycap stack is not taller than the CAD stack. |
| Keyboard PCB fit | Pass with selected PCB class | Per-half CAD PCB envelope is now `108 x 86 mm`, tray pocket is `116 x 90 mm`, and plate is `112 x 88 mm`. | Use Sweep v2.2-compatible Choc PCBs or preserve these envelopes in a custom spin. |
| Keyboard electronics | Pass after controller change | XIAO RP2040 was rejected. Pro Micro-footprint USB-C RP2040 controllers match the existing Sweep v2.2 architecture and provide enough GPIO for direct-pin halves. | Use `hardware/keyboard/fielddeck_sweep_compat/` wiring files. |
| Tablet retention | Pass for prototype | Hooked sliding brackets have 14 x 3.2 mm adjustment slots, pad relief, and 2.0-2.5 mm overlap target. | Install 0.8-1.0 mm soft pads and verify no hard plastic contacts glass. |
| Battery/serviceability | Pass for first prototype | Battery bay, rails, strap, bottom access holes, and rear I/O boards are modeled. | Use only a protected USB-C PD module fitting the bay. |

## Fixes Applied

| Area | Audit Finding | Design Response |
|---|---|---|
| Keyboard mounting | Original bosses were too low relative to the recessed tray stack-up. | Bosses now extend to the plate screw plane. |
| Serviceability | The bottom cover needed clear bottom-side screw access. | Bottom access holes were added for cover and battery strap screws. |
| Power module | Battery volume needed visible retention geometry. | Added cradle rails and strap bosses for a slim protected USB-C PD module. |
| Hinge behavior | The hinge area needed explicit over-travel control. | Added printed hinge stop blocks at the rear spine. |
| Cable routing | Cable intent needed to be visible and testable. | Added simulated keyboard interconnect, battery-to-port, and hinge service-loop cable runs. |
| Electronics massing | Internal parts were not represented in the assembly. | Added simulated controller, port boards, keyboard PCBs, Choc switches, tablet, keycaps, and hinge hardware. |
| Website preview | Single STL was hard to inspect. | Split web models into shell, tablet, keycaps, and components with an Internals viewing mode. |
| Tablet fit | Generic 11-inch tablet left too much bezel/dead space. | Locked Samsung Galaxy Tab A9+ and reduced shell to 282 x 176 mm with 11.2 mm lid thickness. |
| Ports | Rear I/O was only conceptual. | Added USB-C keyboard/service, USB-A accessory/service, USB-C PD input, and power switch cutouts. |
| PCB readiness | Keyboard PCB was only simulated. | Vendored upstream Sweep v2.2 KiCad files and Gerber ZIP under `hardware/keyboard/Sweep`. |
| Slimming pass | The first real-parts shell still carried extra dead space in height, hinge spacing, service cover, and bracket layout. | Reduced footprint to 282 x 176 mm, lower shell to 24.8 mm, lid to 11.2 mm, battery bay to 108 x 52 x 13 mm, and moved the keyboard trays forward 2 mm. |
| Hinge realism | Generic hinge blocks did not prove barrel clearance or leaf seating. | Added 8 mm-class hinge barrel reliefs, shallow metal-leaf pockets, M3 screw holes, coaxial visual barrels, and compact hard stops at the rear spine. |
| Tablet retention | The prior clips were simple blocks and did not positively capture the tablet. | Replaced them with hooked sliding brackets with 14 x 3.2 mm adjustment slots, 2.0-2.5 mm edge overlap target, and soft-pad relief. |
| Keyboard closure | The lowered shell made the prior keycap stack too tall. | Lowered the keyboard mounting plane, deepened the tray relief, and added a closed-preview export. |
| Keyboard PCB | XIAO controller choice did not match the direct-pin Sweep v2.2 board. | Switched to Pro Micro-footprint USB-C RP2040 controllers and added FieldDeck-specific PCB/wiring files. |

## Remaining Prototype Checks

1. Confirm the exact USB-C port location on the physical Galaxy Tab A9+ before final cable-channel tuning.
2. Match hinge screw pattern to the purchased friction hinge before printing final hinge blocks; the model assumes an 8.2 mm barrel and 30 mm barrel length.
3. Print `fit_coupon.stl` before shell parts and tune heat-set insert hole diameters if needed.
4. Verify hooked tablet brackets clamp with pad compression but do not press hard plastic directly into the glass or aluminum body.
5. Verify keycap-to-lid closed clearance with real switches, caps, PCB, plate, and gasket stack; target keycap top is `22.6 mm` from lower shell datum.
6. Verify the USB-C service loop does not pinch through ten slow open-close cycles.
7. Confirm Pro Micro RP2040 pin names in firmware before ordering a custom FieldDeck PCB spin.
8. Confirm the protected power module can be removed through the bottom service path.

## Current Recommendation

Proceed with a mechanical fit prototype using PETG for the shell and PETG-CF or nylon for the hinge blocks. Order or build the keyboard from the vendored Sweep v2.2 Gerbers first; commission a cosmetic custom PCB only after the printed tray and closed-clearance checks pass. Do not install raw lithium cells in this revision; use an enclosed protected USB-C PD power module.
