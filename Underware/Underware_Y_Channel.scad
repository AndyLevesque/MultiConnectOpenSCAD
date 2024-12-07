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

/*[Channel Shape]*/
//width of channel in units (default unit is 25mm)
Channel_Width_in_Units = 1;
//height inside the channel (in mm)
Channel_Internal_Height = 12; //[12:6:72]
//Grid units to move over. Both sides will move over and away from the center by this amount.
Y_Units_Over = 1; //[1:1:10]
//Grid units to move up
Y_Units_Up = 1;//[1:1:10]
//Output the same direction (Forward) or at 90 degrees in direction of shift (Turn).
Y_Output_Direction = "Forward"; //[Forward, Turn]
//Distance that the parts are straight in on the ends (before the angle). Unexpected behavior on wider channels may be resolved by changing this slider.
Y_Straight_Distance = 12.5; //[12.5:12.5:100]

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

/*

***BEGIN DISPLAYS***

*/


if(Base_Top_or_Both != "Top")
    color_this(Global_Color)
        left(partSeparation/2) yChannelBase(widthMM = channelWidth, unitsOver = Y_Units_Over, unitsUp = Y_Units_Up, outputDirection = Y_Output_Direction, straightDistance = Y_Straight_Distance, anchor=BOT+RIGHT);

if(Base_Top_or_Both != "Base")
    color_this(Global_Color)
        right(partSeparation/2) yChannelTop(widthMM = channelWidth, unitsOver = Y_Units_Over, unitsUp = Y_Units_Up, heightMM = Channel_Internal_Height, outputDirection = Y_Output_Direction, straightDistance = Y_Straight_Distance, anchor=TOP+RIGHT, orient=BOT);


/*

***BEGIN MODULES***

*/

