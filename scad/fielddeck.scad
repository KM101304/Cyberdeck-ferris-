// Ferris FieldDeck 11
// Parametric printable source for an asymmetrical tablet cyberdeck.
// Units: millimeters.  Export one part at a time by setting PART.

$fn = 48;

// ---------- part selector ----------
selected_part = is_undef(PART) ? "assembly_preview" : PART;
// Valid PART values:
// assembly_preview, lower_left, lower_right, lower_center_spine, bottom_cover,
// upper_lid_frame, upper_lid_back, lower_hinge_block_left, lower_hinge_block_right,
// upper_hinge_block_left, upper_hinge_block_right, tablet_bracket, keyboard_plate_left,
// keyboard_plate_right, cable_cover_short, cable_cover_long, battery_strap,
// fit_coupon, web_shell, web_tablet, web_keycaps, web_components

// ---------- primary dimensions ----------
deck_w = 286;
deck_d = 178;
lower_h = 27;
front_h_visual = 17;
upper_w = 286;
upper_h = 178;
upper_t = 12.5;
wall = 3.0;
floor_t = 2.8;
rib_t = 2.0;
rib_h = 9;

// Locked tablet: Samsung Galaxy Tab A9+ Wi-Fi, SM-X210.
tablet_w = 257.1;
tablet_h = 168.7;
tablet_t = 6.9;
tablet_clear = 0.7;

keyboard_splay = 11;
keyboard_tent = 4;
key_pitch_x = 18;
key_pitch_y = 17;

hinge_x = 92;
hinge_y = 0;
hinge_block_lower = [34, 22, 16];
hinge_block_upper = [32, 18, 10];
keyboard_boss_h = lower_h - 4.2 - floor_t + 0.4;
battery_bay = [116, 58, 15];
controller_bay = [22, 18, 4.5];
usb_c_breakout = [20.4, 14.2, 5.0];
pd_breakout = [29.1, 20.3, 10.1];
usb_a_board = [24, 18, 6];
pcb_t = 1.6;
plate_t = 1.6;

insert_m25_hole = 4.0;
insert_m3_hole = 4.8;
boss_m25_od = 6.6;
boss_m3_od = 8.0;

eps = 0.02;

lower_pts = [
  [-143,0], [143,0], [143,138], [116,164], [34,178],
  [0,168], [-38,178], [-116,164], [-143,140]
];

// ---------- utility geometry ----------
module rpoly(points, r=6) {
  offset(r=r) offset(delta=-r) polygon(points);
}

module rounded_rect_2d(size=[10,10], r=2) {
  x = size[0]; y = size[1];
  offset(r=r) offset(delta=-r)
    square([x,y], center=true);
}

module rounded_box(size=[10,10,10], r=2) {
  linear_extrude(height=size[2])
    rounded_rect_2d([size[0], size[1]], r);
}

module rounded_slot(len=20, w=2, h=3) {
  hull() {
    translate([-len/2+w/2,0,0]) cylinder(d=w, h=h);
    translate([ len/2-w/2,0,0]) cylinder(d=w, h=h);
  }
}

module heatset_boss(od=8, hole=4.8, h=7) {
  difference() {
    cylinder(d=od, h=h);
    translate([0,0,-eps]) cylinder(d=hole, h=h+2*eps);
  }
}

module screw_through(d=3.4, h=20) {
  translate([0,0,-eps]) cylinder(d=d, h=h+2*eps);
}

module screw_access_from_bottom(d=3.5) {
  translate([0,0,-eps]) cylinder(d=d, h=floor_t+1.0);
}

module rib(len=40, t=2, h=8) {
  translate([-len/2,-t/2,0]) cube([len,t,h]);
}

module cable_run(points, w=4, h=3) {
  for (i=[0:len(points)-2]) {
    p0 = points[i];
    p1 = points[i+1];
    dx = p1[0] - p0[0];
    dy = p1[1] - p0[1];
    len_xy = sqrt(dx*dx + dy*dy);
    ang = atan2(dy, dx);
    translate([(p0[0]+p1[0])/2, (p0[1]+p1[1])/2, (p0[2]+p1[2])/2])
      rotate([0,0,ang])
        rounded_box([len_xy, w, h], r=w/2);
  }
}

