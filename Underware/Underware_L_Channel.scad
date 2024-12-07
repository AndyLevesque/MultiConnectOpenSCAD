/*Created by BlackjackDuck (Andy) and Hands on Katie. Original model from Hands on Katie (https://handsonkatie.com/)
This code and all parts derived from it are Licensed Creative Commons 4.0 Attribution Non-Commercial Share-Alike (CC-BY-NC-SA)

Documentation available at https://handsonkatie.com/underware-2-0-the-made-to-measure-collection/

Credit to
    First and foremost - Katie and her community at Hands on Katie on Youtube, Patreon, and Discord
    @David D on Printables for Multiconnect
    Jonathan at Keep Making for Multiboard
    @cosmicdust on MakerWorld and @freakadings_1408562 on Printables for the idea of diagonals (forward and turn)
    @siyrahfall+1155967 on Printables for the idea of top exit holes
    @Lyric on Printables for the flush connector idea

*/

include <BOSL2/std.scad>
include <BOSL2/rounding.scad>
include <BOSL2/threading.scad>
include <Underware_Shared.scad>

/*[Choose Part]*/
Base_Top_or_Both = "Both"; // [Base, Top, Both]

/*[Channel Size]*/
//width of channel in units (default unit is 25mm)
Channel_Width_in_Units = 1;
//height inside the channel (in mm)
Channel_Internal_Height = 12; //[12:6:72]
//Number of grids extending from the corner grid
L_Channel_Length_in_Units = 1;

/*[Mounting Options]*/
//How do you intend to mount the channels to a surface such as Honeycomb Storage Wall or Multiboard? See options at https://handsonkatie.com/underware-2-0-the-made-to-measure-collection/
Mounting_Method = "Threaded Snap Connector"; //[Threaded Snap Connector, Direct Multiboard Screw, Magnet, Wood Screw, Flat]
//Diameter of the magnet (in mm)
Magnet_Diameter = 4.0;
//Thickness of the magnet (in mm)
Magnet_Thickness = 1.5;
//Add a tolerance to the magnet hole to make it easier to insert the magnet.
Magnet_Tolerance = 0.1;
//wood screw diameter (in mm)
Wood_Screw_Thread_Diameter = 3.5;
//Wood Screw Head Diameter (in mm)
Wood_Screw_Head_Diameter = 7;
//Wood Screw Head Height (in mm)
Wood_Screw_Head_Height = 1.75;

/*[Advanced Options]*/
//Units of measurement (in mm) for hole and length spacing. Multiboard is 25mm. Untested
Grid_Size = 25;
//Color of part (color names found at https://en.wikipedia.org/wiki/Web_colors)
Global_Color = "SlateBlue";

/*[Hidden]*/
channelWidth = Channel_Width_in_Units * Grid_Size;

///*[Visual Options]*/
Debug_Show_Grid = false;
//View the parts as they attach. Note that you must disable this before exporting for printing.
Show_Attached = false;

///*[Small Screw Profile]*/
//Distance (in mm) between threads
Pitch_Sm = 3;
//Diameter (in mm) at the outer threads
Outer_Diameter_Sm = 6.747;
//Angle of the one side of the thread
Flank_Angle_Sm = 60;
//Depth (in mm) of the thread
Thread_Depth_Sm = 0.5;
//Diameter of the hole down the middle of the screw (for strength)
Inner_Hole_Diameter_Sm = 3.3;


///*[Direct Screw Mount]*/
Base_Screw_Hole_Inner_Diameter = 7;
Base_Screw_Hole_Outer_Diameter = 15;
//Thickness of of the base bottom and the bottom of the recessed hole (i.e., thicknes of base at the recess)
Base_Screw_Hole_Inner_Depth = 1;
Base_Screw_Hole_Cone = false;

if(Base_Top_or_Both != "Top")
color_this(Global_Color)
    left(Show_Attached ? 0 : partSeparation)
        lChannelBase(lengthMM = L_Channel_Length_in_Units * Grid_Size, widthMM = Channel_Width_in_Units * Grid_Size, anchor=Show_Attached ? BOT : BOT+RIGHT);
if(Base_Top_or_Both != "Base")
color_this(Global_Color)
    up(Show_Attached ? interlockFromFloor : 0)
    right(Show_Attached ? 0 : partSeparation)
        lChannelTop(lengthMM = L_Channel_Length_in_Units * Grid_Size, widthMM = Channel_Width_in_Units * Grid_Size, heightMM = Channel_Internal_Height, anchor= Show_Attached ? BOT : TOP+RIGHT, orient=Show_Attached ? TOP : BOT);


/*

***BEGIN MODULES***

*/

//L CHANNELS
module lChannelBase(lengthMM = 50, widthMM = 25, anchor, spin, orient){
    attachable(anchor, spin, orient, size=[widthMM+lengthMM, widthMM+lengthMM, baseHeight]){
        let(calculatedPath = widthMM/2+lengthMM)
        left(widthMM/2+lengthMM/2) fwd(lengthMM/2)
        down(baseHeight/2)
        diff("holes"){
            path_sweep2d(baseProfile(widthMM = widthMM), turtle(["move", calculatedPath, "turn", 90, "move",calculatedPath] ));
            tag("holes") right(widthMM/2+lengthMM/2) back(lengthMM/2) grid_copies(spacing=Grid_Size, inside=rect([widthMM+lengthMM-1,widthMM+lengthMM-1]))
                if(Mounting_Method == "Direct Multiboard Screw") up(Base_Screw_Hole_Inner_Depth) cyl(h=8, d=Base_Screw_Hole_Inner_Diameter, $fn=25, anchor=TOP) attach(TOP, BOT, overlap=0.01) cyl(h=10, d=Base_Screw_Hole_Outer_Diameter, $fn=25);
                else if(Mounting_Method == "Magnet") up(Magnet_Thickness+Magnet_Tolerance-0.01) cyl(h=Magnet_Thickness+Magnet_Tolerance, d=Magnet_Diameter+Magnet_Tolerance, $fn=50, anchor=TOP);
                else if(Mounting_Method == "Wood Screw") up(3.5 - Wood_Screw_Head_Height) cyl(h=3.5 - Wood_Screw_Head_Height+0.05, d=Wood_Screw_Thread_Diameter, $fn=25, anchor=TOP)
                    //wood screw head
                    attach(TOP, BOT, overlap=0.01) cyl(h=Wood_Screw_Head_Height+0.05, d1=Wood_Screw_Thread_Diameter, d2=Wood_Screw_Head_Diameter, $fn=25);
                else if(Mounting_Method == "Flat") ; //do nothing
                else up(6.5) trapezoidal_threaded_rod(d=Outer_Diameter_Sm, l=9, pitch=Pitch_Sm, flank_angle = Flank_Angle_Sm, thread_depth = Thread_Depth_Sm, $fn=50, bevel2 = true, blunt_start=false, anchor=TOP);
        }
    children();
    }
}
module lChannelTop(lengthMM = 50, widthMM = 25, heightMM = 12, anchor, spin, orient){
    attachable(anchor, spin, orient, size=[widthMM+lengthMM, widthMM+lengthMM, topHeight + (heightMM-12)]){
        let(calculatedPath = widthMM/2+lengthMM)
        left(widthMM/2+lengthMM/2) fwd(lengthMM/2)
        down(topHeight/2 + (heightMM - 12)/2)
        path_sweep2d(topProfile(widthMM = widthMM, heightMM = heightMM), turtle(["move", calculatedPath, "turn", 90, "move",calculatedPath] ));
    children();
    }
}