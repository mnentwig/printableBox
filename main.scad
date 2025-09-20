// ======================================
// = 3D printable DIY box               =
// = 2025 Markus Nentwig                =
// = This file is in the public domain. =
// ======================================
// open with openSCAD, "render" (F6), "export"

include<boxCode.scad>

// This file: user-defineable parameters and placement of the two shells for export



// === Parameters (mm) ===
screwX = 12;
screwY = 32;
geom=[
    ["innerWidth", 40],     // inside width at center (each shell fits a narrow object of this width)
    ["innerLength", 80],    // inside length at center (each shell fits a narrow object of this length)
    ["innerHeight", 20],    // inside height at center (assembled shells fit a narrow object of this height)
    ["outerRadius", 5],     // radius of corners << min(width, height). Set zero-ish value for square box
    ["wallThickness", 1],   // width of the walls on every face 

    ["screwThreadDiam", 2.7],   // screw hole diameter (threaded part)
    ["screwShaftDiam", 3.4],   // screw hole diameter (non-threaded part)
    ["screwShaftLength", 2],   // unthreaded screw hole depth
    ["screwHeadDiam", 5.6],   // screw head recess diameter
    ["screwHeadHeight", 3],   // screw head recess depth
    
    ["infinity", 345],      // "large number" use reasonable value when working with preview
    ["eps", 0.01],           // "small number" for overlapping solids
    ["screwXY", [[screwX, screwY], [-screwX, screwY], [screwX, -screwY], [-screwX, -screwY]]]
    ];

// curve resolution
$fn=50;

// screw debug
//screwAdditive(geom, 15, 0);

//screwSubtractive(geom, 0, 0);
//difference(){
//    screwAdditive(geom, 0, 20);
//    screwSubtractive(geom, 0, 20);
//}
renderBox(geom);
//myCaseBodyWithScrews(geom);

module renderBoxTop(geom){
    intersection(){
        myCaseBodyWithScrews(geom); // constructs complete body
        boxShellKeeperTop(geom); // intersection leaves only top half
    } // intersection
} // module

module renderBoxBottom(geom){
    innerWidth=get_param(geom, "innerWidth"); 
    translate([innerWidth*1.8, 0, 0])   // place conveniently side-by-side
        rotate([0, 180, 0])             // place conveniently face-down
            intersection(){
                myCaseBodyWithScrews(geom);       // constructs (again) complete body
                boxShellKeeperBottom(geom); // intersection leaves only bottom half
            } // intersection
} // module

module renderBox(geom){
    renderBoxTop(geom);
    renderBoxBottom(geom);
}