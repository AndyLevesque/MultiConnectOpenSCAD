/* [Item Size] */
//Height (in mm) of the item you wish to hold
itemHeight = 100.0; //.1
//Width (in mm) of the item you wish to hold
itemWidth = 40.0; //.1
//Depth (i.e., distance from back) (in mm) of the item you wish to hold
itemDepth = 10.0; //.1
//Height of bottom lip (in mm) that captures the bottom front of the item

/* [Additional Customization] */
bottomCapture = 7;
//Distance inward from the sides (in mm) that captures the sides of the item
sideCapture = 3;
//Thickness of the walls surrounding the item (default 2mm)
wallThickness = 2; //.1
//The percent of the item you would like the box to hold (e.g., .60 means the holder will hold 60% up the part and 40% will stick out the top)
heightRatio = .60; //[0.1:0.05:1.0]
//Distance between Multiconnect slots on the back (25mm is standard for MultiBoard)
distanceBetweenSlots = 25;

/* [Untested Modifications] */
//Thickness of the back of the item (default in 6.5mm). Changes are untested. 
backThickness = 6.5; //.1
//Scale of slots in the back (1.015 scale is default per MultiConnect specs)
slotTolerance = 1.015; //[1.0:0.005:1.025]

//Calculated
productHeight = itemHeight*heightRatio+wallThickness;
productDepth = itemDepth + backThickness + wallThickness;
productWidth = itemWidth + wallThickness*2;
productCenterX = itemWidth/2;
slotCount = floor(itemWidth/distanceBetweenSlots);
echo(str("Slot Count: ",slotCount));

//itemRender
%color("blue") cube([itemWidth, itemDepth, itemHeight]);

//Basket minus slots
difference() {
    basket();
    //Loop through slots and center on the item
    //Thoughts behind x positioning calculation: increment by 
    for (slotNum = [0:1:slotCount-1]) {
        translate(v = [distanceBetweenSlots/2+(itemWidth/distanceBetweenSlots-slotCount)*distanceBetweenSlots/2+slotNum*distanceBetweenSlots,-2.575,itemHeight*heightRatio-13]) {
            slotTool();
        }
    }
}

//Create Basket
module basket() {
    union() {
        //back
        translate([-wallThickness,-backThickness,-wallThickness]){
                cube([itemWidth + (wallThickness*2), backThickness, (    itemHeight*heightRatio)+wallThickness]);}

        //bottom
        translate([-wallThickness,0,-wallThickness]){
            cube([itemWidth + wallThickness*2, itemDepth + wallThickness,wallThickness]);
        }

        //left wall
        translate([-wallThickness,0,0]){
        cube([wallThickness, itemDepth + wallThickness, itemHeight*heightRatio]);
        }

        //right wall
        translate([itemWidth,0,0]){
        cube([wallThickness, itemDepth + wallThickness, itemHeight*heightRatio]);
        }

        difference() {
        //frontCapture
            translate([0,itemDepth,0]){ 
                cube([itemWidth,wallThickness,itemHeight*heightRatio]);
            }

        //frontCaptureDeleteTool
            translate([sideCapture,itemDepth-1,bottomCapture]){ 
                color("red") cube([itemWidth-sideCapture*2,wallThickness+2,itemHeight*heightRatio-bottomCapture+1]);
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
                linear_extrude(height = itemHeight*heightRatio+1) 
                    union(){
                        polygon(points = [[0,0],[10,0],[10,1],[7.5,3.5],[7.5,4],[0,4]]);
                        mirror([1,0,0])
                            polygon(points = [[0,0],[10,0],[10,1],[7.5,3.5],[7.5,4],[0,4]]);
                    }
        }
        //dimple
        rotate(a = [90,0,0,]) 
            rotate_extrude($fn=50) 
                polygon(points = [[0,0],[0,1.5],[1.5,0]]);
}
  
}