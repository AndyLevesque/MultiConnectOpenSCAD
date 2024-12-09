/*Created by Andy Levesque
Credit to @David D on Printables and Jonathan at Keep Making for Multiconnect and Multiboard, respectively
Licensed Creative Commons 4.0 Attribution Non-Commercial Sharable with Attribution

Documentation available at https://handsonkatie.com/underware-2-0-the-made-to-measure-collection/

Notes:
- Slot test fit - For a slot test fit, set the following parameters
    - internalDepth = 0
    - internalHeight = 25
    - internalWidth = 0
    - wallThickness = 0
*/

include <BOSL2/std.scad>
include <BOSL2/walls.scad>

/* [Internal Dimensions] */
//Height (in mm): internal dimension along the Z axis. Measured from the top to the base of the internal floor, equivalent to the height of the item you wish to hold
internalHeight = 50.0;
//Width (in mm): internal dimension along the X axis. Measured from left to right, equivalent to the width of the item you wish to hold
internalWidth = 50.0; 
//Length (in mm): internal dimension along the Y axis. Measured from the front to the back, equivalent to the thickness of the item you wish to hold
internalDepth = 15.0;

/*[Style Customizations]*/
//Edge rounding (in mm)
edgeRounding = 1.0; // [0:0.1:2]

/* [Front Cutout Customizations] */
//Cut out the front
frontCutout = true; 
//Distance upward (Z axis) from the bottom (in mm). This captures the bottom front of the item
frontLowerCapture = 7;
//Distance downward (Z axis) from the top (in mm). This captures the top front of the item. Use zero (0) for a cutout top. May require printing supports if used. 
frontUpperCapture = 0;
//Distance inward (X axis) from the sides (in mm) that captures the sides of the item
frontLateralCapture = 3;


/*[Bottom Cutout Customizations]*/
//Cut out the bottom 
bottomCutout = false;
//Distance inward (Y axis) from the front (in mm). This captures the bottom front of the item
bottomFrontCapture = 3;
//Distance inward (Y axis) from the back (in mm). That captures the bottom back of the item
bottomBackCapture = 3;
//Distance inward (X axis) from the sides (in mm) that captures the bottom side of the item
bottomSideCapture = 3;

/*[Cord Cutout Customizations]*/
//Cut out a slot on the bottom and through the front for a cord to connect to the device
cordCutout = false;
//Diameter/width of cord cutout
cordCutoutDiameter = 10;
//Move the cord cutout laterally (X axis), left is positive and right is negative (in mm)
cordCutoutLateralOffset = 0;
//Move the cord cutout depth (Y axis), forward is positive and back is negative (in mm)
cordCutoutDepthOffset = 0;

/* [Right Cutout Customizations] */
rightCutout = false; 
//Distance upward (Z axis) from the bottom (in mm) that captures the bottom right of the item
rightLowerCapture = 7;
//Distance downward (Z axis) from the top (in mm) that captures the top right of the item. Use zero (0) for a cutout top. May require printing supports if used. 
rightUpperCapture = 0;
//Distance inward (Y axis) from the sides (in mm) that captures the right sides of the item
rightLateralCapture = 3;


/* [Left Cutout Customizations] */
leftCutout = false; 
//Distance upward (Z axis) from the bottom (in mm) that captures the bottom left of the item
leftLowerCapture = 7;
//Distance downward (Z axis) from the top (in mm) that captures the top left of the item. Use zero (0) for a cutout top. May require printing supports if used. 
leftUpperCapture = 0;
//Distance inward (Y axis) from the sides (in mm) that captures the left sides of the item
leftLateralCapture = 3;


/* [Additional Customization] */
//Thickness of item holder walls (in mm)
wallThickness = 2; //.1
//Thickness of item holder base (in mm)
baseThickness = 3; //.1

/*[Slot Customization]*/
//Offset the multiconnect on-ramps to be between grid slots rather than on the slot
onRampHalfOffset = true;
//Change slot orientation, when enabled slots to come from the top of the back, when disabled slots come from the bottom
Slot_From_Top = true;
//Distance between Multiconnect slots on the back (25mm is standard for MultiBoard)
distanceBetweenSlots = 25;
//QuickRelease removes the small indent in the top of the slots that lock the part into place
slotQuickRelease = false;
//Dimple scale tweaks the size of the dimple in the slot for printers that need a larger dimple to print correctly
dimpleScale = 1; //[0.5:.05:1.5]
//Scale the size of slots in the back (1.015 scale is default for a tight fit. Increase if your finding poor fit. )
slotTolerance = 1.00; //[0.925:0.005:1.075]
//Move the slot (Y axis) inwards (positive) or outwards (negative)
slotDepthMicroadjustment = 0; //[-.5:0.05:.5]
//Enable a slot on-ramp for easy mounting of tall items
onRampEnabled = false;
//Frequency of slots for on-ramp. 1 = every slot; 2 = every 2 slots; etc.
onRampEveryXSlots = 1;

/* [Hidden] */

//Calculated
totalHeight = internalHeight+baseThickness;
totalDepth = internalDepth + wallThickness;
totalWidth = internalWidth + wallThickness*2;
totalCenterX = internalWidth/2;

//move to center
union(){
translate(v = [-internalWidth/2,0,0]) 
    basket();
    //slotted back
//translate([max(totalWidth,distanceBetweenSlots)/2,0.02,0])
    translate([0,0.02,totalHeight/2-baseThickness]) 
    rotate([0,Slot_From_Top ? 180 : 0,0])
    translate([-totalWidth/2,0,-totalHeight/2])//center
    multiconnectBack(backWidth = totalWidth, backHeight = totalHeight, distanceBetweenSlots = distanceBetweenSlots);
}

