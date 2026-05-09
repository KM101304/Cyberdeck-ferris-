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
// fit_coupon

// ---------- primary dimensions ----------
deck_w = 292;
deck_d = 188;
lower_h = 31;
front_h_visual = 20;
upper_w = 292;
upper_h = 188;
upper_t = 15;
wall = 3.0;
floor_t = 2.8;
rib_t = 2.0;
rib_h = 9;

tablet_w = 250;
tablet_h = 178;
tablet_t = 7.5;
tablet_clear = 0.8;

keyboard_splay = 12;
keyboard_tent = 4;
key_pitch_x = 18;
key_pitch_y = 17;

hinge_x = 92;
hinge_y = 0;
hinge_block_lower = [36, 24, 18];
hinge_block_upper = [34, 20, 12];
keyboard_boss_h = lower_h - 4.2 - floor_t + 0.4;
battery_bay = [120, 64, 17];

insert_m25_hole = 4.0;
insert_m3_hole = 4.8;
boss_m25_od = 6.6;
boss_m3_od = 8.0;

eps = 0.02;

lower_pts = [
  [-146,0], [146,0], [146,146], [116,174], [32,188],
  [0,176], [-36,188], [-126,176], [-146,150]
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
  sx = side == "left" ? -68 : 68;
  rot = side == "left" ? -keyboard_splay : keyboard_splay;
  translate([sx,94,lower_h-4.2])
    rotate([0,0,rot])
      rounded_box([116,88,5], r=5);
}

module keyboard_clearance_cut(side="left") {
  sx = side == "left" ? -68 : 68;
  rot = side == "left" ? -keyboard_splay : keyboard_splay;
  translate([sx,94,lower_h-9.0])
    rotate([0,0,rot])
      rounded_box([104,76,7], r=4);
}

module lower_port_cuts() {
  // Rear face utility ports.
  translate([-114,-eps,12]) rotate([90,0,0]) rounded_slot(10,4.5,5);
  translate([114,-eps,12]) rotate([90,0,0]) rounded_slot(10,4.5,5);
  translate([128,-eps,20]) rotate([90,0,0]) rounded_slot(12,5,5);
}

module lower_vent_cuts() {
  for (i=[0:7])
    translate([-102 + i*6,-eps,23])
      rotate([90,0,0]) rounded_slot(18,2,5);
  for (i=[0:9])
    translate([52 + i*6,-eps,23])
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
      translate([0,9,lower_h-1])
        rounded_box([260,18,8], r=3);

      // Hinge mounting blocks.
      for (x=[-hinge_x, hinge_x])
        translate([x,12,floor_t-0.2])
          rounded_box(hinge_block_lower, r=3);

      // Printed hard stops keep the lid from rotating past the target opening angle.
      for (x=[-hinge_x, hinge_x])
        translate([x,29,lower_h+1])
          rotate([0,0,0])
            rounded_box([28,7,9], r=2);

      // Keyboard screw bosses, 4 per side.
      for (side=[-1,1]) {
        sx = side < 0 ? -68 : 68;
        rot = side < 0 ? -keyboard_splay : keyboard_splay;
        for (p=[[-46,-32],[46,-32],[-46,32],[46,32]])
          translate([sx,94,0])
            rotate([0,0,rot])
              translate([p[0],p[1],floor_t-0.2])
                heatset_boss(boss_m25_od, insert_m25_hole, keyboard_boss_h);
      }

      // Bottom cover bosses around perimeter and battery bay.
      for (p=[[-126,22],[-52,28],[52,28],[126,22],[-128,142],[-58,166],[58,166],[128,142],[0,152],[0,44]])
        translate([p[0],p[1],floor_t-0.2])
          heatset_boss(boss_m3_od, insert_m3_hole, 8.2);

      // Ribs tying hinge spine and keyboard trays into floor.
      for (x=[-124,-96,-64,-32,32,64,96,124])
        translate([x,31,floor_t-0.2])
          rotate([0,0,90]) rib(len=48, t=rib_t, h=rib_h);

      for (x=[-98,-74,-50,50,74,98])
        translate([x,102,floor_t-0.2])
          rotate([0,0,0]) rib(len=44, t=rib_t, h=7);

