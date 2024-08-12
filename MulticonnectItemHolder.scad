/* [Bin Type] */
//Item Type - Bin (or "bin") with all sides equal height vs Item Holder with an open front. Shelf not yet used.
binType = "Bin"; //[Bin,Item Holder,Shelf]

/* [Internal Dimensions] */
//Height (in mm) from the top of the back to the base of the internal floor
internalDepth = 100.0; //.1
//Width (in mm) of the internal dimension or item you wish to hold
internalWidth = 40.0; //.1
//Length (i.e., distance from back) (in mm) of the internal dimension or item you wish to hold
internalLength = 10.0; //.1

/* [Item Holder Customizations] */
//Distance upward from the bottom (in mm) that captures the bottom front of the item
bottomCapture = 7;
//Distance inward from the sides (in mm) that captures the sides of the item
sideCapture = 3;
//Thickness of the walls surrounding the item (default 2mm)

/* [Shelf] */
//Distance upward from the bottom (in mm) that captures the bottom front of the item
rimHeight = 7;

/* [Additional Customization] */
//Thickness of bin walls (in mm)
wallThickness = 2; //.1
//Thickness of bin  (in mm)
baseThickness = 3; //.1
//Distance between Multiconnect slots on the back (25mm is standard for MultiBoard)
distanceBetweenSlots = 25;
//QuickRelease removes the small indent in the top of the slots that lock the part into place
slotQuickRelease = false;

/* [Hidden] */
//Thickness of the back of the item (default in 6.5mm). Changes are untested. 
backThickness = 6.5; //.1
//Scale of slots in the back (1.015 scale is default per MultiConnect specs)
slotTolerance = 1.015; //[1.0:0.005:1.025]

//Calculated
productDepth = internalDepth*baseThickness;
productLength = internalLength + backThickness + wallThickness;
productWidth = internalWidth + wallThickness*2;
productCenterX = internalWidth/2;
slotCount = floor(internalWidth/distanceBetweenSlots);
echo(str("Slot Count: ",slotCount));

//itemRender
if(binType == "Item Holder" ) %color("blue") cube([internalWidth, internalLength, internalDepth]);

//move to center
translate(v = [-productWidth/2+wallThickness,0,0]) 
//Basket minus slots
difference() {
    basket();
    //Loop through slots and center on the item
    //Thoughts behind x positioning calculation: increment by 
    for (slotNum = [0:1:slotCount-1]) {
        translate(v = [distanceBetweenSlots/2+(internalWidth/distanceBetweenSlots-slotCount)*distanceBetweenSlots/2+slotNum*distanceBetweenSlots,-2.575,internalDepth-13]) {
            slotTool();
        }
    }
}

//Create Basket
module basket() {
    union() {
        //back
        translate([-wallThickness,-backThickness,-baseThickness]){
                cube([internalWidth + (wallThickness*2), backThickness, (internalDepth)+baseThickness]);}

        //bottom
        translate([-wallThickness,0,-baseThickness]){
            cube([internalWidth + wallThickness*2, internalLength + wallThickness,baseThickness]);
        }

        //left wall
        translate([-wallThickness,0,0]){
            if (binType == "Shelf") cube([wallThickness, internalLength + wallThickness, rimHeight]);
            else cube([wallThickness, internalLength + wallThickness, internalDepth]);
        }

        //right wall
        translate([internalWidth,0,0]){
            if (binType == "Shelf") cube([wallThickness, internalLength + wallThickness, rimHeight]);
            else cube([wallThickness, internalLength + wallThickness, internalDepth]);

        }

        difference() {
        //frontCapture
            translate([0,internalLength,0]){ 
                if (binType == "Shelf") cube([internalWidth,wallThickness,rimHeight]);
                else cube([internalWidth,wallThickness,internalDepth]);

            }

        //frontCaptureDeleteTool for item holders
            if (binType == "Item Holder")
                translate([sideCapture,internalLength-1,bottomCapture]){ 
                    color("red") cube([internalWidth-sideCapture*2,wallThickness+2,internalDepth-bottomCapture+1]);
                }
        }
    }
}


//Create Slot Tool
module slotTool() {
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
                linear_extrude(height = internalDepth+1) 
                    union(){
                        polygon(points = [[0,0],[10,0],[10,1],[7.5,3.5],[7.5,4],[0,4]]);
                        mirror([1,0,0])
                            polygon(points = [[0,0],[10,0],[10,1],[7.5,3.5],[7.5,4],[0,4]]);
                    }
        }
        //dimple
        if (slotQuickRelease == false)
            rotate(a = [90,0,0,]) 
                rotate_extrude($fn=50) 
                    polygon(points = [[0,0],[0,1.5],[1.5,0]]);
}
  
}