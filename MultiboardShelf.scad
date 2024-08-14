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
internalDepth = 40.0; //.1

/* [Shelf Customizations] */
//Distance upward from the bottom (in mm) that captures the bottom front of the item
rimHeight = 3;
bracket_style = "45deg"; //[45deg,half_distance,none]

/* [Additional Customization] */
//Thickness of bin walls (in mm)
wallThickness = 3; //.1
//Thickness of bin  (in mm)
baseThickness = 3; //.1

/*[Slot Customization]*/
//Distance between Multiconnect slots on the back (25mm is standard for MultiBoard)
distanceBetweenSlots = 25;
//QuickRelease removes the small indent in the top of the slots that lock the part into place
slotQuickRelease = false;
//Dimple scale tweaks the size of the dimple in the slot for printers that need a larger dimple to print correctly
dimpleScale = 1; //[0.5:.05:1.5]

/* [Hidden] */
//Thickness of the back of the item (default in 6.5mm). Changes are untested. 
backThickness = 6.5; //.1
//Scale of slots in the back (1.015 scale is default per MultiConnect specs)
slotTolerance = 1.015; //[1.0:0.005:1.025]

//Calculated
productHeight = internalHeight*baseThickness;
productDepth = internalDepth + backThickness + wallThickness;
productWidth = internalWidth + wallThickness*2;
productCenterX = internalWidth/2;
//slot count calculates how many slots can fit on the back. Based on internal width for buffer.
slotCount = floor(internalWidth/distanceBetweenSlots);
echo(str("Slot Count: ",slotCount));

//move to center
translate(v = [-productWidth/2+wallThickness,0,0]) 
    //Basket minus slots
    difference() {
        shelf();
        //Loop through slots and center on the item
        //Note: I kept doing math until it looked right. It's possible this can be simplified.
        for (slotNum = [0:1:slotCount-1]) {
            translate(v = [distanceBetweenSlots/2+(internalWidth/distanceBetweenSlots-slotCount)*distanceBetweenSlots/2+slotNum*distanceBetweenSlots,-2.575,internalHeight-13]) {
                slotTool();
            }
        }
                    //delete tool for anything above the product (i.e., bracket fix)
            color("red") translate(v = [-wallThickness-1 ,-1,internalHeight]) cube([productWidth+2,productDepth+2,productHeight]); 
    }

//Create Basket
module shelf() {
    union() {
        //back
        translate([-wallThickness,-backThickness,-baseThickness]){
                cube([internalWidth + (wallThickness*2), backThickness, (internalHeight)+baseThickness]);}

        //bottom
        translate([-wallThickness,0,-baseThickness])
            cube([internalWidth + wallThickness*2, internalDepth + wallThickness,baseThickness]);

        //left wall
        translate([-wallThickness,0,0])
            cube([wallThickness, internalDepth + wallThickness, rimHeight]);

        //right wall
        translate([internalWidth,0,0])
            cube([wallThickness, internalDepth + wallThickness, rimHeight]);

        //front wall
        translate([0,internalDepth,0]) 
            cube([internalWidth,wallThickness,rimHeight]);

        bracketDistance = min(internalHeight/2,internalDepth/2);
        echo(str("Bracket Distance: ",bracketDistance));
        
        //shelf brackets      
        if (bracket_style == "half_distance") {
            translate(v = [0,0,internalHeight/2+rimHeight])
                shelfBracket(bracketHeight = internalHeight/2, bracketDepth = internalDepth/2);
            translate(v = [internalWidth+wallThickness,0,internalHeight/2+rimHeight])
                shelfBracket(bracketHeight = internalHeight/2, bracketDepth = internalDepth/2);
        }
        if (bracket_style == "45deg"){
            translate(v = [0,0,bracketDistance+rimHeight])
                shelfBracket(bracketHeight = bracketDistance, bracketDepth = bracketDistance);
            translate(v = [internalWidth+wallThickness,0,bracketDistance+rimHeight])
                shelfBracket(bracketHeight = bracketDistance, bracketDepth = bracketDistance);
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
                linear_extrude(height = internalHeight+1) 
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

module shelfBracket(bracketHeight, bracketDepth){
        rotate(a = [-90,0,90]) 
            linear_extrude(height = wallThickness) 
                polygon([[0,0],[0,bracketHeight],[bracketDepth,bracketHeight]]);
}