      // Honeycomb fields under palm/battery zones.
      translate([-74,145,floor_t-0.2]) honeycomb_patch(5,3,11,1.2,5.2);
      translate([74,145,floor_t-0.2]) honeycomb_patch(5,3,11,1.2,5.2);

      // Battery cradle rails for a slim protected USB-C PD pack/module.
      translate([0,92,floor_t-0.2]) {
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
        translate([x,92,floor_t-0.2])
          heatset_boss(boss_m3_od, insert_m3_hole, 7.2);
    }

    // Hinge screw holes.
    for (x=[-hinge_x, hinge_x])
      for (p=[[-11,-6],[11,-6],[-11,6],[11,6]])
        translate([x+p[0],12+p[1],floor_t+9])
          screw_through(3.4, 20);

    // Bottom service cover screw access holes through the lower floor.
    for (p=[[-126,22],[-52,28],[52,28],[126,22],[-128,142],[-58,166],[58,166],[128,142],[0,152],[0,44]])
      translate([p[0],p[1],0])
        screw_access_from_bottom(3.5);

    // Battery strap screw access.
    for (x=[-54,54])
      translate([x,92,0])
        screw_access_from_bottom(3.5);

    // Cable pass-through from battery/controller bay to hinge spine.
    translate([0,30,floor_t+3])
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
    for (p=[[-126,22],[-52,28],[52,28],[126,22],[-128,142],[-58,166],[58,166],[128,142],[0,152],[0,44]])
      translate([p[0],p[1],-eps]) cylinder(d=3.5, h=4);
    for (i=[0:11])
      translate([42+i*6,118,-eps]) rounded_slot(18,2,4);
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
    translate([136,-58,5]) cube([14,9,7], center=true);

    // Hinge-side cable relief loop.
    translate([0,-91,5]) rounded_slot(22,7,10);
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
        translate([x,-79,2.8]) rounded_box(hinge_block_upper, r=3);
    }
    for (p=[[-132,-82],[-88,-82],[-44,-82],[0,-82],[44,-82],[88,-82],[132,-82],
            [-132,82],[-88,82],[-44,82],[0,82],[44,82],[88,82],[132,82]])
      translate([p[0],p[1],-eps]) cylinder(d=3.0, h=12);
    for (x=[-hinge_x, hinge_x])
      for (p=[[-10,-5],[10,-5],[-10,5],[10,5]])
        translate([x+p[0],-79+p[1],3]) screw_through(3.4, 16);
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
  for (p=[[-116,-70],[116,-70],[-116,70],[116,70]])
    translate([p[0],p[1],upper_t-2])
      color("#d7d1c3") tablet_bracket();
}

// Ferris/Sweep-inspired switch center pattern for Choc cutouts.
left_keys = [
  [-36,20],[-18,15],[0,11],[18,15],[36,20],
  [-36,3], [-18,-2],[0,-6],[18,-2],[36,3],
  [-36,-14],[-18,-19],[0,-23],[18,-19],[36,-14],
  [15,-42],[34,-42],[52,-34]
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
  open_a = 122;
  color("#b9b6ad") lower_part("left");
  color("#b9b6ad") lower_part("right");
  color("#8d8a82") translate([0,0,-4]) lower_center_spine();
  color("#222222") translate([0,0,-5]) bottom_cover();

  color("#343434")
    for (x=[-hinge_x, hinge_x])
      translate([x,0,lower_h+5])
        rotate([90,0,0]) cylinder(d=10,h=30, center=true);

  // Lid rotates around a virtual hinge line at the rear of the lower shell.
  translate([0,2,lower_h+7])
    rotate([open_a,0,0])
      translate([0,94,-7]) {
        color("#b9b6ad") lid_frame();
        color("#777777") translate([0,0,-3.2]) lid_back();
        tablet_visual();
        tablet_brackets_visual();
      }

  translate([-68,94,lower_h-3]) rotate([0,0,-keyboard_splay]) {
    color("#eeeeee") keyboard_plate("left");
    color("#e8dfcc") keycap_set("left");
  }
  translate([68,94,lower_h-3]) rotate([0,0,keyboard_splay]) {
    color("#eeeeee") keyboard_plate("right");
    color("#e8dfcc") keycap_set("right");
  }
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
