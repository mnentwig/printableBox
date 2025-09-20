// ======================================
// = 3D printable DIY box               =
// = 2025 Markus Nentwig                =
// = This file is in the public domain. =
// ======================================
// open with openSCAD, "render" (F6), "export"

include<boxCode.scad>

// This file: user-defineable parameters and placement of the two shells for export

// === Parameters (mm) ===
// note: screw holes are not placed automatically, see below.
// They should have at least minimal clearance to the sidewall to prevent weakening the case where the threaded screw boss enters the bottom shell. 
screwX = 15.9;
screwY = 35.9;
geom=[
    ["innerWidth", 40],     // inside width at center (each shell fits a narrow object of this width)
    ["innerLength", 80],    // inside length at center (each shell fits a narrow object of this length)
    ["innerHeight", 20],    // inside height at center (assembled shells fit a narrow object of this height)
    ["outerRadius", 1.5],     // radius of corners << min(width, height). Set zero-ish value for square box
    ["wallThickness", 1.2],   // width of the walls on every face 

    ["screwThreadDiam", 2.7],   // screw hole diameter (threaded part)
    ["screwShaftDiam", 3.4],   // screw hole diameter (non-threaded part)
    ["screwShaftLength", 2],   // unthreaded screw hole depth
    ["screwHeadDiam", 5.6],   // screw head recess diameter
    ["screwHeadHeight", 3],   // screw head recess depth
    
    ["infinity", 345],      // "large number" use reasonable value when working with preview
    ["eps", 0.01],           // "small number" for overlapping solids
    
    // screws (arbitrary number, user placed. Use ["screwXY", []] for no screws
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