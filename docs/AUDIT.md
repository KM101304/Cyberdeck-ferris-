# Ferris FieldDeck 11 Design Audit

## Summary

The current prototype is suitable for first-round printed fit testing, with the remaining risk concentrated around real hinge hardware selection, real tablet dimensions, and physical cable bend behavior.

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

## Remaining Prototype Checks

1. Confirm the exact 11-inch tablet envelope and USB-C port location.
2. Match hinge screw pattern to the purchased friction hinge before printing final hinge blocks.
3. Print `fit_coupon.stl` before shell parts and tune heat-set insert hole diameters if needed.
4. Verify keycap-to-lid closed clearance with real switches, caps, PCB, plate, and gasket stack.
5. Verify the USB-C service loop does not pinch through ten slow open-close cycles.
6. Confirm the protected power module can be removed through the bottom service path.

## Current Recommendation

Proceed with a mechanical fit prototype using PETG for the shell and PETG-CF or nylon for the hinge blocks. Do not install raw lithium cells in this revision; use an enclosed protected USB-C PD power module.
