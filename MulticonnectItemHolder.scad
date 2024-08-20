/*Created by Andy Levesque
Credit to @David D on Printables and Jonathan at Keep Making for Multiconnect and Multiboard, respectively
Licensed Creative Commons 4.0 Attribution Non-Commercial Sharable with Attribution
*/

/* [Internal Dimensions] */
//Height (in mm) from the top of the back to the base of the internal floor
internalHeight = 50.0; //.1
//Width (in mm) of the internal dimension or item you wish to hold
internalWidth = 50.0; //.1
//Length (i.e., distance from back) (in mm) of the internal dimension or item you wish to hold
internalDepth = 15.0; //.1

/* [Front Cutout Customizations] */
frontCutout = false; 
//Distance upward from the bottom (in mm) that captures the bottom front of the item
frontVerticalCapture = 7;
//Distance inward from the sides (in mm) that captures the sides of the item
frontLateralCapture = 3;
//Thickness of the walls surrounding the item (default 2mm)

/* [Right Cutout Customizations] */
rightCutout = true; 
//Distance upward from the bottom (in mm) that captures the bottom front of the item
rightVerticalCapture = 7;
//Distance inward from the sides (in mm) that captures the sides of the item
rightLateralCapture = 3;
//Thickness of the walls surrounding the item (default 2mm)

/* [Left Cutout Customizations] */
leftCutout = true; 
//Distance upward from the bottom (in mm) that captures the bottom front of the item
leftVerticalCapture = 7;
//Distance inward from the sides (in mm) that captures the sides of the item
leftLateralCapture = 3;
//Thickness of the walls surrounding the item (default 2mm)

/* [Additional Customization] */
//Thickness of bin walls (in mm)
wallThickness = 2; //.1
//Thickness of bin  (in mm)
baseThickness = 3; //.1

/*[Slot Customization]*/
//Distance between Multiconnect slots on the back (25mm is standard for MultiBoard)
distanceBetweenSlots = 25;
//QuickRelease removes the small indent in the top of the slots that lock the part into place
slotQuickRelease = false;
//Dimple scale tweaks the size of the dimple in the slot for printers that need a larger dimple to print correctly
dimpleScale = 1; //[0.5:.05:1.5]
//Scale of slots in the back (1.015 scale is default for a tight fit. Increase if your finding poor fit. )
slotTolerance = 1.015; //[1.0:0.005:1.025]

/* [Hidden] */
//Thickness of the back of the item (default in 6.5mm). Changes are untested. 
backThickness = 6.5; //.1


//Calculated
totalHeight = internalHeight+baseThickness;
totalDepth = internalDepth + backThickness + wallThickness;
totalWidth = max(internalWidth + wallThickness*2,25);
totalCenterX = internalWidth/2;
//slot count calculates how many slots can fit on the back. Based on internal width for buffer.
slotCount = floor(totalWidth/distanceBetweenSlots);
echo(str("Slot Count: ",slotCount));

//move to center
translate(v = [-internalWidth/2,0,0]) 
    basket();
    //slotted back
translate([-totalWidth/2,0,-baseThickness])
    back(backWidth = totalWidth, backHeight = totalHeight, backThickness = 6.5);

//Create Basket
module basket() {
    //difference() {
        union() {
            //bottom
            translate([-wallThickness,0,-baseThickness])
                cube([internalWidth + wallThickness*2, internalDepth + wallThickness,baseThickness]);

            //left wall
            translate([-wallThickness,0,0])
                cube([wallThickness, internalDepth + wallThickness, internalHeight]);

            //right wall
            translate([internalWidth,0,0])
                cube([wallThickness, internalDepth + wallThickness, internalHeight]);

            //front wall
                translate([0,internalDepth,0])
                    cube([internalWidth,wallThickness,internalHeight]);
        }

        //frontCaptureDeleteTool for item holders
            if (frontCutout == true)
                translate([frontLateralCapture,internalDepth-1,frontVerticalCapture]){ 
                    color("red") cube([internalWidth-frontLateralCapture*2,wallThickness+2,internalHeight-frontVerticalCapture+1]);
                }
                    //frontCaptureDeleteTool for item holders
            if (rightCutout == true)
                translate([-wallThickness-1,rightLateralCapture,rightVerticalCapture]){ 
                    color("green") cube([wallThickness+2,internalDepth-rightLateralCapture*2,internalHeight-rightVerticalCapture+1]);
                }
            if (leftCutout == true)
                translate([internalWidth-1,leftLateralCapture,leftVerticalCapture]){ 
                    color("blue") cube([wallThickness+2,internalDepth-leftLateralCapture*2,internalHeight-leftVerticalCapture+1]);
                }
    //}
}


//BEGIN MODULES
//Slotted back
module back(backWidth, backHeight, backThickness)
{
    difference() {
        translate(v = [0,-backThickness,0]) cube(size = [backWidth,backThickness,backHeight]);
        //Loop through slots and center on the item
        //Note: I kept doing math until it looked right. It's possible this can be simplified.
        for (slotNum = [0:1:slotCount-1]) {
            translate(v = [distanceBetweenSlots/2+(backWidth/distanceBetweenSlots-slotCount)*distanceBetweenSlots/2+slotNum*distanceBetweenSlots,-2.575,backHeight-13]) {
                color(c = "red")  slotTool(backHeight);
            }
        }
    }
}
//Create Slot Tool
module slotTool(totalHeight) {
    //translate(v = [0,-0.075,0]) //removed for redundancy
    scale(v = slotTolerance) //scale for 0.15mm tolerance per Multiconnect design specs
    difference() {
        union() {
            //round top
            rotate(a = [90,0,0,]) 
                rotate_extrude($fn=50) 
                    polygon(points = [[0,0],[10,0],[10,1],[7.5,3.5],[7.5,4],[0,4]]);
            //long slot
            translate(v = [0,0,0]) 
                rotate(a = [180,0,0]) 
                linear_extrude(height = totalHeight+1) 
                    union(){
                        polygon(points = [[0,0],[10,0],[10,1],[7.5,3.5],[7.5,4],[0,4]]);
                        mirror([1,0,0])
                            polygon(points = [[0,0],[10,0],[10,1],[7.5,3.5],[7.5,4],[0,4]]);
                    }
        }
        //dimple
        if (slotQuickRelease == false)
            scale(v = dimpleScale) 
            rotate(a = [90,0,0,]) 
                rotate_extrude($fn=50) 
                    polygon(points = [[0,0],[0,1.5],[1.5,0]]);
    }
}