/*Created by Andy Levesque
Credit to @David D on Printables and Jonathan at Keep Making for Multiconnect and Multiboard, respectively
Licensed Creative Commons 4.0 Attribution Non-Commercial Sharable with Attribution
*/

/*
TODO: 
    Important: Fix hull issue when angle is less than 20
    - Cap print angle to 45 when item angle exceeds 45
    - Separate distanceBetweenEach and front/back thickness
    - Fix backer height for high diameter items
    - Clean up unused parameters
*/

/*[Parameters]*/
//diameter (in mm) of the item you wish to insert (this becomes the internal diameter)
itemDiameter = 25;
//distance between each item (in mm)
distanceBetweenEach = 1;
//Thickness (in mm) of the base underneath the item you are holding
baseThickness = 3;
//Additional thickness of the area between the item holding and the backer.
shelfSupportHeight = 0;
//Angle for items
itemAngle = 30; //[0:1:60]
//Additional height (in mm) of the rim protruding upward to hold the item
holeDepth = 10;
//Additional Backer Height (in mm) in case you prefer additional support for something heavy
additionalBackerHeight = 0;
//number of items you wish to hold width-wise (along the back)
itemsWide = 3;
//number of items you wish to hold depth-wise (away from back)
itemsDeep = 1;
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
slotTolerance = 1.00; //[0.925:0.005:1.075]
//Move the slot in (positive) or out (negative)
slotDepthMicroadjustment = 0; //[-.5:0.05:.5]


/*[Hidden]*/
//fit items plus 
totalWidth = itemDiameter*itemsWide + distanceBetweenEach*itemsWide + distanceBetweenEach;
//profile coordinates for the multiconnect slot
slotProfile = [[0,0],[10.15,0],[10.15,1.2121],[7.65,3.712],[7.65,5],[0,5]];


rowDepth = itemDiameter+distanceBetweenEach*2;
//inputs the row depth and desired angle to calculate the height of the back
rowBackHeight = rowDepth * tan(itemAngle);

//Thickness of the back of the item (default in 6.5mm). Changes are untested. 
backThickness = 6.5; //.1
//slot count calculates how many slots can fit on the back. Based on internal width for buffer.
slotCount = floor(max(distanceBetweenSlots,totalWidth)/distanceBetweenSlots);
echo(str("Slot Count: ",slotCount));
backWidth = max(distanceBetweenSlots,totalWidth);

hypotenuse = rowDepth;
smallHypotenuse = holeDepth+baseThickness;
triangleY = min(sin(itemAngle)*hypotenuse,tan(itemAngle)*hypotenuse);
triangleX = min(cos(itemAngle)*hypotenuse,tan(itemAngle)*hypotenuse);
smallTriangleY = min(sin(itemAngle)*smallHypotenuse,tan(itemAngle)*smallHypotenuse);
smallTriangleX = min(cos(itemAngle)*smallHypotenuse,tan(itemAngle)*smallHypotenuse);
inverseSmallTriangleY = min(sin(90-itemAngle)*smallHypotenuse,tan(90-itemAngle)*smallHypotenuse);
inverseSmallTriangleX = min(cos(90-itemAngle)*smallHypotenuse,tan(90-itemAngle)*smallHypotenuse);
totalHeight = max(triangleY+inverseSmallTriangleY,25);

//start build
multiconnectBack(backWidth = backWidth, backHeight = totalHeight+additionalBackerHeight);
//create shelves
//hull() {
    translate(v = [0,0,0]) rotate(a = [0,-90,0]) 
    polygon(points = [[0,0],[triangleY+inverseSmallTriangleY,0],[triangleY+inverseSmallTriangleY,smallTriangleY]]);
    //cube(size = [backWidth,1,totalHeight]);
    //color(c = "green") rotate(a = [-itemAngle,0,0]) cube(size = [backWidth,1,holeDepth+baseThickness]);
//}
    for(itemY = [0:1:itemsDeep-1]){
        for (itemX = [0:1:itemsWide-1]){
            translate(v = [0,0,triangleY])     
                rotate([-itemAngle,0,0]) {
                    //shelf
                    cube(size = [totalWidth, rowDepth,holeDepth+baseThickness]);
                    //delete tools
                    //translate(v = [itemDiameter/2+distanceBetweenEach + (itemX*itemDiameter+distanceBetweenEach*itemX),itemY*rowDepth+itemDiameter/2+distanceBetweenEach,baseThickness]) 
                    //    color(c = "red") cylinder(h = holeDepth+1, r = itemDiameter/2);
                }
        }
    }


//delete tools
for(itemY = [0:1:itemsDeep-1]){
    for (itemX = [0:1:itemsWide-1]){
        translate(v = [0,0,triangleY])     
            rotate([-itemAngle,0,0]) {
                //shelf
                //cube(size = [totalWidth, rowDepth,holeDepth+baseThickness]);
                //delete tools
                translate(v = [itemDiameter/2+distanceBetweenEach + (itemX*itemDiameter+distanceBetweenEach*itemX),itemY*rowDepth+itemDiameter/2+distanceBetweenEach,baseThickness]) 
                    color(c = "red") cylinder(h = holeDepth+1, r = itemDiameter/2);
            }
    }
}

//BEGIN MODULES
//Slotted back
module multiconnectBack(backWidth, backHeight)
{
    difference() {
        translate(v = [0,-6.5,0]) cube(size = [backWidth,6.5,backHeight]);
        //Loop through slots and center on the item
        //Note: I kept doing math until it looked right. It's possible this can be simplified.
        for (slotNum = [0:1:slotCount-1]) {
            translate(v = [distanceBetweenSlots/2+(backWidth/distanceBetweenSlots-slotCount)*distanceBetweenSlots/2+slotNum*distanceBetweenSlots,-2.35+slotDepthMicroadjustment,backHeight-13]) {
                color(c = "red")  slotTool(backHeight);
            }
        }
    }
    //Create Slot Tool
    module slotTool(totalHeight) {
        scale(v = slotTolerance)
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