module honeycomb_patch(cols=6, rows=4, cell=11, wall=1.2, h=5) {
  // Structural-looking lightening lattice for broad flat panels.
  for (ix=[0:cols-1])
    for (iy=[0:rows-1]) {
      x = (ix-(cols-1)/2) * cell * 0.88;
      y = (iy-(rows-1)/2) * cell + (ix%2)*cell/2;
      translate([x,y,0])
        difference() {
          cylinder(d=cell, h=h, $fn=6);
          translate([0,0,-eps]) cylinder(d=cell-wall*2, h=h+2*eps, $fn=6);
        }
    }
}

module lower_outer() {
  // Printable tub body.  The underside is hollowed separately.
  linear_extrude(height=lower_h)
    rpoly(lower_pts, r=7);
}

module lower_inner_void() {
  translate([0,0,floor_t])
    linear_extrude(height=lower_h-floor_t-4.2)
      offset(delta=-wall)
        rpoly(lower_pts, r=7);
}

module keyboard_pocket(side="left") {
  sx = side == "left" ? -66 : 66;
  rot = side == "left" ? -keyboard_splay : keyboard_splay;
  translate([sx,86,lower_h-4.2])
    rotate([0,0,rot])
      rounded_box([110,82,5], r=5);
}

module keyboard_clearance_cut(side="left") {
  sx = side == "left" ? -66 : 66;
  rot = side == "left" ? -keyboard_splay : keyboard_splay;
  translate([sx,86,lower_h-9.0])
    rotate([0,0,rot])
      rounded_box([100,72,7], r=4);
}

module lower_port_cuts() {
  // Rear face utility ports.
  translate([-106,-eps,11]) rotate([90,0,0]) rounded_slot(10,4.5,5); // keyboard USB-C
  translate([106,-eps,11]) rotate([90,0,0]) rounded_slot(10,4.5,5);  // PD/charge USB-C
  translate([0,-eps,11.5]) rotate([90,0,0]) rounded_slot(15,7,5);    // USB-A accessory
  translate([130,-eps,19]) rotate([90,0,0]) rounded_slot(12,5,5);    // power switch
}

module lower_vent_cuts() {
  for (i=[0:7])
    translate([-102 + i*6,-eps,21])
      rotate([90,0,0]) rounded_slot(18,2,5);
  for (i=[0:9])
    translate([52 + i*6,-eps,21])
      rotate([90,0,0]) rounded_slot(22,2,5);
}

