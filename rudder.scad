module rudder(length=12,height=24, y_angle=0, z_angle=0, handle_length=48, handle_angle=30){
	plywood_thickness=.5;

	rotate([0,y_angle,z_angle]){
		translate([-length+2,0,-4])
			rotate([0,handle_angle,0])
			cylinder(h=handle_length,d=2, $fn=50);
		translate([-length,-plywood_thickness/2,-height])
			cube([length,plywood_thickness,height]);
	}
}
rudder();