//Create Basket
module basket() {
    difference() {
        union() {
            //bottom
            translate([-wallThickness,0,-baseThickness])
                cuboid([internalWidth + wallThickness*2, internalDepth + wallThickness,baseThickness], anchor=FRONT+LEFT+BOT, rounding=edgeRounding, edges = [BOTTOM+LEFT,BOTTOM+RIGHT,BOTTOM+BACK,LEFT+BACK,RIGHT+BACK]);
            //left wall
            translate([-wallThickness,0,0])
                cuboid([wallThickness, internalDepth + wallThickness, internalHeight], anchor=FRONT+LEFT+BOT, rounding=edgeRounding, edges = [TOP+LEFT,TOP+BACK,BACK+LEFT]);
            //right wall
            translate([internalWidth,0,0])
                cuboid([wallThickness, internalDepth + wallThickness, internalHeight], anchor=FRONT+LEFT+BOT, rounding=edgeRounding, edges = [TOP+RIGHT,TOP+BACK,BACK+RIGHT]);
            //front wall
            translate([0,internalDepth,0])
                cuboid([internalWidth,wallThickness,internalHeight], anchor=FRONT+LEFT+BOT, rounding=edgeRounding, edges = [TOP+BACK]);
        }

        //frontCaptureDeleteTool for item holders
            if (frontCutout == true)
                translate([frontLateralCapture,internalDepth-1,frontLowerCapture])
                    cube([internalWidth-frontLateralCapture*2,wallThickness+2,internalHeight-frontLowerCapture-frontUpperCapture+0.01]);
            if (bottomCutout == true)
                translate(v = [bottomSideCapture,bottomBackCapture,-baseThickness-1]) 
                    cube([internalWidth-bottomSideCapture*2,internalDepth-bottomFrontCapture-bottomBackCapture,baseThickness+2]);
                    //frontCaptureDeleteTool for item holders
            if (rightCutout == true)
                translate([-wallThickness-1,rightLateralCapture,rightLowerCapture])
                    cube([wallThickness+2,internalDepth-rightLateralCapture*2,internalHeight-rightLowerCapture-rightUpperCapture+0.01]);
            if (leftCutout == true)
                translate([internalWidth-1,leftLateralCapture,leftLowerCapture])
                    cube([wallThickness+2,internalDepth-leftLateralCapture*2,internalHeight-leftLowerCapture-leftUpperCapture+0.01]);
            if (cordCutout == true) {
                translate(v = [internalWidth/2+cordCutoutLateralOffset,internalDepth/2+cordCutoutDepthOffset,-baseThickness-1]) {
                    union(){
                        cylinder(h = baseThickness + frontLowerCapture + 2, r = cordCutoutDiameter/2);
                        translate(v = [-cordCutoutDiameter/2,0,0]) cube([cordCutoutDiameter,internalWidth/2+wallThickness+1,baseThickness + frontLowerCapture + 2]);
                    }
                }
            }
    }
    
}


//BEGIN MODULES
//Slotted back Module
module multiconnectBack(backWidth, backHeight, distanceBetweenSlots)
{
    //slot count calculates how many slots can fit on the back. Based on internal width for buffer. 
    //slot width needs to be at least the distance between slot for at least 1 slot to generate
    let (backWidth = max(backWidth,distanceBetweenSlots), backHeight = max(backHeight, 25),slotCount = floor(backWidth/distanceBetweenSlots), backThickness = 6.5){
        difference() {
            translate(v = [0,-backThickness,0]) 
            cuboid(size = [backWidth,backThickness,backHeight], rounding=edgeRounding, except_edges=BACK, anchor=FRONT+LEFT+BOT);
            //Loop through slots and center on the item
            //Note: I kept doing math until it looked right. It's possible this can be simplified.
            for (slotNum = [0:1:slotCount-1]) {
                translate(v = [distanceBetweenSlots/2+(backWidth/distanceBetweenSlots-slotCount)*distanceBetweenSlots/2+slotNum*distanceBetweenSlots,-2.35+slotDepthMicroadjustment,backHeight-13]) {
                    slotTool(backHeight);
                }
            }
        }
    }
    //Create Slot Tool
    module slotTool(totalHeight) {
        //In slotTool, added a new variable distanceOffset which is set by the option:
        distanceOffset = onRampHalfOffset ? distanceBetweenSlots / 2 : 0;

        scale(v = slotTolerance)
        //slot minus optional dimple with optional on-ramp
        let (slotProfile = [[0,0],[10.15,0],[10.15,1.2121],[7.65,3.712],[7.65,5],[0,5]])
        difference() {
            union() {
                //round top
                rotate(a = [90,0,0,]) 
                    rotate_extrude($fn=50) 
                        polygon(points = slotProfile);
                //long slot
                translate(v = [0,0,0]) 
                    rotate(a = [180,0,0]) 
                    linear_extrude(height = totalHeight+1) 
                        union(){
                            polygon(points = slotProfile);
                            mirror([1,0,0])
                                polygon(points = slotProfile);
                        }
                //on-ramp
                if(onRampEnabled)
                    for(y = [1:onRampEveryXSlots:totalHeight/distanceBetweenSlots])
                        //then modify the translate within the on-ramp code to include the offset
                        translate(v = [0,-5,(-y*distanceBetweenSlots)+distanceOffset])
                            rotate(a = [-90,0,0]) 
                                cylinder(h = 5, r1 = 12, r2 = 10.15);
            }
            //dimple
            if (slotQuickRelease == false)
                scale(v = dimpleScale) 
                rotate(a = [90,0,0,]) 
                    rotate_extrude($fn=50) 
                        polygon(points = [[0,0],[0,1.5],[1.5,0]]);
        }
    }
}