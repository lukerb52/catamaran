module pontoon(length=108, height=18, foam_vis=false, foam_board_thickness=2, board_number=1, n_vert=3, side="port") {
	//// VARIABLES ////

	function b1()=0.5; //One-by-one
	function b2()=1.5; //One-by-one
	b1=.5;
	b2=1.5;
	b4=3.5;
	b8=7.5;
	plywood_thickness=.5;
	bottom_length=length-height*2-b2();
	bottom_x=bottom_length/(n_vert-1);
	xy=[height, height-b2()];
	//echo(xy[0]);echo(xy[1]);
	hyp=sqrt((xy[0]*xy[0])+(xy[1]*xy[1]));
	angle=atan2(xy[0],xy[1]);
	echo(angle);
	//echo(hyp);

	//// GENERATION CODE ////

	color("BurlyWood", 1.0){ // This color represents softwood.

		// TOP SUPPORT //
		cube([length,b2(),b2()]);

		// VERTICAL SUPPORTS //
		for(i = [0:n_vert-1]){
			translate([height+bottom_x*i,0,0]){
				translate([0,0,-height+b2()*2])
					cube([b2(),b2(),height-b2()*2]);
				/*// CORNER SUPPORTS
				  translate([0,0,-b8+b2]){
				  if(side=="starboard" || side=="right"){
				  translate([0,b2,0])
				  cube([b2,b4,b8]);
				//echo("It's starboard!");
				}
				else if(side=="port" || side == "left"){
				translate([0,-b4,0])
				cube([b2,b4,b8]);
				}
				}*/
			}
		}

		// BOTTOM SUPPORT //
		translate([height,0,-height+b2()])
			cube([bottom_length+b2(),b2(),b2()]);

		// FRONT SUPPORT //
		/*translate([bottom_length+height*1.5,b2()/2,-height/2+b2()])
		  rotate([0,angle,0])
		  cube([b2(),b2(),hyp], center=true);*/
		translate([length,0,0])mirror([1,0,0])
			translate([height,0,-height+b2()])
			rotate([0,-angle,0])
			cube([b2(),b2(),hyp]);//,center=true);

		// REAR SUPPORT //
		translate([height,0,-height+b2()])
			rotate([0,-angle,0])
			cube([b2(),b2(),hyp]);//,center=true);
	}

	// FOAM //
	if(foam_vis==true){
		color("Pink", 1.0){
			difference(){
				for(i=[b2(),-board_number*foam_board_thickness]){
					translate([0,i,-height+b2()])
						cube([length,foam_board_thickness*board_number,height]);
				}
				for(i=[false,true]){
					translate([-b2()/2,0,-hyp+b2()/2])
						rotate([0,-angle,0])
						cube(height*2, center=true);
					if(i==true){
						translate([length,0,0])mirror([1,0,0])
							translate([-b2()/2,0,-hyp+b2()/2])
							rotate([0,-angle,0])
							cube(height*2, center=true);
					}
				}
			}
		}
	}
}
pontoon();