module lower_shell_unsplit() {
  difference() {
    union() {
      difference() {
        lower_outer();
        lower_inner_void();
        keyboard_pocket("left");
        keyboard_pocket("right");
        keyboard_clearance_cut("left");
        keyboard_clearance_cut("right");
        lower_port_cuts();
        lower_vent_cuts();
      }

      // Rear hinge spine, proud and reinforced.
      translate([0,8,lower_h-1])
        rounded_box([252,16,7], r=3);

      // Hinge mounting blocks.
      for (x=[-hinge_x, hinge_x])
        translate([x,11,floor_t-0.2])
          rounded_box(hinge_block_lower, r=3);

      // Printed hard stops keep the lid from rotating past the target opening angle.
      for (x=[-hinge_x, hinge_x])
        translate([x,26,lower_h+1])
          rotate([0,0,0])
            rounded_box([28,7,9], r=2);

      // Keyboard screw bosses, 4 per side.
      for (side=[-1,1]) {
        sx = side < 0 ? -66 : 66;
        rot = side < 0 ? -keyboard_splay : keyboard_splay;
        for (p=[[-46,-32],[46,-32],[-46,32],[46,32]])
          translate([sx,86,0])
            rotate([0,0,rot])
              translate([p[0],p[1],floor_t-0.2])
                heatset_boss(boss_m25_od, insert_m25_hole, keyboard_boss_h);
      }

      // Bottom cover bosses around perimeter and battery bay.
      for (p=[[-123,22],[-52,28],[52,28],[123,22],[-124,136],[-58,156],[58,156],[124,136],[0,146],[0,42]])
        translate([p[0],p[1],floor_t-0.2])
          heatset_boss(boss_m3_od, insert_m3_hole, 8.2);

      // Ribs tying hinge spine and keyboard trays into floor.
      for (x=[-124,-96,-64,-32,32,64,96,124])
        translate([x,29,floor_t-0.2])
          rotate([0,0,90]) rib(len=44, t=rib_t, h=rib_h);

      for (x=[-98,-74,-50,50,74,98])
        translate([x,94,floor_t-0.2])
          rotate([0,0,0]) rib(len=40, t=rib_t, h=7);

      // Honeycomb fields under palm/battery zones.
      translate([-70,136,floor_t-0.2]) honeycomb_patch(5,3,11,1.2,5.2);
      translate([70,136,floor_t-0.2]) honeycomb_patch(5,3,11,1.2,5.2);

      // Battery cradle rails for a slim protected USB-C PD pack/module.
      translate([0,84,floor_t-0.2]) {
        translate([-battery_bay[0]/2,-battery_bay[1]/2,0])
          cube([battery_bay[0],3,6]);
        translate([-battery_bay[0]/2,battery_bay[1]/2-3,0])
          cube([battery_bay[0],3,6]);
        translate([-battery_bay[0]/2,-battery_bay[1]/2,0])
          cube([3,battery_bay[1],6]);
        translate([battery_bay[0]/2-3,-battery_bay[1]/2,0])
          cube([3,battery_bay[1],6]);
      }

      // Snap/strap bosses over the battery bay.
      for (x=[-54,54])
        translate([x,84,floor_t-0.2])
          heatset_boss(boss_m3_od, insert_m3_hole, 7.2);

      // Real I/O board mounting envelopes tied to rear port cutouts.
      translate([-106,13,floor_t+5]) rounded_box(usb_c_breakout, r=1.5);
      translate([106,16,floor_t+6]) rounded_box(pd_breakout, r=1.5);
      translate([0,14,floor_t+5.5]) rounded_box(usb_a_board, r=1.5);
    }

    // Hinge screw holes.
    for (x=[-hinge_x, hinge_x])
      for (p=[[-11,-6],[11,-6],[-11,6],[11,6]])
        translate([x+p[0],11+p[1],floor_t+8])
          screw_through(3.4, 20);

    // Bottom service cover screw access holes through the lower floor.
    for (p=[[-123,22],[-52,28],[52,28],[123,22],[-124,136],[-58,156],[58,156],[124,136],[0,146],[0,42]])
      translate([p[0],p[1],0])
        screw_access_from_bottom(3.5);

    // Battery strap screw access.
    for (x=[-54,54])
      translate([x,84,0])
        screw_access_from_bottom(3.5);

    // Cable pass-through from battery/controller bay to hinge spine.
    translate([0,28,floor_t+3])
      rounded_box([22,8,8], r=2);
  }
}

module lower_part(side="left") {
  if (side == "left") {
    intersection() {
      lower_shell_unsplit();
      translate([-200,-20,-5]) cube([204,240,60]);
    }
  } else {
    intersection() {
      lower_shell_unsplit();
      translate([-4,-20,-5]) cube([204,240,60]);
    }
  }
}

module lower_center_spine() {
  difference() {
    union() {
      translate([0,88,0]) rounded_box([24,150,6], r=3);
      translate([0,16,0]) rounded_box([238,18,8], r=3);
      for (y=[38,72,106,140,170])
        translate([0,y,0]) rounded_box([34,8,6], r=2);
    }
    for (p=[[0,44],[0,76],[0,108],[0,140],[-112,16],[-56,16],[56,16],[112,16]])
      translate([p[0],p[1],-eps]) cylinder(d=3.4, h=12);
  }
}

