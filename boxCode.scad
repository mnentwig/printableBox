function get_param(params, key) =
    let (tmp = [for (p = params) if (p[0]==key) p[1]])
        len(tmp) == 1 ? tmp[0] : assert(0, str("parameter '", key, "' not found"));

module bodyBoxPrimitive(innerWidth, innerLength, innerHeight, outerRadius){
	halfRad=outerRadius/2;
	minkowski(){
		cube([innerWidth-halfRad, innerLength-halfRad, innerHeight-halfRad], center=true); 
		sphere(r=outerRadius);
	}
};

module boxShellKeeperBottom(geom){
    myInfinity=get_param(geom, "infinity"); 
    eps=get_param(geom, "eps"); 
	outerRadius=get_param(geom, "outerRadius"); 
    rimThickness = 0.5*get_param(geom, "wallThickness"); 
    rimHeight = 1.0*get_param(geom, "wallThickness"); 
    innerWidth=get_param(geom, "innerWidth"); 
    innerLength=get_param(geom, "innerLength"); 

    union(){
        // shell to keep is positive z
        translate([0,0,myInfinity/2])
            cube([myInfinity+eps, myInfinity+eps, myInfinity+eps], center=true);
        // add a half-thickness rim to align the shells
        translate([0, 0, -rimHeight])
            linear_extrude(height=rimHeight+eps)
                minkowski(){
                    circle(r=outerRadius); 
                    square([
                        innerWidth-outerRadius/2+2*rimThickness, 
                        innerLength-outerRadius/2+2*rimThickness], 
                        center=true);                
                } // minkowski
    } // union
} // module

module boxShellKeeperTop(geom){
    inf=get_param(geom, "infinity"); 
    eps=get_param(geom, "eps"); 
    difference(){
        cube([inf-eps, inf-eps, inf-eps], center=true);
        boxShellKeeperBottom(geom);
    } // difference
} // module

module myCaseBody(geom){
    innerWidth=get_param(geom, "innerWidth"); 
    innerLength=get_param(geom, "innerLength"); 
    innerHeight=get_param(geom, "innerHeight");
    outerRadius=get_param(geom, "outerRadius"); 
    wallThickness=get_param(geom, "wallThickness"); 
	difference(){
		bodyBoxPrimitive(innerWidth+2*wallThickness, innerLength+2*wallThickness, innerHeight+2*wallThickness, outerRadius);
        bodyBoxPrimitive(innerWidth+0*wallThickness, innerLength+0*wallThickness, innerHeight+0*wallThickness, outerRadius);
	}
};