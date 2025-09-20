function get_param(params, key) =
    let (tmp = [for (p = params) if (p[0]==key) p[1]])
        len(tmp) == 1 ? tmp[0] : assert(0, str("parameter '", key, "' not found"));

module bodyBoxPrimitive(innerWidth, innerLength, innerHeight, outerRadius){
	minkowski(){
		cube([innerWidth-2*outerRadius, innerLength-2*outerRadius, innerHeight-2*outerRadius], center=true); 
		sphere(r=outerRadius);
	}
};

module boxShellKeeperBottomA(geom){
    myInfinity=get_param(geom, "infinity"); 
    eps=get_param(geom, "eps"); 
	outerRadius=get_param(geom, "outerRadius"); 
    rimThickness = 0.5*get_param(geom, "wallThickness"); 
    rimHeight = 2.0*get_param(geom, "wallThickness"); 
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
                        innerWidth-2*outerRadius+2*rimThickness, 
                        innerLength-2*outerRadius+2*rimThickness], 
                        center=true);                
                } // minkowski
    } // union
} // module

module boxShellKeeperBottom(geom){
    eps=get_param(geom, "eps"); 
    screwXY=get_param(geom, "screwXY"); 
    innerHeight=get_param(geom, "innerHeight");
    wallThickness=get_param(geom, "wallThickness"); 
    screwHeadHeight=get_param(geom, "screwHeadHeight"); 
    screwShaftLength=get_param(geom, "screwShaftLength"); 
    inf=get_param(geom, "infinity"); 

    // cut the screw bosses where the non-threaded hole ends
    difference(){
        boxShellKeeperBottomA(geom);            
        for (screw = screwXY)
            let(screwX = screw[0], screwY = screw[1]){
                h = inf+innerHeight/2+wallThickness-screwHeadHeight-screwShaftLength;
                translate([screwX, screwY, -inf+2*eps]) // ugly hack
                    cylinder(h=h, r=screwBossDiam(geom)/2+eps);
                }
    }
}

module screwAdditive(geom, posX, posY){
    inf=get_param(geom, "infinity"); 
    eps=get_param(geom, "eps"); 
    innerHeight=get_param(geom, "innerHeight");
    screwHeadDiam=get_param(geom, "screwHeadDiam"); 
    screwHeadHeight=get_param(geom, "screwHeadHeight"); 
    wallThickness=get_param(geom, "wallThickness"); 
    shellHeight = innerHeight/2;
    
    // screw boss (sufficiently wide for head)
    bossHeight = innerHeight + 2*wallThickness - 2*eps;
    translate([posX, posY, -bossHeight/2])
        cylinder(h=bossHeight, r=screwBossDiam(geom)/2);
}

function screwBossDiam(geom) = 
    get_param(geom, "screwHeadDiam")+2*get_param(geom, "wallThickness"); 

module screwSubtractive(geom, posX, posY){
    inf=get_param(geom, "infinity"); 
    eps=get_param(geom, "eps"); 
    wallThickness=get_param(geom, "wallThickness"); 
    innerHeight=get_param(geom, "innerHeight");
    screwHeadDiam=get_param(geom, "screwHeadDiam"); 
    screwHeadHeight=get_param(geom, "screwHeadHeight"); 
    shellHeight = innerHeight/2;

    // screw head
    yScrewBottom = shellHeight + wallThickness - screwHeadHeight;
    translate([posX, posY, yScrewBottom+eps])
        cylinder(h=screwHeadHeight+eps, r=screwHeadDiam/2);

    // non-threaded screw shaft part
    screwShaftDiam=get_param(geom, "screwShaftDiam"); 
    screwShaftLength=get_param(geom, "screwShaftLength"); 
    screwThreadDiam=get_param(geom, "screwThreadDiam"); 
    translate([posX, posY, yScrewBottom-screwShaftLength+eps])
        cylinder(h=screwShaftLength+eps, r=screwShaftDiam/2);

    // threaded screw shaft part
    translate([posX, posY, -shellHeight+eps])
        cylinder(h=innerHeight+eps, r=screwThreadDiam/2);
}

module boxShellKeeperTop(geom){
    inf=get_param(geom, "infinity"); 
    eps=get_param(geom, "eps"); 
    difference(){
        cube([inf-eps, inf-eps, inf-eps], center=true);
        boxShellKeeperBottom(geom);
    } // difference
} // module

module myCaseBodyWithScrews(geom){
    screwXY=get_param(geom, "screwXY"); 

    difference(){
        union(){
            // first add the case
            myCaseBody(geom);
            // then add all the screws
            for (screw = screwXY)
                let(screwX = screw[0], screwY = screw[1]){
                        screwAdditive(geom, screwX, screwY);
                }; // let            
            }; // union
            // 2nd+ arg to difference: then remove all the holes (from screw bosses AND case)
            for (screw = screwXY)
                let(screwX = screw[0], screwY = screw[1]){
                        screwSubtractive(geom, screwX, screwY);
                } // let
    } // difference
}

module myCaseBody(geom){
    innerWidth=get_param(geom, "innerWidth"); 
    innerLength=get_param(geom, "innerLength"); 
    innerHeight=get_param(geom, "innerHeight");
    outerRadius=get_param(geom, "outerRadius"); 
    wallThickness=get_param(geom, "wallThickness"); 
    screwXY=get_param(geom, "screwXY"); 
    difference(){
		bodyBoxPrimitive(innerWidth+2*wallThickness, innerLength+2*wallThickness, innerHeight+2*wallThickness, outerRadius);
        bodyBoxPrimitive(innerWidth+0*wallThickness, innerLength+0*wallThickness, innerHeight+0*wallThickness, outerRadius);
	}
};