//Y-ChannelS
module yChannelBase(unitsOver = 1, unitsUp=3, outputDirection = "Forward", straightDistance = Grid_Size, widthMM, anchor, spin, orient){
    attachable(anchor, spin, orient, size=[unitsOver*Grid_Size*2+channelWidth,unitsUp*Grid_Size+straightDistance*2, baseHeight]){
        fwd(unitsUp*Grid_Size/2+straightDistance)
        down(baseHeight/2)
            diff("holes"){
                xflip_copy()
                {
                    right_half(s=max(unitsUp*Grid_Size*4,unitsOver*Grid_Size*4)) {//s should be a number larger than twice the size of the object's largest axis. Thew some random numbers in here for now. If mirror issues surface, this is likely the culprit.
                        path_sweep2d(baseProfile(widthMM = widthMM),
                            path= outputDirection == "Forward" ? [
                                [0,0], //start
                                [0,straightDistance*sign(unitsUp)+0.1], //distance forward or back. 0.05 is a subtle cheat that allows for a perfect side shift without a bad polygon
                                [unitsOver*Grid_Size,unitsUp*Grid_Size+Grid_Size*sign(unitsUp)-straightDistance*sign(unitsUp)-0.1], //movement to position before last straight
                                [unitsOver*Grid_Size,unitsUp*Grid_Size+Grid_Size*sign(unitsUp)] //last position either out the angle or straight out
                            ] :
                            [ //90 degree path
                                [0,0], //start
                                [0,straightDistance*sign(unitsUp)+0.1], //distance forward or back. 0.05 is a subtle cheat that allows for a perfect side shift without a bad polygon
                                [unitsOver*Grid_Size+Grid_Size/2*sign(unitsOver)-straightDistance*sign(unitsOver),unitsUp*Grid_Size+Grid_Size/2*sign(unitsUp)], //movement to position before last straight
                                [unitsOver*Grid_Size+Grid_Size/2*sign(unitsOver),unitsUp*Grid_Size+Grid_Size/2*sign(unitsUp)] //last position either out the angle or straight out
                            ]
                            );
                    }}
                            tag("holes") xcopies(spacing = Grid_Size, n = Channel_Width_in_Units) back(Grid_Size/2*sign(unitsUp)) down(0.01)
                                if(Mounting_Method == "Direct Multiboard Screw") up(Base_Screw_Hole_Inner_Depth) cyl(h=8, d=Base_Screw_Hole_Inner_Diameter, $fn=25, anchor=TOP) attach(TOP, BOT, overlap=0.01) cyl(h=3, d=Base_Screw_Hole_Outer_Diameter, $fn=25);
                                else if(Mounting_Method == "Magnet") up(Magnet_Thickness+Magnet_Tolerance-0.01) cyl(h=Magnet_Thickness+Magnet_Tolerance, d=Magnet_Diameter+Magnet_Tolerance, $fn=50, anchor=TOP);
                                else if(Mounting_Method == "Wood Screw") up(3.5 - Wood_Screw_Head_Height) cyl(h=3.5 - Wood_Screw_Head_Height+0.05, d=Wood_Screw_Thread_Diameter, $fn=25, anchor=TOP)
                                    //wood screw head
                                    attach(TOP, BOT, overlap=0.01) cyl(h=Wood_Screw_Head_Height+0.05, d1=Wood_Screw_Thread_Diameter, d2=Wood_Screw_Head_Diameter, $fn=25);
                                else if(Mounting_Method == "Flat") ; //do nothing
                                else up(6.5) trapezoidal_threaded_rod(d=Outer_Diameter_Sm, l=9, pitch=Pitch_Sm, flank_angle = Flank_Angle_Sm, thread_depth = Thread_Depth_Sm, $fn=50, bevel2 = true, blunt_start=false, anchor=TOP);
                            //outside holes forward option (right side)
                            tag("holes")
                                if(outputDirection == "Forward")
                                    move_copies([
                                        [unitsOver*Grid_Size, unitsUp*Grid_Size+Grid_Size*sign(unitsUp)-Grid_Size/2*sign(unitsUp),-0.01],//right side
                                        [unitsOver*Grid_Size*-1, unitsUp*Grid_Size+Grid_Size*sign(unitsUp)-Grid_Size/2*sign(unitsUp),-0.01]
                                        ])
                                        xcopies(spacing = Grid_Size, n = Channel_Width_in_Units) //back(Units_Up*Grid_Size+Grid_Size*sign(unitsUp)-Grid_Size/2*sign(unitsUp)) //right(unitsOver*Grid_Size)down(0.01)
                                    if(Mounting_Method == "Direct Multiboard Screw") up(Base_Screw_Hole_Inner_Depth) cyl(h=8, d=Base_Screw_Hole_Inner_Diameter, $fn=25, anchor=TOP) attach(TOP, BOT, overlap=0.01) cyl(h=3, d=Base_Screw_Hole_Outer_Diameter, $fn=25);
                                    else if(Mounting_Method == "Magnet") up(Magnet_Thickness+Magnet_Tolerance-0.01) cyl(h=Magnet_Thickness+Magnet_Tolerance, d=Magnet_Diameter+Magnet_Tolerance, $fn=50, anchor=TOP);
                                    else if(Mounting_Method == "Wood Screw") up(3.5 - Wood_Screw_Head_Height) cyl(h=3.5 - Wood_Screw_Head_Height+0.05, d=Wood_Screw_Thread_Diameter, $fn=25, anchor=TOP)
                                        //wood screw head
                                        attach(TOP, BOT, overlap=0.01) cyl(h=Wood_Screw_Head_Height+0.05, d1=Wood_Screw_Thread_Diameter, d2=Wood_Screw_Head_Diameter, $fn=25);
                                    else if(Mounting_Method == "Flat") ; //do nothing
                                    else up(6.5) trapezoidal_threaded_rod(d=Outer_Diameter_Sm, l=9, pitch=Pitch_Sm, flank_angle = Flank_Angle_Sm, thread_depth = Thread_Depth_Sm, $fn=50, bevel2 = true, blunt_start=false, anchor=TOP);
                            //outside holes turn option
                            tag("holes")
                                if(outputDirection == "Turn")
                                    move_copies([
                                        [unitsOver*Grid_Size,unitsUp*Grid_Size+Grid_Size/2*sign(unitsUp),-0.01],
                                        [-unitsOver*Grid_Size,unitsUp*Grid_Size+Grid_Size/2*sign(unitsUp),-0.01]
                                        ])
                                        ycopies(spacing = Grid_Size, n = Channel_Width_in_Units)// back(Units_Up*Grid_Size+Grid_Size/2*sign(unitsUp)) //right(unitsOver*Grid_Size)down(0.01)
                                if(Mounting_Method == "Direct Multiboard Screw") up(Base_Screw_Hole_Inner_Depth) cyl(h=8, d=Base_Screw_Hole_Inner_Diameter, $fn=25, anchor=TOP) attach(TOP, BOT, overlap=0.01) cyl(h=3, d=Base_Screw_Hole_Outer_Diameter, $fn=25);
                                else if(Mounting_Method == "Magnet") up(Magnet_Thickness+Magnet_Tolerance-0.01) cyl(h=Magnet_Thickness+Magnet_Tolerance, d=Magnet_Diameter+Magnet_Tolerance, $fn=50, anchor=TOP);
                                else if(Mounting_Method == "Wood Screw") up(3.5 - Wood_Screw_Head_Height) cyl(h=3.5 - Wood_Screw_Head_Height+0.05, d=Wood_Screw_Thread_Diameter, $fn=25, anchor=TOP)
                                    //wood screw head
                                    attach(TOP, BOT, overlap=0.01) cyl(h=Wood_Screw_Head_Height+0.05, d1=Wood_Screw_Thread_Diameter, d2=Wood_Screw_Head_Diameter, $fn=25);
                                else if(Mounting_Method == "Flat") ; //do nothing
                                else up(6.5) trapezoidal_threaded_rod(d=Outer_Diameter_Sm, l=9, pitch=Pitch_Sm, flank_angle = Flank_Angle_Sm, thread_depth = Thread_Depth_Sm, $fn=50, bevel2 = true, blunt_start=false, anchor=TOP);
            if(Debug_Show_Grid)
                #back(12.5) back(12.5*Channel_Width_in_Units-12.5) grid_copies(spacing=Grid_Size, inside=rect([200,200]))cyl(h=8, d=7, $fn=25);//temporary
            }
        children();
    }
}

