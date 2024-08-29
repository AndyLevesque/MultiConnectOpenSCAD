include <BOSL2/std.scad>

/*Created by Andy Levesque
Credit to @David D on Printables and Jonathan at Keep Making for Multiconnect and Multiboard, respectively
Licensed Creative Commons 4.0 Attribution Non-Commercial Sharable with Attribution
*/

/*[Standard Parameters]*/
//Depth of shelf (in multiboard units) from front to back 
shelfDepthUnits = 7;
//Width of shelf (in multiboard units of 25mm each) from left to right 
shelfWidthUnits = 7;
//internal height of shelf (in mm)
shelfHeight = 20;//5
baseThickness = 1.5;

/*[Hidden]*/
//wallThickness - need to figure out how to handle differing wall thicknesses without throwing off 25mm mounting increments
wallThickness = 1.5; 
//Lateral protrusion of the slide mechanism. Shelf measurement must match slides measurement
slideDepth = 7.5;
unitsInMM = 25;
depthInMM = shelfDepthUnits*unitsInMM;
widthInMM = shelfWidthUnits*unitsInMM;

/*[Slot Customization]*/
//Distance between Multiconnect slots on the back (25mm is standard for MultiBoard)
distanceBetweenSlots = 25;
//QuickRelease removes the small indent in the top of the slots that lock the part into place
slotQuickRelease = false;
//Dimple scale tweaks the size of the dimple in the slot for printers that need a larger dimple to print correctly
dimpleScale = 1; //[0.5:.05:1.5]
//Scale the size of slots in the back (1.015 scale is default for a tight fit. Increase if your finding poor fit. )
slotTolerance = 1.00; //[0.925:0.005:1.075]
//Move the slot in (positive) or out (negative)
slotDepthMicroadjustment = 0; //[-.5:0.05:.5]
//enable a slot on-ramp for easy mounting of tall items
onRampEnabled = true;
//frequency of slots for on-ramp. 1 = every slot; 2 = every 2 slots; etc.
onRampEveryXSlots = 2;

//drawer
rect_tube(size=[shelfWidthUnits*25,shelfDepthUnits*25], wall=wallThickness, h=shelfHeight){
    attach([LEFT, RIGHT], BOT, align=TOP) prismoid(size1=[shelfDepthUnits*25,slideDepth*2], size2=[shelfDepthUnits*25,0], h=slideDepth);
    attach(BOT) cuboid([shelfWidthUnits*25,shelfDepthUnits*25,baseThickness]);
}

//slides
translate(v = [shelfWidthUnits*25/2 + 20,0,slideDepth]) 
diff("remove"){
    cuboid(size = [10,depthInMM,slideDepth*2]){
        attach([LEFT], BOT, align=TOP, inside=true, shiftout=0.01) prismoid(size1=[shelfDepthUnits*25,slideDepth*2+1], size2=[shelfDepthUnits*25+1,0], h=slideDepth);
    }
}

translate(v = [widthInMM/2+20+25/2,depthInMM/2,slideDepth*2]) rot([-90, 0, 180])  multiconnectBack(backWidth = 25, backHeight = depthInMM, distanceBetweenSlots = distanceBetweenSlots) show_anchors();


//BEGIN MODULES
//Slotted back Module
module multiconnectBack(backWidth, backHeight, distanceBetweenSlots, anchor=CENTER, spin=0, orient=UP)
{
    //slot count calculates how many slots can fit on the back. Based on internal width for buffer. 
    //slot width needs to be at least the distance between slot for at least 1 slot to generate
    let (backWidth = max(backWidth,distanceBetweenSlots), backHeight = max(backHeight, 25),slotCount = floor(backWidth/distanceBetweenSlots), backThickness = 6.5){
        diff() {
            translate(v = [0,-backThickness,0]) cube(size = [backWidth,backThickness,backHeight]);
            //Loop through slots and center on the item
            //Note: I kept doing math until it looked right. It's possible this can be simplified.
            for (slotNum = [0:1:slotCount-1]) {
                translate(v = [distanceBetweenSlots/2+(backWidth/distanceBetweenSlots-slotCount)*distanceBetweenSlots/2+slotNum*distanceBetweenSlots,-2.35+slotDepthMicroadjustment,backHeight-13]) {
                    color(c = "red")  slotTool(backHeight);
                }
            }
        }
    }
    //Create Slot Tool
    module slotTool(totalHeight) {
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
                        translate(v = [0,-5,-y*distanceBetweenSlots]) 
                            rotate(a = [-90,0,0]) 
                                color(c = "orange") cylinder(h = 5, r1 = 12, r2 = 10.15);
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