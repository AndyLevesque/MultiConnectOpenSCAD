/*Created by Andy Levesque
Credit to 
    @David D on Printables for Multiboard
    Jonathan at Keep Making for Multiconnect
    Zach at gridfinity.xyz for the Gridfinity standard
    Katie (and her community) at Hands on Katie on Youtube for advice
Licensed Creative Commons 4.0 Attribution Non-Commercial Sharable with Attribution
*/
//cup base - note - baseplate is 0.25mm offset from this which is not included in these coords
//from https://gridfinity.xyz/specification/
//polygon(points = [[0,0],[35.6,0],[36.4,0.8],[36.4,2.6],[38.55,4.75],[38.55,0]]);

//baseplate profile
//%polygon(points = [[0,0],[2.85,0],[2.15,0.7],[2.15,2.5],[0,4.65]]);
//baseplate profile with the 4mm rounding for 4mm radius
//%polygon(points = [[0,0],[4,0],[3.3,0.7],[3.3,2.5],[1.15,4.65],[0,4.65]]);

gridfinity_base();

module gridfinity_base() {
    translate(v = [0,0,-1]) 
    difference() {
        gridfinity_base_w_floor();
        translate(v = [-1,-1,-1]) cube(size = [44,44,2]);
        hollow_tool();
    }
}

//tool to remove bottom from 
module hollow_tool() {
    //hollow tool
    translate(v = [4,4]) 
        color(c = "blue") 
            minkowski() {
                linear_extrude(height = 1) circle(r = 4-2.85, $fn=50);
                cube(size = [34,34,6]);
    }
  
}

//floor is 1mm thick for a total of a 42x42x5.65 box
module gridfinity_base_w_floor(){
    difference() {
        cube(size = [42,42,5.65]);
        
        translate(v = [0,0,1]) baseplate_delete_tool();
    }
}

module baseplate_delete_tool() {
    //baseplate delete tool
    //42mm x 42mm x 4.65mm + 1 mm height for proper deleting
    /*This is a delete tool which is the inverse profile of the baseplate intended for Difference.
    Using polygon, I sketched the profile of the base edge per gridfinity specs.
    I then realized I need rounded corners with 8mm outer diameter, so I increased the x axis enough to have a 4mm total outer length (radius).
    I rotate extrude to created the rounded corner 
    Finally, I used minkowski (thank you Katie from "Hands on Katie") using a cube that is 42mm minus the 8mm of the edges (equalling 34mm)
    */
    translate(v = [4,38,5.65]) 
        rotate(a = [180,0,0]) 
            color(c = "red") 
            minkowski() {
                rotate_extrude($fn=50) 
                        polygon(points = [[0,0],[4,0],[3.3,0.7],[3.3,2.5],[1.15,4.65],[0,4.65]]);
                cube(size = [34,34,1]);
            }
}
