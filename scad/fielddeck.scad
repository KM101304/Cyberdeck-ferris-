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
deck_w = 282;
deck_d = 176;
lower_h = 24.8;
front_h_visual = 15;
upper_w = 282;
upper_h = 176;
upper_t = 11.2;
wall = 3.0;
floor_t = 2.6;
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

hinge_x = 88;
hinge_axis_z = lower_h + 3.8;
hinge_axis_y = 0;
hinge_barrel_d = 8.2;
hinge_barrel_len = 30;
hinge_block_lower = [34, 20, 14];
hinge_block_upper = [32, 17, 9];
keyboard_boss_h = lower_h - 4.2 - floor_t + 0.4;
battery_bay = [108, 52, 13];
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
  [-141,0], [141,0], [141,136], [114,162], [34,176],
  [0,166], [-38,176], [-114,162], [-141,138]
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
  translate([sx,84,lower_h-4.2])
    rotate([0,0,rot])
      rounded_box([110,82,5], r=5);
}

module keyboard_clearance_cut(side="left") {
  sx = side == "left" ? -66 : 66;
  rot = side == "left" ? -keyboard_splay : keyboard_splay;
  translate([sx,84,lower_h-9.0])
    rotate([0,0,rot])
      rounded_box([100,72,7], r=4);
}

module lower_port_cuts() {
  // Rear face utility ports.
  translate([-104,-eps,10]) rotate([90,0,0]) rounded_slot(10,4.5,5); // keyboard USB-C
  translate([104,-eps,10]) rotate([90,0,0]) rounded_slot(10,4.5,5);  // PD/charge USB-C
  translate([0,-eps,10.5]) rotate([90,0,0]) rounded_slot(15,7,5);    // USB-A accessory
  translate([128,-eps,17]) rotate([90,0,0]) rounded_slot(12,5,5);    // power switch
}

module lower_vent_cuts() {
  for (i=[0:7])
    translate([-102 + i*6,-eps,19])
      rotate([90,0,0]) rounded_slot(18,2,5);
  for (i=[0:9])
    translate([52 + i*6,-eps,19])
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
      translate([0,7,lower_h-1])
        rounded_box([244,14,6], r=3);

      // Hinge mounting blocks.
      for (x=[-hinge_x, hinge_x])
        translate([x,10,floor_t-0.2])
          rounded_box(hinge_block_lower, r=3);

      // Printed hard stops keep the lid from rotating past the target opening angle.
      for (x=[-hinge_x, hinge_x])
        translate([x,24,lower_h+0.5])
          rotate([0,0,0])
            rounded_box([26,6,7.5], r=2);

      // Keyboard screw bosses, 4 per side.
      for (side=[-1,1]) {
        sx = side < 0 ? -66 : 66;
        rot = side < 0 ? -keyboard_splay : keyboard_splay;
        for (p=[[-46,-32],[46,-32],[-46,32],[46,32]])
          translate([sx,84,0])
            rotate([0,0,rot])
              translate([p[0],p[1],floor_t-0.2])
                heatset_boss(boss_m25_od, insert_m25_hole, keyboard_boss_h);
      }

      // Bottom cover bosses around perimeter and battery bay.
      for (p=[[-121,22],[-52,28],[52,28],[121,22],[-122,134],[-58,154],[58,154],[122,134],[0,144],[0,42]])
        translate([p[0],p[1],floor_t-0.2])
          heatset_boss(boss_m3_od, insert_m3_hole, 8.2);

      // Ribs tying hinge spine and keyboard trays into floor.
      for (x=[-124,-96,-64,-32,32,64,96,124])
        translate([x,27,floor_t-0.2])
          rotate([0,0,90]) rib(len=40, t=rib_t, h=8);

      for (x=[-98,-74,-50,50,74,98])
        translate([x,92,floor_t-0.2])
          rotate([0,0,0]) rib(len=38, t=rib_t, h=6);

      // Honeycomb fields under palm/battery zones.
      translate([-68,134,floor_t-0.2]) honeycomb_patch(5,3,10.5,1.1,5.0);
      translate([68,134,floor_t-0.2]) honeycomb_patch(5,3,10.5,1.1,5.0);

