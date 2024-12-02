/*Created by BlackjackDuck (Andy) and Hands on Katie. Original model by @dmgerman on MakerWorld

This code and all parts derived from it are Licensed Creative Commons 4.0 Attribution Non-Commercial Share-Alike (CC-BY-NC-SA)

Credit to 
    First and foremost - Katie and her community at Hands on Katie on Youtube, Patreon, and Discord
    @dmgerman on MakerWorld for the specs on the small screw profile
*/

include <BOSL2/std.scad>
include <BOSL2/rounding.scad>

/*[Item Dimensions]*/
Item_Width_MM = 50;
Item_Height_MM = 30;
Item_Length_MM = 261;

/*[One-piece U Style]*/
Bridge_Width_MM = 10;
Bridge_Wall_Thickness_MM = 2;

/*[Advanced Settings]*/
Grid_Size = 25;

/*[Hidden]*/
///*[Direct Screw Mount]*/
Base_Screw_Hole_Inner_Diameter = 7;
Base_Screw_Hole_Outer_Diameter = 15;
//Thickness of of the base bottom and the bottom of the recessed hole (i.e., thicknes of base at the recess)
Base_Screw_Hole_Inner_Depth = 1;
Base_Screw_Hole_Cone = false;

//Item Representation
#cuboid([Item_Width_MM,Item_Length_MM, Item_Height_MM ], anchor = BOT);

//One-piece U Style
//Bridge
up(Item_Height_MM)
cuboid([Item_Width_MM + Bridge_Wall_Thickness_MM*2, Bridge_Width_MM, Bridge_Wall_Thickness_MM], anchor=BOT)
    //downward walls
    attach(BOT, TOP, align=[LEFT,RIGHT])
        cuboid([Bridge_Wall_Thickness_MM, Bridge_Width_MM, Item_Height_MM], anchor=BOT)
            //horizontal mounting points (mount on outside)
            attach($idx == 0 ? LEFT : RIGHT, LEFT , align=BOT)
                diff() 
                cuboid([Base_Screw_Hole_Outer_Diameter, Base_Screw_Hole_Outer_Diameter, 3], anchor=BOT)
                    attach(TOP, BOT, inside=true, shiftout=0.01) cyl(Base_Screw_Hole_Inner_Diameter/2, 3, $fn=25);