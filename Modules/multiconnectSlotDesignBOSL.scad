/*This file is the master copy of the multiconnect slot back. 
All components of this file are required in any file using this backer
*/

include <BOSL2/std.scad>

totalWidth = 50;
totalHeight = 75;

/*[Slot Customization]*/
//Slot type. Backer is for vertical mounting. Passthru for horizontal mounting.
slotType = "Backer"; //[Backer, Passthru]
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
onRampEveryNSlots = 1;
//move the start of the series of on-ramps n number of slots down
onRampOffsetNSlots = 0;
//move the start of the slots (in mm) up (positive) or down (negative)
slotVerticalOffset = 2.85;
//DOES NOT YET WORK - Only applies to passthru - change slot orientation
slotOrientation = "Vertical"; //["Horizontal", "Vertical"]
//Only applies to passthru - set distance (in mm) inward from the start if the set. 0 = middle of slot. 
dimpleInset = 0;


/* [Hidden] */

//multiconnectBack(backWidth = 100, backHeight = 100, distanceBetweenSlots = distanceBetweenSlots);

multiconnectBacker(width = totalWidth, height = totalHeight, slotType = slotType, slotDimple = !slotQuickRelease, dimpleScale = dimpleScale, anchor=BOTTOM+BACK, slotOrientation=slotOrientation);

//BEGIN MODULES
module multiconnectBacker(width, height, slotType = "Backer", distanceBetweenSlots = 25, onRampEnabled = true, onRampEveryNSlots = 1, onRampOffsetNSlots = 0, scale = 1, slotVerticalOffset = 2.85, backerThickness = 6.5, slotOrientation = "Vertical", slotDimple = true, dimpleScale = 1, anchor=CENTER, spin=0, orient=UP){
    attachable(anchor, spin, orient, size=[width, 6.5, height]*slotTolerance){ 
    //Backer type
    if (slotType == "Backer"){
        diff("remove"){
        cuboid([width, 6.5, height]);
        xcopies(n = floor(width/distanceBetweenSlots), spacing = distanceBetweenSlots)
            tag("remove") 
                down(13-10.15)attach(TOP, TOP, inside=true, align=FRONT, shiftout=0.01) multiconnectRoundedEnd(scale= slotTolerance, anchor=BOT+BACK)
                    attach(BOT, TOP) multiconnectSlot(length = height, onRampEnabled = onRampEnabled, onRampEveryNSlots = onRampEveryNSlots, onRampOffsetNSlots = onRampOffsetNSlots, anchor=FRONT)
            if (slotDimple)  tag("keep") back(4.15)  up(1.5*dimpleScale) attach(FRONT, BOT, align=TOP) cylinder(h = 1.5*dimpleScale, r1 = 1.5*dimpleScale, r2 = 0, $fn = 50);
        }
    }
    //Passthru type
    else {
        diff("remove"){
                cuboid([width, 6.5, height]){
                if (slotOrientation == "Vertical") {
                    xcopies(n = floor(width/distanceBetweenSlots), spacing = distanceBetweenSlots)
                        tag("remove") 
                            attach(TOP, TOP, inside=true, align=FRONT, shiftout = 0.01) multiconnectSlot(length = height, onRampEnabled = false, onRampEveryNSlots = onRampEveryNSlots, onRampOffsetNSlots = onRampOffsetNSlots, anchor=FRONT)
                        if (slotDimple)  tag("keep") back(4.15)  down(dimpleInset == 0 ? height/2-1.5 : dimpleInset-1.5) attach(FRONT, BOT, align=TOP) cylinder(h = 1.5*dimpleScale, r1 = 1.5*dimpleScale, r2 = 0, $fn = 50);
                }
                else { 
                    zcopies(n = floor(height/distanceBetweenSlots), spacing = distanceBetweenSlots)
                    tag("remove") 
                        attach(LEFT, TOP, inside=true, align=FRONT, shiftout = 0.01) back(10.15)multiconnectSlot(length = width+1, onRampEnabled = false, onRampEveryNSlots = onRampEveryNSlots, onRampOffsetNSlots = onRampOffsetNSlots, anchor=FRONT, spin=90)
                    if (slotDimple)  tag("keep") back(4.15)  down(dimpleInset == 0 ? width/2-1.5 : dimpleInset-1.5) attach(FRONT, BOT, align=TOP) cylinder(h = 1.5*dimpleScale, r1 = 1.5*dimpleScale, r2 = 0, $fn = 50);
                }
                }
            }
    }
        children();
    }
}
/*
module multiconnectPassthru(width, height, distanceBetweenSlots = 25, onRampEnabled = false, onRampEveryNSlots = 1, onRampOffsetNSlots = 0, scale = 1, backerThickness = 6.5, slotDimple = true, dimpleScale = 1, dimpleInset = 0, anchor=CENTER, spin=0, orient=UP){
    attachable(anchor, spin, orient, size=[width, 6.5, height]*slotTolerance){ 
            diff("remove"){
                cuboid([width, 6.5, height]);
                xcopies(n = floor(width/distanceBetweenSlots), spacing = distanceBetweenSlots)
                    tag("remove") 
                        attach(TOP, TOP, inside=true, align=FRONT, shiftout = 0.01) multiconnectSlot(length = height, onRampEnabled = false, onRampEveryNSlots = onRampEveryNSlots, onRampOffsetNSlots = onRampOffsetNSlots, anchor=FRONT)
                    //if (slotDimple)  tag("keep") back(4.15)  down(height/2-1.5-dimpleInset) attach(FRONT, BOT, align=TOP) cylinder(h = 1.5*dimpleScale, r1 = 1.5*dimpleScale, r2 = 0, $fn = 50);
                    if (slotDimple)  tag("keep") back(4.15)  down(dimpleInset == 0 ? height/2-1.5 : dimpleInset-1.5) attach(FRONT, BOT, align=TOP) cylinder(h = 1.5*dimpleScale, r1 = 1.5*dimpleScale, r2 = 0, $fn = 50);
            }
        children();
    }
}
*/
//round top
module multiconnectRoundedEnd(scale=1, anchor=CENTER, spin=0, orient=UP){
    attachable(anchor, spin, orient, size=[10.15*2,4.15,10.15]*scale){
        scale(scale)
        down(10.15/2) back(4.15/2)
            //top_half()
                rotate(a = [90,0,0,]) 
                    rotate_extrude($fn=50) 
                        polygon(points = [[0,0],[10.15,0],[10.15,1.2121],[7.65,3.712],[7.65,4.15],[0,4.15]]);
        children();
    }
}

