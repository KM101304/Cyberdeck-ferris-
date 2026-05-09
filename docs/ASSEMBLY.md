# Ferris FieldDeck 11 Assembly

## Fit Checks First

Print these small parts before the full shell:

1. `tablet_bracket.stl`
2. `lower_hinge_block_left.stl`
3. `keyboard_plate_left.stl`
4. `cable_cover_short.stl`
5. `fit_coupon.stl`

Verify heat-set insert holes, switch cutouts, hinge screw spacing, tablet bracket hook clearance, and tablet pad thickness.

Review `AUDIT.md` before printing large parts. The remaining high-risk dimensions are tablet envelope, hinge screw pattern, and cable service-loop bend behavior.

## Main Assembly

1. Heat-set all M2.5 and M3 inserts.
2. Join `lower_left` and `lower_right` with `lower_center_spine`.
3. Install lower hinge blocks into the rear spine area.
4. Seat the friction hinge leaves into the printed pockets and mount them to the lower hinge blocks.
5. Install the keyboard plates and PCB assemblies into the recessed trays.
6. Route the right keyboard cable through the central cable channel.
7. Install controller hardware behind the left keyboard half.
8. Mount the power bank or protected battery module in the central bay.
9. Route the USB-C tablet power lead to the rear hinge pass-through.
10. Assemble `upper_lid_frame` and `upper_lid_back`.
11. Install upper hinge blocks and attach the lid to the hinges.
12. Place 0.8-1.0 mm soft pads in the tablet recess and on the bracket hook faces.
13. Install the tablet by seating the lower two brackets first, then sliding the upper two `tablet_bracket` retainers until they overlap the tablet edge by 2.0-2.5 mm.
14. Fit cable covers and verify opening and closing motion.
15. Install `bottom_cover`.
16. Add rubber feet.

## Critical Validation

- Lid holds position at 120-125 degrees.
- Hinge barrels rotate coaxially without rubbing the printed reliefs.
- USB-C loop does not pinch when closing.
- Keycaps clear the lid by at least 1.5 mm.
- Tablet cannot lift out when shaken lightly but can be removed by loosening only the four bracket screws.
- Battery can be removed through the bottom cover.
- No hinge block flex is visible during opening.