      // Battery cradle rails for a slim protected USB-C PD pack/module.
      translate([0,80,floor_t-0.2]) {
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
        translate([x,80,floor_t-0.2])
          heatset_boss(boss_m3_od, insert_m3_hole, 7.2);

      // Real I/O board mounting envelopes tied to rear port cutouts.
      translate([-104,12,floor_t+4]) rounded_box(usb_c_breakout, r=1.5);
      translate([104,14,floor_t+4.5]) rounded_box(pd_breakout, r=1.5);
      translate([0,13,floor_t+4.5]) rounded_box(usb_a_board, r=1.5);
    }

    // Hinge screw holes.
    for (x=[-hinge_x, hinge_x])
      for (p=[[-11,-6],[11,-6],[-11,6],[11,6]])
        translate([x+p[0],10+p[1],floor_t+7])
          screw_through(3.4, 20);

    // Bottom service cover screw access holes through the lower floor.
    for (p=[[-121,22],[-52,28],[52,28],[121,22],[-122,134],[-58,154],[58,154],[122,134],[0,144],[0,42]])
      translate([p[0],p[1],0])
        screw_access_from_bottom(3.5);

    // Battery strap screw access.
    for (x=[-54,54])
      translate([x,80,0])
        screw_access_from_bottom(3.5);

    // Cable pass-through from battery/controller bay to hinge spine.
    translate([0,26,floor_t+3])
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
      translate([0,82,0]) rounded_box([22,142,5.5], r=3);
      translate([0,15,0]) rounded_box([232,16,7], r=3);
      for (y=[36,68,100,132,160])
        translate([0,y,0]) rounded_box([32,7,5.5], r=2);
    }
    for (p=[[0,42],[0,72],[0,102],[0,132],[-108,15],[-54,15],[54,15],[108,15]])
      translate([p[0],p[1],-eps]) cylinder(d=3.4, h=12);
  }
}

module bottom_cover() {
  difference() {
    linear_extrude(height=2.6)
      offset(delta=-6) rpoly(lower_pts, r=7);
    for (p=[[-121,22],[-52,28],[52,28],[121,22],[-122,134],[-58,154],[58,154],[122,134],[0,144],[0,42]])
      translate([p[0],p[1],-eps]) cylinder(d=3.5, h=4);
    for (i=[0:11])
      translate([42+i*6,106,-eps]) rounded_slot(18,2,4);
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
    for (p=[[-121,-78],[121,-78],[-121,78],[121,78]])
      translate([p[0],p[1],upper_t-5])
        rounded_slot(16,3.2,7);

    // USB-C cable exit near right lower edge.
    translate([132,-56,5]) cube([14,9,7], center=true);

    // Hinge-side cable relief loop.
    translate([0,-86,5]) rounded_slot(22,7,10);
  }
}

module lid_back() {
  difference() {
    union() {
      rounded_box([upper_w-8, upper_h-8, 3.0], r=8);
      translate([0,0,2.8]) honeycomb_patch(15,8,10.8,1.15,4.8);
      for (x=[-116,-78,-39,0,39,78,116])
        translate([x,0,2.8]) rotate([0,0,90]) rib(len=150,t=1.8,h=4.8);
      for (x=[-hinge_x, hinge_x])
      translate([x,-74,2.8]) rounded_box(hinge_block_upper, r=3);
    }
    for (p=[[-130,-80],[-86,-80],[-43,-80],[0,-80],[43,-80],[86,-80],[130,-80],
            [-130,80],[-86,80],[-43,80],[0,80],[43,80],[86,80],[130,80]])
      translate([p[0],p[1],-eps]) cylinder(d=3.0, h=12);
    for (x=[-hinge_x, hinge_x])
      for (p=[[-10,-5],[10,-5],[-10,5],[10,5]])
        translate([x+p[0],-74+p[1],3]) screw_through(3.4, 16);
  }
}

module hinge_block(lower=true, side="left") {
  block = lower ? hinge_block_lower : hinge_block_upper;
  sxw = block[0];
  sy = block[1];
  sz = block[2];
  difference() {
    union() {
      rounded_box([sxw, sy, sz], r=3);
      translate([0,-sy/2-2.2,sz-6.8])
        rounded_box([sxw-4,4.4,6.8], r=1.5);
    }
    // hinge leaf screw holes
    for (p=[[-10,-5],[10,-5],[-10,5],[10,5]])
      translate([p[0],p[1],sz/2]) screw_through(3.4, sz+2);
    // 8 mm micro torque hinge barrel relief with print clearance.
    translate([0,-sy/2-2.3,sz-5.8])
      rotate([90,0,0]) cylinder(d=hinge_barrel_d+0.8, h=7.2, center=true);
    // Shallow leaf pocket for a 1.5-2.0 mm metal hinge leaf.
    translate([0,0,sz-1.2]) rounded_box([sxw-8,sy-5,1.6], r=1.2);
  }
}

