/*Created by Andy Levesque
Credit to 
    @David D on Printables for Multiboard
    Jonathan at Keep Making for Multiconnect
    Zach at gridfinity.xyz for the Gridfinity standard
    Katie (and her community) at Hands on Katie on Youtube for advice
Licensed Creative Commons 4.0 Attribution Non-Commercial Sharable with Attribution
TODO: 
    - Add ability to tweak rim height
    - Ability to trim grid height (some versions lop off a tiny bit off the top)
*/

/*[Parameters]*/
unitsWide = 2;
unitsDeep = 2;
rimThickness = 1.5;
baseThickness = 1.5;
backHeight = 15+10*unitsDeep;

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
//Thickness of the back of the item (default in 6.5mm). Changes are untested. 
backThickness = 6.5; //.1
//profile coordinates for the multiconnect slot
slotProfile = [[0,0],[10.15,0],[10.15,1.2121],[7.65,3.712],[7.65,5],[0,5]];


totalWidth = unitsWide*42+rimThickness*2;
totalDepth = 6.5+unitsDeep*42+rimThickness;

//slot count calculates how many slots can fit on the back.
slotCount = floor(totalWidth/distanceBetweenSlots);
echo(str("Slot Count: ",slotCount));

//begin build
translate(v = [-totalWidth/2,-totalDepth/2]) 
union(){
    translate(v = [rimThickness,0,0]) 
        gridfinity_grid(xCount = unitsWide, yCount = unitsDeep);
    translate(v = [0,0,-baseThickness]) 
        multiconnectBack(backWidth = totalWidth, backHeight = backHeight);
    //shelf
    difference(){
            translate(v = [0,0,-baseThickness]) 
                cube([totalWidth,totalDepth-backThickness,4.65+baseThickness]);
            translate(v = [rimThickness,0,0]) 
                cube([totalWidth-rimThickness*2,totalDepth-backThickness-rimThickness,6]);
    }
    //bracket
    exposedBackHeight = backHeight-baseThickness-4.65;
    translate(v = [rimThickness,0,backHeight-baseThickness])
        shelfBracket(bracketHeight = exposedBackHeight, bracketDepth = exposedBackHeight,rimThickness = rimThickness);
    translate(v = [totalWidth,0,backHeight-baseThickness])
        shelfBracket(bracketHeight = exposedBackHeight, bracketDepth = exposedBackHeight,rimThickness = rimThickness);
}

module gridfinity_grid(xCount, yCount) {
  //Gridfinity Grid
    for (columnY = [0:1:yCount-1]){
        for (rowX = [0:1:xCount-1]) {
            translate(v = [rowX*42,columnY*42,0]) gridfinity_base();
        }
    }
}

module gridfinity_base() {
    difference() {
        cube(size = [42,42,4.65]);
        /*
        baseplate delete tool
        This is a delete tool which is the inverse profile of the baseplate intended for Difference.
        Using polygon, I sketched the profile of the base edge per gridfinity specs.
        I then realized I need rounded corners with 8mm outer diameter, so I increased the x axis enough to have a 4mm total outer length (radius).
        I rotate extrude to created the rounded corner 
        Finally, I used minkowski (thank you Katie from "Hands on Katie") using a cube that is 42mm minus the 8mm of the edges (equalling 34mm)
        I also added separate minkowski tools to extend the top and the bottom for proper deleting
        */
        union() {
            //primary profile
            translate(v = [4,38,5.65]) 
                rotate(a = [180,0,0]) 
                    color(c = "red") 
                    minkowski() {
                        rotate_extrude($fn=50) 
                                polygon(points = [[0,0],[4,0],[3.3,0.7],[3.3,2.5],[1.15,4.65],[0,4.65]]);
                        cube(size = [34,34,1]);
                    }
            //bottom extension bottom tool
            translate(v = [4,4,-2]) 
                color(c = "blue") 
                    minkowski() {
                        linear_extrude(height = 1) circle(r = 4-2.85, $fn=50);
                        cube(size = [34,34,6]);
            }
            //top extension
                translate(v = [4,4,5]) 
                color(c = "green") 
                    minkowski() {
                        linear_extrude(height = 1) circle(r = 4, $fn=50);
                        cube(size = [34,34,2]);
            }
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

module shelfBracket(bracketHeight, bracketDepth, rimThickness){
        rotate(a = [-90,0,90]) 
            linear_extrude(height = rimThickness) 
                polygon([[0,0],[0,bracketHeight],[bracketDepth,bracketHeight]]);
}