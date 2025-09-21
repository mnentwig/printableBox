// ======================================
// = 3D printable DIY box               =
// = 2025 Markus Nentwig                =
// = This file is in the public domain. =
// ======================================
// open with openSCAD, "render" (F6), "export"

use<boxCode.scad>
use<screwBoss.scad>

// This file: user-defineable parameters and placement of the two shells for export

// === Parameters (mm) ===
// note: screw holes are not placed automatically, see below.
// They should have at least minimal clearance to the sidewall to prevent weakening the case where the threaded screw boss enters the bottom shell. 

wi = is_undef(wi) ? 40 : wi;
li = is_undef(li) ? 80 : li;
hi = is_undef(hi) ? 20 : hi;
wt = is_undef(wt) ? 1.2 : wt;
screwX = wi/2-3;
screwY = li/2-3;

geom=[
    // === box parameters ===
    ["innerWidth", wi],     // inside width at center (each shell fits a narrow object of this width)
    ["innerLength", li],    // inside length at center (each shell fits a narrow object of this length)
    ["innerHeight", hi],    // inside height at center (assembled shells fit a narrow object of this height)
    ["outerRadius", 1.5],     // radius of corners << min(width, height). Set zero-ish value for square box
    ["wallThickness", wt],   // width of the walls on every face 
    ["screwBossPrefix", "myScrewA"], // (see below: allows reuse of module with independent parameter sets)

    // === screw boss parameters ===    
    // threaded hole. Mx minus some margin. E.g. -10% (that is, 2.7mm for M3), tune for printer.
    ["myScrewA.threadDiam", 2.7],   // screw hole diameter (threaded part)
    // non-threaded hole. Mx plus some margin. E.g. +10% (that is, 3.3mm for M3), tune for printer.
    ["myScrewA.shankDiam", 3.4],   // screw hole diameter (non-threaded part)
    ["myScrewA.shankLength", 2],   // bolt length between head and threaded end. Depends on actual screw
    ["myScrewA.headHeight", 3],   // screw head height
    ["myScrewA.headDiam", 5.5],   // screw head diameter
    ["myScrewA.headWallThickness", 1.1], // thickness of screw recess (load bearing!)
    ["myScrewA.standoffWallThicknessLo", 0.8], // thickness of standoff where the screw enters (minimum torque)
    ["myScrewA.standoffWallThicknessHi", 1.2], // thickness of standoff at boss end (maximum torque)
    
    // === screws ===
    // (arbitrary number, user placed because application-dependent. 
    // Use ["screwXY", []] for no screws
    ["screwXY", [[screwX, screwY], [-screwX, screwY], [screwX, -screwY], [-screwX, -screwY]]],

    // === system-wide parameters === 
    ["infinity", 345],      // "large number" use reasonable value when working with preview
    ["eps", 0.01],           // "small number" for overlapping solids
    ];

// curve resolution
if (0){
    echo("Debug mode: Lining up steps on x axis");
    $fn=10;
    delta = 1.5*wi;
    translate([0*delta, 0, 0])caseTopBottom(geom);
    translate([1*delta, 0, 0])caseTop(geom);
    translate([2*delta, 0, 0])caseBottom(geom);
    translate([3*delta, 0, 0])boxTop(geom);
    translate([4*delta, 0, 0])boxBottom(geom);
} else {
    echo("Production mode, rendering");
    $fn=50;
    lowerShellThickness = hi/2+wt;
    translate([-0.55*wi, 0, lowerShellThickness])
        boxTop(geom);
    translate([0.55*wi, 0, lowerShellThickness])rotate([0, 180, 0]) 
        boxBottom(geom);
}




//    innerWidth=get_param(geom, "innerWidth"); 
//    translate([innerWidth*1.8, 0, 0])   // place conveniently side-by-side
//        rotate([0, 180, 0])             // place conveniently face-down
//            intersection(){
//                myCaseBodyWithScrews(geom);       // constructs (again) complete body
//                boxShellKeeperBottom(geom); // intersection leaves only bottom half