module bottom_cover() {
  difference() {
    linear_extrude(height=2.8)
      offset(delta=-6) rpoly(lower_pts, r=7);
    for (p=[[-123,22],[-52,28],[52,28],[123,22],[-124,136],[-58,156],[58,156],[124,136],[0,146],[0,42]])
      translate([p[0],p[1],-eps]) cylinder(d=3.5, h=4);
    for (i=[0:11])
      translate([42+i*6,110,-eps]) rounded_slot(18,2,4);
  }
}

module lid_frame() {
  difference() {
    rounded_box([upper_w, upper_h, upper_t], r=9);
    // tablet recess, front opening.
    translate([0,0,upper_t-9])
      rounded_box([tablet_w+tablet_clear, tablet_h+tablet_clear, 10], r=8);
    translate([0,0,upper_t-3])
      rounded_box([tablet_w-8, tablet_h-8, 5], r=6);

    // Lighten backside center.
    translate([0,0,-eps])
      rounded_box([tablet_w-18, tablet_h-18, 6], r=7);

    // Bracket slide slots.
    for (p=[[-116,-70],[116,-70],[-116,70],[116,70]])
      translate([p[0],p[1],upper_t-5])
        rounded_slot(14,3,7);

    // USB-C cable exit near right lower edge.
    translate([132,-54,5]) cube([14,9,7], center=true);

    // Hinge-side cable relief loop.
    translate([0,-86,5]) rounded_slot(22,7,10);
  }
}

module lid_back() {
  difference() {
    union() {
      rounded_box([upper_w-8, upper_h-8, 3.0], r=8);
      translate([0,0,2.8]) honeycomb_patch(16,9,11,1.2,5.2);
      for (x=[-120,-80,-40,0,40,80,120])
        translate([x,0,2.8]) rotate([0,0,90]) rib(len=154,t=1.8,h=5.2);
      for (x=[-hinge_x, hinge_x])
      translate([x,-74,2.8]) rounded_box(hinge_block_upper, r=3);
    }
    for (p=[[-132,-82],[-88,-82],[-44,-82],[0,-82],[44,-82],[88,-82],[132,-82],
            [-132,82],[-88,82],[-44,82],[0,82],[44,82],[88,82],[132,82]])
      translate([p[0],p[1],-eps]) cylinder(d=3.0, h=12);
    for (x=[-hinge_x, hinge_x])
      for (p=[[-10,-5],[10,-5],[-10,5],[10,5]])
        translate([x+p[0],-74+p[1],3]) screw_through(3.4, 16);
  }
}

module hinge_block(lower=true, side="left") {
  sx = side == "left" ? -hinge_x : hinge_x;
  sz = lower ? hinge_block_lower[2] : hinge_block_upper[2];
  sy = lower ? 24 : 20;
  sxw = lower ? 36 : 34;
  difference() {
    rounded_box([sxw, sy, sz], r=3);
    // hinge leaf screw holes
    for (p=[[-10,-5],[10,-5],[-10,5],[10,5]])
      translate([p[0],p[1],sz/2]) screw_through(3.4, sz+2);
    // barrel clearance.
    translate([0,-sy/2-1,sz-5])
      rotate([90,0,0]) cylinder(d=7, h=8);
  }
}

module tablet_bracket() {
  difference() {
    union() {
      rounded_box([22,13,4], r=2);
      translate([0,-4,4]) rounded_box([22,5,3], r=1);
    }
    translate([0,1,-eps]) rounded_slot(12,3,8);
  }
}

module tablet_brackets_visual() {
  for (p=[[-124,-66],[124,-66],[-124,66],[124,66]])
    translate([p[0],p[1],upper_t-2])
      color("#d7d1c3") tablet_bracket();
}

// Ferris/Sweep-inspired switch center pattern for Choc cutouts.
left_keys = [
  [-36,20],[-18,15],[0,11],[18,15],[36,20],
  [-36,3], [-18,-2],[0,-6],[18,-2],[36,3],
  [-36,-14],[-18,-19],[0,-23],[18,-19],[36,-14],
  [18,-42],[39,-36]
];

