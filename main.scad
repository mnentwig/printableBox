// ======================================
// = 3D printable DIY box               =
// = 2025 Markus Nentwig                =
// = This file is in the public domain. =
// ======================================
// open with openSCAD, "render" (F6), "export"

use<src/boxCode.scad>
use<src/screwBoss.scad>

// This file: user-defineable parameters and placement of the two shells for export

// === Parameters (mm) ===

// case geometry defaults. Those can be set from the command line
// Example invocation (Windows CMD prompt):
// "C:\Program Files (x86)\OpenSCAD\openscad.exe" -D wi=100 -D hi=25 -D li=200 -o myExport.stl main.scad

wi = is_undef(wi) ? 40 : wi;
li = is_undef(li) ? 80 : li;
hi = is_undef(hi) ? 20 : hi;
wt = is_undef(wt) ? 1.2 : wt;

// screw placement defaults (see below, any number of screws can be positioned at individual XY coordinates)
screwX = wi/2-3;
screwY = li/2-3;

// Geometry description, all units mm
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
    // Below is for M2.5
    ["myScrewA.threadDiam", 2.2],   // screw hole diameter (threaded part)
    // non-threaded hole. Mx plus some margin. E.g. +10% (that is, 3.3mm for M3), tune for printer.
    ["myScrewA.shankDiam", 2.6],   // screw hole diameter (non-threaded part)
    ["myScrewA.shankLength", 1.5],   // bolt length between head and threaded end. Depends on actual screw. Needs at least headWallThickness for non-threaded hole on the screw head side plus ~0.5mm or more for easier insertion
    ["myScrewA.headHeight", 2],   // screw head height
    ["myScrewA.headDiam", 5],   // screw head diameter
    ["myScrewA.headWallThickness", 1.0], // thickness of screw recess (load bearing!)
    ["myScrewA.standoffWallThicknessLo", 0.9], // thickness of standoff where the screw enters (minimum torque)
    ["myScrewA.standoffWallThicknessHi", 1.1], // thickness of standoff at boss end (maximum torque)
    ["myScrewA.bossPadDiam", 8.5], // standoff extension to distribute force (prelim)
    
    // === screws ===
    // (arbitrary number, user placed because application-dependent. 
    // Use ["screwXY", []] for no screws
    ["screwXY", [[screwX, screwY], [-screwX, screwY], [screwX, -screwY], [-screwX, -screwY]]],
    
    ["cutoutsTopXYR", [[0, -25, 10], [0, 25, 10], [-10, 0, 8], [10, 0, 7]]],
    ["cutoutsBottomXYR", []], //[[0, -25, 13], [0, 25, 12], [6, 0, 10], [-12, 8, 6], [-12, -7, 5]]],

    // === ribs ===
    ["ribsInnerThickness", 0.8],
    ["ribsInnerX", [-10, 5, 10]],
    ["ribsInnerY", [-15, -10, 10]],
    
    // === system-wide parameters === 
    ["infinity", 345],      // "large number" use reasonable value when working with preview
    ["eps", 0.01],           // "small number" for overlapping solids
    ];

if (0){
    // use this part for step-by-step debugging
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
