/*Created by Andy Levesque
Credit to 
    - @David D on Printables for Multiconnect
    - Jonathan at Keep Making for Multiboard
Licensed Creative Commons 4.0 Attribution Non-Commercial Sharable with Attribution
This file also adopts the Multiboard License https://www.multiboard.io/license
All adaptations must have attribution and follow the more restrictive of the two licenses. 
*/

include <BOSL2/std.scad>
include <BOSL2/rounding.scad>

//snap connector https://a360.co/3AI9ZVW

snapConnectBacker();


module snapConnectBacker(offset = 0){
    //bumpout profile
bumpout = turtle([
    "ymove", -2.237,
    "turn", 40,
    "move", 0.557,
    "arcleft", 0.5, 50,
    "ymove", 0.252
    ]   );

    diff("remove")
        //base
        oct_prism(h = 4.23, r = 11.4465) {
            //first bevel
            position(TOP) oct_prism(h = 1.97, r1 = 11.4465, r2 = 12.5125, $fn =8, anchor=BOTTOM)
                //top - used as offset. Independen snap height is 2.2
                position(TOP) oct_prism(h = offset, r = 12.9885, anchor=BOTTOM);
                    //top bevel - not used when applied as backer
                    //position(TOP) oct_prism(h = 0.4, r1 = 12.9985, r2 = 12.555, anchor=BOTTOM);
        //end base
        //bumpouts
        attach([RIGHT, LEFT, FWD, BACK],LEFT)  color("green") fwd(1) down(0.8) offset_sweep(path = bumpout, height=3, spin=[0,270,0]);
        //delete tools
        //Bottom and side cutout - 2 cubes that form an L (cut from bottom and from outside) and then rotated around the side
        tag("remove") align(BOTTOM, [RIGHT, BACK, LEFT, FWD], inside=true, shiftout=0.01, inset = 1.6) color("lightblue") cuboid([0.8,7.161,3.4], spin=90*$idx)
            align(RIGHT, [TOP]) cuboid([0.8,7.161,1], anchor=BACK);
    }

    //octo_prism - module that creates an oct_prism with anchors positioned on the faces instead of the edges (as per cyl default for 8 sides)
    module oct_prism(h, r=0, r1=0, r2=0, anchor=CENTER) {
        if (r != 0) {
            // If r is provided, create a regular octagonal prism with radius r
            rotate (22.5) cylinder(h=h, r1=r, r2=r, $fn=8, anchor=anchor) rotate (-22.5) children();
        } else if (r1 != 0 && r2 != 0) {
            // If r1 and r2 are provided, create an octagonal prism with different top and bottom radii
            rotate (22.5) cylinder(h=h, r1=r1, r2=r2, $fn=8, anchor=anchor) rotate (-22.5)  children();
        } else {
            echo("Error: You must provide either r or both r1 and r2.");
        }
    }
}

//octo_prism - module that creates an oct_prism with anchors positioned on the faces instead of the edges (as per cyl default for 8 sides)
module oct_prism(h, r=0, r1=0, r2=0, anchor=CENTER) {
    if (r != 0) {
        // If r is provided, create a regular octagonal prism with radius r
        rotate (22.5) cylinder(h=h, r1=r, r2=r, $fn=8, anchor=anchor) rotate (-22.5) children();
    } else if (r1 != 0 && r2 != 0) {
        // If r1 and r2 are provided, create an octagonal prism with different top and bottom radii
        rotate (22.5) cylinder(h=h, r1=r1, r2=r2, $fn=8, anchor=anchor) rotate (-22.5)  children();
    } else {
        echo("Error: You must provide either r or both r1 and r2.");
    }
}