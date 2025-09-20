// ======================================
// = 3D printable DIY box               =
// = 2025 Markus Nentwig                =
// = This file is in the public domain. =
// ======================================
// open with openSCAD, "render" (F6), "export"

include<boxCode.scad>

// This file: user-definable parameters and placement of the two shells for export



// === Parameters (mm) ===
geom=[
    ["innerWidth", 40],     // inside width at center (each shell fits a narrow object of this width)
    ["innerLength", 80],    // inside length at center (each shell fits a narrow object of this length)
    ["innerHeight", 20],    // inside height at center (assembled shells fit a narrow object of this height)
    ["outerRadius", 5],     // radius of corners << min(width, height). Set zero-ish value for square box
    ["wallThickness", 1],   // width of the walls on every face 
    ["infinity", 345],      // "large number" use reasonable value when working with preview
    ["eps", 0.01]           // "small number" for overlapping solids
    ];

// curve resolution
$fn=50;


intersection(){
    myCaseBody(geom); // constructs complete body
    boxShellKeeperTop(geom); // intersection leaves only top half
}

innerWidth=get_param(geom, "innerWidth"); 
translate([innerWidth*1.5, 0, 0])   // place conveniently side-by-side
    rotate([0, 180, 0])             // place conveniently face-down
        intersection(){
            myCaseBody(geom);       // constructs (again) complete body
            boxShellKeeperBottom(geom); // intersection leaves only bottom half
        }