module keyboard_plate(side="left") {
  rot = side == "left" ? -keyboard_splay : keyboard_splay;
  mirror_side = side == "left" ? 1 : -1;
  difference() {
    rounded_box([112,84,1.6], r=5);
    for (k=left_keys)
      translate([k[0]*mirror_side,k[1],-eps])
        rounded_box([14.2,14.2,2.2], r=1.0);
    for (p=[[-46,-32],[46,-32],[-46,32],[46,32]])
      translate([p[0],p[1],-eps]) cylinder(d=2.8,h=3);
  }
}

module keyboard_pcb(side="left") {
  mirror_side = side == "left" ? 1 : -1;
  difference() {
    rounded_box([104,76,pcb_t], r=4);
    for (k=left_keys)
      translate([k[0]*mirror_side,k[1],-eps])
        rounded_box([13.8,13.8,pcb_t+0.2], r=1.0);
  }
}

module choc_switches(side="left") {
  mirror_side = side == "left" ? 1 : -1;
  for (k=left_keys)
    translate([k[0]*mirror_side,k[1],plate_t])
      rounded_box([14.1,14.1,3.2], r=0.8);
}

module keycap_set(side="left") {
  mirror_side = side == "left" ? 1 : -1;
  for (k=left_keys)
    translate([k[0]*mirror_side,k[1],1.6])
      rounded_box([15.2,14.6,4.0], r=1.6);
}

module tablet_visual() {
  color("#111418")
    translate([0,0,upper_t-8.8])
      rounded_box([tablet_w, tablet_h, tablet_t], r=8);
  color("#1e252c")
    translate([0,0,upper_t-0.7])
      rounded_box([tablet_w-12, tablet_h-12, 0.8], r=6);
}

module simulated_battery() {
  color("#333739")
    translate([0,84,floor_t+6.3])
      rounded_box([108,52,11], r=4);
  color("#252729")
    translate([0,84,floor_t+12.1])
      rounded_box([100,44,1.2], r=3);
}

module simulated_controller() {
  color("#1f4d3a")
    translate([-104,52,floor_t+8])
      rounded_box(controller_bay, r=2);
  color("#101112")
    translate([-104,42,floor_t+10])
      rounded_box([12,5,3], r=1);
  color("#d3c49b")
    for (x=[-119,-112,-96,-89])
      translate([x,57,floor_t+11])
        rounded_box([4,4,1.5], r=0.5);
}

module simulated_port_boards() {
  color("#1f4d3a") {
    translate([-106,10,12]) rounded_box(usb_c_breakout, r=1);
    translate([106,13,12]) rounded_box(pd_breakout, r=1);
    translate([0,11,12]) rounded_box(usb_a_board, r=1);
  }
  color("#b8b8aa") {
    translate([-106,1.8,13.6]) rounded_box([9,5,3], r=1);
    translate([106,1.8,13.6]) rounded_box([9,5,3], r=1);
    translate([0,1.5,13.2]) rounded_box([14,7,5], r=1);
  }
}

module simulated_cabling() {
  color("#101112") {
    cable_run([[-104,52,floor_t+13],[-64,60,floor_t+13],[-28,84,floor_t+13],[28,84,floor_t+13],[64,60,floor_t+13]], w=3.5, h=3);
    cable_run([[36,84,floor_t+14],[70,64,floor_t+14],[100,32,floor_t+14],[106,10,floor_t+14]], w=4, h=3.2);
    cable_run([[0,62,floor_t+14],[0,34,floor_t+15],[0,10,lower_h+1],[0,-12,lower_h+6]], w=4.5, h=3.5);
  }
}

module hinge_hardware_visual() {
  color("#111111")
    for (x=[-hinge_x, hinge_x])
      translate([x,0,lower_h+5])
        rotate([90,0,0]) cylinder(d=9,h=28, center=true);
  color("#2d2d2b")
    for (x=[-hinge_x, hinge_x]) {
      translate([x,12,lower_h+2]) rounded_box([30,7,3], r=1);
      translate([x,-16,lower_h+2]) rounded_box([30,7,3], r=1);
    }
}

