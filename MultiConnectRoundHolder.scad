/*Created by Andy Levesque
Credit to @David D on Printables and Jonathan at Keep Making for Multiconnect and Multiboard, respectively
Licensed Creative Commons 4.0 Attribution Non-Commercial Sharable with Attribution
*/

/*[Parameters]*/
itemDiameter = 25;
rimThickness = 1;
rimHeight = 7;
baseThickness = 1.5;

/* [Slot Customization] */
//Distance between Multiconnect slots on the back (25mm is standard for MultiBoard)
distanceBetweenSlots = 25;
//QuickRelease removes the small indent in the top of the slots that lock the part into place
slotQuickRelease = false;
//Dimple scale tweaks the size of the dimple in the slot for printers that need a larger dimple to print correctly
dimpleScale = 1; //[0.5:.05:1.5]

/*[Hidden]*/
totalWidth = itemDiameter + rimHeight*2;
totalHeight = max(baseThickness+rimHeight,25);

//Thickness of the back of the item (default in 6.5mm). Changes are untested. 
backThickness = 6.5; //.1
//Scale of slots in the back (1.015 scale is default per MultiConnect specs)
slotTolerance = 1.015; //[1.0:0.005:1.025]
//slot count calculates how many slots can fit on the back. Based on internal width for buffer.
slotCount = floor(max(distanceBetweenSlots,totalWidth)/distanceBetweenSlots);
echo(str("Slot Count: ",slotCount));
backWidth = max(distanceBetweenSlots,totalWidth);


//start build
back(backWidth = backWidth, backHeight = totalHeight, backThickness = backThickness);

difference() {
    //itemwalls
    hull(){
    translate(v = [totalWidth/2,itemDiameter/2,0]) 
        linear_extrude(height = rimHeight+baseThickness) 
                circle(r = itemDiameter/2+rimThickness);
        linear_extrude(height = rimHeight+baseThickness) 
                square(size = [totalWidth,1]);
    }
    //itemDiameter (i.e., delete tool)
    color(c = "red") translate(v = [totalWidth/2,itemDiameter/2,+baseThickness]) linear_extrude(height = rimHeight+1) circle(r = itemDiameter/2);
}
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