//long slot
module multiconnectSlot(length, distanceBetweenSlots = 25, onRampEnabled = true, onRampEveryNSlots = 1, onRampOffsetNSlots = 0, scale = 1, anchor=CENTER, spin=0, orient=UP){
    
   attachable(anchor, spin, orient, size=[10.15*2,4.15,length]*scale){
        up(length/2) back(4.15/2) scale(scale)
        intersection() {
            union(){
                rotate(a = [180,0,0]) 
                    linear_extrude(height = length) 
                        union(){
                            polygon(points = [[0,0],[10.15,0],[10.15,1.2121],[7.65,3.712],[7.65,4.15],[0,4.15]]);
                                mirror([1,0,0])
                                    polygon(points = [[0,0],[10.15,0],[10.15,1.2121],[7.65,3.712],[7.65,4.15],[0,4.15]]);
                        }
                //onramp
                if(onRampEnabled && onRampEveryNSlots != 0) {
                        zcopies(spacing=-distanceBetweenSlots*onRampEveryNSlots, n=length/distanceBetweenSlots/onRampEveryNSlots+1, sp=[0,0,-distanceBetweenSlots-onRampOffsetNSlots*distanceBetweenSlots]) 
                            fwd(4.15/2) color("orange") 
                                cyl(h = 4.15, r1 = 12, r2 = 10.15, spin=([90,0,180]));
                }
                
            }
            //lop off any extra zcopies pieces
            cuboid([25,25, length], anchor=TOP);
        }
        children();
    }
}