module tablet_bracket() {
  difference() {
    union() {
      // Sliding screw foot plus hooked lip. Install with 0.8 mm TPU/EVA pad on lip face.
      rounded_box([23,14,3.0], r=2);
      translate([0,-5.3,3.0]) rounded_box([23,3.4,4.2], r=1);
      translate([0,-7.2,6.1]) rounded_box([23,4.8,1.8], r=0.8);
    }
    translate([0,1,-eps]) rounded_slot(14,3.2,9);
    translate([0,-6.9,3.5]) rounded_box([18,1.0,2.4], r=0.4);
  }
}

module tablet_bracket_at(x=0, y=0, rot=0) {
  translate([x,y,upper_t-2])
    rotate([0,0,rot])
      color("#d7d1c3") tablet_bracket();
}

module tablet_brackets_visual() {
  tablet_bracket_at(-121,-78,180);
  tablet_bracket_at(121,-78,180);
  tablet_bracket_at(-121,78,0);
  tablet_bracket_at(121,78,0);
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
    translate([0,80,floor_t+6.0])
      rounded_box([108,52,10.5], r=4);
  color("#252729")
    translate([0,80,floor_t+11.5])
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
    translate([-104,9.5,10.6]) rounded_box(usb_c_breakout, r=1);
    translate([104,12.5,10.7]) rounded_box(pd_breakout, r=1);
    translate([0,10.5,10.7]) rounded_box(usb_a_board, r=1);
  }
  color("#b8b8aa") {
    translate([-104,1.8,12.2]) rounded_box([9,5,3], r=1);
    translate([104,1.8,12.2]) rounded_box([9,5,3], r=1);
    translate([0,1.5,12.0]) rounded_box([14,7,5], r=1);
  }
}

module simulated_cabling() {
  color("#101112") {
    cable_run([[-104,52,floor_t+12.5],[-64,60,floor_t+12.5],[-28,80,floor_t+12.5],[28,80,floor_t+12.5],[64,60,floor_t+12.5]], w=3.2, h=2.8);
    cable_run([[36,80,floor_t+13.2],[70,62,floor_t+13.2],[100,31,floor_t+13.2],[104,10,floor_t+13.2]], w=3.8, h=3.0);
    cable_run([[0,60,floor_t+13.2],[0,34,floor_t+14.2],[0,10,lower_h+0.6],[0,-10,hinge_axis_z+1.8]], w=4.2, h=3.2);
  }
}

module hinge_hardware_visual() {
  color("#111111")
    for (x=[-hinge_x, hinge_x])
      translate([x,hinge_axis_y,hinge_axis_z])
        rotate([90,0,0]) cylinder(d=hinge_barrel_d,h=hinge_barrel_len, center=true);
  color("#2d2d2b")
    for (x=[-hinge_x, hinge_x]) {
      translate([x,10,lower_h+1.1]) rounded_box([30,7,2.4], r=1);
      translate([x,-15,lower_h+1.1]) rounded_box([30,7,2.4], r=1);
    }
}

module keyboard_visual(side="left", include_keycaps=true) {
  sx = side == "left" ? -66 : 66;
  rot = side == "left" ? -keyboard_splay : keyboard_splay;
  translate([sx,84,lower_h-6.4])
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

  translate([0,hinge_axis_y,hinge_axis_z])
    rotate([122,0,0])
      translate([0,upper_h/2+1,-7.2]) {
        color("#b9b6ad") lid_frame();
        color("#777777") translate([0,0,-3.2]) lid_back();
      }
}

module tablet_assembly_visual() {
  translate([0,hinge_axis_y,hinge_axis_z])
    rotate([122,0,0])
      translate([0,upper_h/2+1,-7.2]) {
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
      translate([24,0,0]) rounded_box([23,14,3], r=2);
    }
    translate([24,1,-eps]) rounded_slot(14,3.2,8);
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