module yChannelTop(unitsOver = 1, unitsUp=3, heightMM = 12, outputDirection = "Forward", straightDistance = Grid_Size, widthMM, anchor, spin, orient){
    attachable(anchor, spin, orient, size=[unitsOver*Grid_Size*2+channelWidth,unitsUp*Grid_Size+straightDistance*2, topHeight + (heightMM-12)]){
        fwd(unitsUp*Grid_Size/2+straightDistance)
        down((topHeight + (heightMM-12))/2)
            diff("holes"){
                xflip_copy()
                {
                    right_half(s=max(unitsUp*Grid_Size*4,unitsOver*Grid_Size*4)) {//s should be a number larger than twice the size of the object's largest axis. Thew some random numbers in here for now. If mirror issues surface, this is likely the culprit.
                        path_sweep2d(topProfile(widthMM = widthMM, heightMM = heightMM),
                            path= outputDirection == "Forward" ? [
                                [0,0], //start
                                [0,straightDistance*sign(unitsUp)+0.1], //distance forward or back. 0.05 is a subtle cheat that allows for a perfect side shift without a bad polygon
                                [unitsOver*Grid_Size,unitsUp*Grid_Size+Grid_Size*sign(unitsUp)-straightDistance*sign(unitsUp)-0.1], //movement to position before last straight
                                [unitsOver*Grid_Size,unitsUp*Grid_Size+Grid_Size*sign(unitsUp)] //last position either out the angle or straight out
                            ] :
                            [ //90 degree path
                                [0,0], //start
                                [0,straightDistance*sign(unitsUp)+0.1], //distance forward or back. 0.05 is a subtle cheat that allows for a perfect side shift without a bad polygon
                                [unitsOver*Grid_Size+Grid_Size/2*sign(unitsOver)-straightDistance*sign(unitsOver),unitsUp*Grid_Size+Grid_Size/2*sign(unitsUp)], //movement to position before last straight
                                [unitsOver*Grid_Size+Grid_Size/2*sign(unitsOver),unitsUp*Grid_Size+Grid_Size/2*sign(unitsUp)] //last position either out the angle or straight out
                            ]
                            );
                    }}
            }
        children();
    }
}
