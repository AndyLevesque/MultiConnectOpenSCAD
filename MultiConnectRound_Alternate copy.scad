/*Created by Andy Levesque
Credit to @David D on Printables and Jonathan at Keep Making for Multiconnect and Multiboard, respectively
Licensed Creative Commons 4.0 Attribution Non-Commercial Sharable with Attribution
*/

/*[Parameters]*/
//diameter (in mm) of the item you wish to insert (this becomes the internal diameter)
itemDiameter = 25;
//thickness (in mm) of the wall surrounding the item
rimThickness = 1;
//Thickness (in mm) of the base underneath the item you are holding
baseThickness = 3;
//Additional thickness of the area between the item holding and the backer.
shelfSupportHeight = 0;
//Angle for items
itemAngle = 15; //[0:1:60]
//Additional height (in mm) of the rim protruding upward to hold the item
rimHeight = 10;
//Additional Backer Height (in mm) in case you prefer additional support for something heavy
additionalBackerHeight = 0;
//number of items you wish to hold width-wise (along the back)
itemsWide = 3;
//number of items you wish to hold depth-wise (away from back)
itemsDeep = 3;
//item row offset
tierOffestZ = itemDiameter/2;

/* [Slot Customization] */
//Distance between Multiconnect slots on the back (25mm is standard for MultiBoard)
distanceBetweenSlots = 25;
//QuickRelease removes the small indent in the top of the slots that lock the part into place
slotQuickRelease = false;
//Dimple scale tweaks the size of the dimple in the slot for printers that need a larger dimple to print correctly
dimpleScale = 1; //[0.5:.05:1.5]
//Scale of slots in the back (1.015 scale is default per MultiConnect specs)
slotTolerance = 1.015; //[1.0:0.005:1.025]

/*[Hidden]*/
//fit items plus 
totalWidth = itemDiameter*itemsWide + rimThickness*itemsWide + rimThickness;
totalHeight = max(baseThickness+itemsDeep*tierOffestZ,25);
rowDepth = itemDiameter+rimThickness*2;
//inputs the row depth and desired angle to calculate the height of the back
rowBackHeight = rowDepth * tan(itemAngle);

//Thickness of the back of the item (default in 6.5mm). Changes are untested. 
backThickness = 6.5; //.1
//slot count calculates how many slots can fit on the back. Based on internal width for buffer.
slotCount = floor(max(distanceBetweenSlots,totalWidth)/distanceBetweenSlots);
echo(str("Slot Count: ",slotCount));
backWidth = max(distanceBetweenSlots,totalWidth);

//start build
    back(backWidth = backWidth, backHeight = totalHeight+additionalBackerHeight, backThickness = backThickness);
    //number of items wide plus room between each
    //create shelf once per row
    for(itemY = [0:1:itemsDeep-1]){
            echo(str("Shelf: ", itemY));
            translate(v = [totalWidth,0,0]) rotate([180,-90,180])  linear_extrude(height = totalWidth) polygon(points = [[0,0],[rowBackHeight+(itemsDeep-itemY)*tierOffestZ,0],[(itemsDeep-itemY)*tierOffestZ,rowDepth],[0,rowDepth]]);
            translate(v = [0,itemY*rowDepth,0]) 
                cube(size = [totalWidth, rowDepth,(itemsDeep-itemY)*tierOffestZ]);
    }
    //create cylinder delete tools
    for(itemY = [0:1:itemsDeep-1]){
        rotate(a = [-itemAngle,0,0]) cube(size = [totalWidth, rowDepth,(itemsDeep-itemY)*tierOffestZ]);
        for (itemX = [0:1:itemsWide-1]){
            color(c = "red") rotate([-itemAngle,0,0]) translate(v = [itemDiameter/2+rimThickness + (itemX*itemDiameter+rimThickness*itemX),itemDiameter/2+rowDepth*itemY+rimThickness,baseThickness+(itemsDeep-itemY-1)*tierOffestZ]) cylinder(h = rimHeight*2, r = itemDiameter/2);
        }
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
module slotTool(productHeight) {
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
                linear_extrude(height = productHeight+1) 
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
