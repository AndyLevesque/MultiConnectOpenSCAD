//Size of the item to hold
itemHeight = 102.4; //50
itemWidth = 32.8;
itemDepth = 10.5; 
//Customization
bottomCapture = 7;
sideCapture = 3;
wallThickness = 2;
//The percent of the item you would like the box to hold (e.g., .66 means the holder will reach 2/3 up the part)
heightRatio = .66; //[0.1:0.05:1.0]
//Standard
backThickness = 6.5;
//Calculated
productHeight = itemHeight*heightRatio+wallThickness;
productDepth = itemDepth + backThickness + wallThickness;
productWidth = itemWidth + wallThickness*2;
productCenterX = itemWidth/2;
slotCount = floor(itemWidth/25);
echo(str("Slot Count: ",slotCount));

//Slot Dimensions
distanceBetweenSlots = 25;
slotTolerance = 0.15;

//other helpful variables

//itemRender
%color("blue") cube([itemWidth, itemDepth, itemHeight]);

//Basket minus slots
difference() {
    basket();
    //Loop through slots and center
    for (slotNum = [0:1:slotCount-1]) {
        translate(v = [slotNum*25+distanceBetweenSlots/2+(itemWidth/25-slotCount)*25/2,-2.575,itemHeight*heightRatio-13]) {
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
    scale(v = 1.015) //scale for 0.15mm tolerance per Multiconnect design specs
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