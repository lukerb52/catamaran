/*
   This catamaran design by Luke Bubar <https://lukebubar.xyz>

   All units in inches.
   */

//// MODULES ////

use <pontoon.scad>
use <rudder.scad>

//// VARIABLES ///

function N()=50;

// WOOD //
b1=.5;
b2=1.5;
b4=3.5;
b8=7.25;
plywood_thickness=.5;

// PLYWOOD SEAT //
plywood_length=72;
plywood_width=36;
seat_x=18;

//echo("Plywood needed: ", plywood_length/12, "feet by ", plywood_width/12, "feet");

// CENTER PLANK //
center_plank_length=120;

// PONTOON //
pontoon_length=center_plank_length-12;
pontoon_height=18;
pontoon_show=true;
foam_board_thickness=1;
foam_board_number=1;
pontoon_vertical_supports=4;

// RUDDER //
rudder_length=12;
rudder_height=pontoon_height+18;
rudder_y_angle=0;
rudder_z_angle=0;
handle_length=54;
handle_angle=60;


echo("Foam needed: ", pontoon_length/12, "feet by ", pontoon_height/12, "feet");

// LEAST BOW PLANK //
least_bow_plank_x=72;

// STERN PLANK //
stern_plank_x=seat_x-b8;

// CENTER SPINE SUPPORTS //
center_spine_support_xy=[
	(plywood_length/2*plywood_length/2)
	,
	((center_plank_length-pontoon_length)*(center_plank_length-pontoon_length))
];

center_spine_support_angle=atan2(center_spine_support_xy[0],center_spine_support_xy[1]);
echo("The center spine support angle is ", center_spine_support_angle);
center_spine_support_length=sqrt(center_spine_support_xy[0]+center_spine_support_xy[1]);
echo("The center_spine_support_length is ", center_spine_support_length);

// SPINE SUPPORTS //

spine_supports_y=24;

// MAST //
mast_forward_x=75;
mast_height=120;
mast_outer_diameter=1+5/8;
mast_wall=1/8;
mast_inner_diameter=mast_outer_diameter-mast_wall*2;
mast_down_y=0;

// MAST HOLDER //
mast_holder_height=8;
//mast_holder_inner_diameter=mast_outer_diameter;
mast_holder_inner_diameter=1.913;
//mast_holder_wall=mast_wall*2;
mast_holder_outer_diameter=2.375;

// MAST SUPPORTS //

mast_support_angle=20;
mast_support_y=spine_supports_y;
mast_support_length=(spine_supports_y/cos(mast_support_angle));
echo("The mast support board length is", mast_support_length);

//// GENERATION CODE ///

// STARBOARD PONTOON //
translate([0,-plywood_length/2,-b2])
	pontoon(pontoon_length,pontoon_height, pontoon_show, foam_board_thickness, foam_board_number, pontoon_vertical_supports, "starboard");

	// PORT PONTOON //
translate([0,plywood_length/2-b2,-b2])
	pontoon(pontoon_length,pontoon_height, pontoon_show, foam_board_thickness, foam_board_number, pontoon_vertical_supports, "port");

	color("BurlyWood", 1.0){ // This color represents softwood.

		// PLYWOOD SEAT //
		translate([seat_x,-plywood_length/2,0])
			cube([plywood_width,plywood_length,plywood_thickness]);

		// STERN PLANK //
		translate([stern_plank_x,-plywood_length/2,0])
			cube([b8,plywood_length,b2]);
		// stern plank corner port support
		translate([stern_plank_x,(-plywood_length/2)+b2,-b2])
		cube([b8,b2,b2]);
		// stern plank corner starboard support
		translate([stern_plank_x,(plywood_length/2)-2*b2,-b2])
		cube([b8,b2,b2]);

		// CENTER SPINE PLANK //
		translate([0,-b4/2,-b2])
			cube([center_plank_length,b4,b2]);

		// CENTER SPINE BOW SUPPORTS //
		translate([pontoon_length-b4,plywood_length/2,0])
			//cube([b4,48,b2]);
			rotate([0,0,-70])
			cube([center_spine_support_length,b4,b2]);
		mirror([0,1,0])
			translate([pontoon_length-b4,plywood_length/2,0])
			rotate([0,0,-70])
			cube([center_spine_support_length,b4,b2]);

		// PORT SPINE PLANK //
		translate([stern_plank_x,-b4/2-spine_supports_y,-b2])
			cube([least_bow_plank_x+b8-stern_plank_x,b4,b2]);
			echo ("The side spine plank length is", least_bow_plank_x+b8-stern_plank_x);

		// STARBOARD SPINE PLANK //
		translate([stern_plank_x,-b4/2+spine_supports_y,-b2])
			cube([least_bow_plank_x+b8-stern_plank_x,b4,b2]);

		// LEAST BOW PLANK //
		translate([least_bow_plank_x,-plywood_length/2,0])
			cube([b8,plywood_length,b2]);
		// least bow plank corner port support
		translate([least_bow_plank_x,(-plywood_length/2)+b2,-b2])
		cube([b8,b2,b2]);
		// least bow plank corner starboard support
		translate([least_bow_plank_x,(plywood_length/2)-2*b2,-b2])
		cube([b8,b2,b2]);


		// MAST SUPPORTS //

		// right
		mirror([0,1,0])
			translate([mast_forward_x-b4/2,mast_support_y,0])
			rotate([90-mast_support_angle,0,0])
			cube([b4,b2,mast_support_length+3]);
		// left
		translate([mast_forward_x-b4/2,mast_support_y,0])
			rotate([90-mast_support_angle,0,0])
			cube([b4,b2,mast_support_length]);
		// bottom
		bottom_support_length=8;
		translate([mast_forward_x-bottom_support_length/2,-b4/2,-b2*2])
			cube([bottom_support_length,b4,b2]);

		// RUDDER //
		translate([-1,0,0])
			rudder(rudder_length,rudder_height,rudder_y_angle, rudder_z_angle, handle_length, handle_angle);

		// CENTER RUNNER //
		translate([plywood_width+seat_x,b4/2,-3*12])
		cube([least_bow_plank_x-(plywood_width+seat_x),plywood_thickness,4*12]);
	}
// MAST //
color("Gray", 1.0){
	translate([mast_forward_x,0,-b2-mast_down_y])
		difference(){
			cylinder(mast_height,d=mast_outer_diameter,$fn=N());
			translate([0,0,-1])cylinder(mast_height+2,d=mast_inner_diameter,$fn=N());
		}
}

// MAST HOLDER //
/*color("White", 1.0){
  translate([mast_forward_x,0,-b2-mast_holder_height])
  difference(){
  cylinder(mast_holder_height, d=mast_holder_outer_diameter, $fn=N());
  translate([0,0,-1])cylinder(mast_holder_height+2,d=mast_holder_inner_diameter,$fn=N());
  }
  }
  */