module keyboard_visual(side="left", include_keycaps=true) {
  sx = side == "left" ? -66 : 66;
  rot = side == "left" ? -keyboard_splay : keyboard_splay;
  translate([sx,86,lower_h-6.4])
    rotate([0,0,rot]) {
      color("#1f4d3a") translate([0,0,-1.8]) keyboard_pcb(side);
      color("#2a2a28") choc_switches(side);
      color("#eeeeee") translate([0,0,3.2]) keyboard_plate(side);
      if (include_keycaps)
        color("#e8dfcc") translate([0,0,3.2]) keycap_set(side);
    }
}

module shell_visual() {
  color("#b9b6ad") lower_part("left");
  color("#b9b6ad") lower_part("right");
  color("#8d8a82") translate([0,0,-4]) lower_center_spine();
  color("#222222") translate([0,0,-5]) bottom_cover();

  translate([0,2,lower_h+6])
    rotate([122,0,0])
      translate([0,89,-7]) {
        color("#b9b6ad") lid_frame();
        color("#777777") translate([0,0,-3.2]) lid_back();
      }
}

module tablet_assembly_visual() {
  translate([0,2,lower_h+6])
    rotate([122,0,0])
      translate([0,89,-7]) {
        tablet_visual();
        tablet_brackets_visual();
      }
}

module keycaps_assembly_visual() {
  keyboard_visual("left", true);
  keyboard_visual("right", true);
}

module components_visual() {
  hinge_hardware_visual();
  simulated_battery();
  simulated_controller();
  simulated_port_boards();
  simulated_cabling();
  keyboard_visual("left", false);
  keyboard_visual("right", false);
}

module cable_cover(len=60) {
  difference() {
    rounded_box([len,10,3], r=2);
    for (x=[-len/2+8, len/2-8])
      translate([x,0,-eps]) cylinder(d=2.8,h=4);
  }
}

module battery_strap() {
  difference() {
    rounded_box([124,14,3], r=2);
    for (x=[-54,54])
      translate([x,0,-eps]) cylinder(d=3.5,h=4);
  }
}

module fit_coupon() {
  difference() {
    union() {
      rounded_box([68,32,7], r=3);
      translate([-22,0,0]) heatset_boss(boss_m25_od, insert_m25_hole, 8);
      translate([0,0,0]) heatset_boss(boss_m3_od, insert_m3_hole, 8);
      translate([24,0,0]) rounded_box([22,13,4], r=2);
    }
    translate([24,1,-eps]) rounded_slot(12,3,8);
    translate([-22,0,-eps]) cylinder(d=2.9, h=10);
    translate([0,0,-eps]) cylinder(d=3.5, h=10);
  }
}

module assembly_preview() {
  shell_visual();
  components_visual();
  tablet_assembly_visual();
  keycaps_assembly_visual();
}

if (selected_part == "assembly_preview") assembly_preview();
else if (selected_part == "lower_left") lower_part("left");
else if (selected_part == "lower_right") lower_part("right");
else if (selected_part == "lower_center_spine") lower_center_spine();
else if (selected_part == "bottom_cover") bottom_cover();
else if (selected_part == "upper_lid_frame") lid_frame();
else if (selected_part == "upper_lid_back") lid_back();
else if (selected_part == "lower_hinge_block_left") hinge_block(true, "left");
else if (selected_part == "lower_hinge_block_right") hinge_block(true, "right");
else if (selected_part == "upper_hinge_block_left") hinge_block(false, "left");
else if (selected_part == "upper_hinge_block_right") hinge_block(false, "right");
else if (selected_part == "tablet_bracket") tablet_bracket();
else if (selected_part == "keyboard_plate_left") keyboard_plate("left");
else if (selected_part == "keyboard_plate_right") keyboard_plate("right");
else if (selected_part == "cable_cover_short") cable_cover(45);
else if (selected_part == "cable_cover_long") cable_cover(84);
else if (selected_part == "battery_strap") battery_strap();
else if (selected_part == "fit_coupon") fit_coupon();
else if (selected_part == "web_shell") shell_visual();
else if (selected_part == "web_tablet") tablet_assembly_visual();
else if (selected_part == "web_keycaps") keycaps_assembly_visual();
else if (selected_part == "web_components") components_visual();
