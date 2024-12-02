/*Created by Hands on Katie and BlackjackDuck (Andy)
This code and all parts derived from it are Licensed Creative Commons 4.0 Attribution Non-Commercial Share-Alike (CC-BY-NC-SA)

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

/*[Choose Part]*/
Base_Top_or_Both = "Both"; // [Base, Top, Both]

/*[Mounting Options]*/
//How do you intend to connect the channels to a surface such as Honeycomb Storage Wall or Multiboard? See options at https://coda.io/@andylevesque/underware
Mounting_Method = "Threaded Snap Connector"; //[Threaded Snap Connector, Direct Multiboard Screw]

/*[Channel Size]*/
//width of channel in units (default unit is 25mm)
Channel_Width_in_Units = 1;
//height inside the channel (in mm)
Channel_Internal_Height = 12; //[12:6:72]
//length of channel in units (default unit is 25mm)
Channel_Length_Units = 5; 

/*[Cord Cutouts]*/
Number_of_Cord_Cutouts = 0;
//Cutouts on left side, right side, or both (note that it can be flipped so left and right is moot)
Cord_Side_Cutouts = "Both Sides"; //[Left Side, Right Side, Both Sides, None]
//Width of each cord cutout (in mm)
Cord_Cutout_Width = 12;
Distance_Between_Cutouts = 25;
//Distance (in mm) to shift all cutouts forward (positive) or back (negative)
Shift_Cutouts_Forward_or_Back = 0;

/*[Color Label]*/
//Create label using multicolor on straight channel
Add_Label = false;
//Text to appear on label
Text = "Hands on Katie";  // Text to be displayed
Text_x_coordinate = 0;  // Adjusting the x position of the text
//Font must be installed on local machine if using local OpenSCAD
Font = "Raleway"; // [Asap, Bangers, Changa One, Chewy, Harmony OS Sans,Inter,Inter Tight,Lora,Merriweather Sans,Montserrat,Noto Emoji,Noto Sans,Noto Sans Adlam,Noto Sans Adlam Unjoined,Noto Sans Arabic,Noto Sans Arabic UI,Noto Sans Armenian,Noto Sans Balinese,Noto Sans Bamum,Noto Sans Bassa Vah,Noto Sans Bengali,Noto Sans Bengali UI,Noto Sans Canadian Aboriginal,Noto Sans Cham,Noto Sans Cherokee,Noto Sans Devanagari,Noto Sans Display,Noto Sans Ethiopic,Noto Sans Georgian,Noto Sans Gujarati,Noto Sans Gunjala Gondi,Noto Sans Gurmukhi,Noto Sans Gurmukhi UI,Noto Sans HK,Noto Sans Hanifi Rohingya,Noto Sans Hebrew,Noto Sans JP,Noto Sans Javanese,Noto Sans KR,Noto Sans Kannada,Noto Sans Kannada UI,Noto Sans Kawi,Noto Sans Kayah Li,Noto Sans Khmer,Noto Sans Khmer UI,Noto Sans Lao,Noto Sans Lao Looped,Noto Sans Lao UI,Noto Sans Lisu,Noto Sans Malayalam,Noto Sans Malayalam UI,Noto Sans Medefaidrin,Noto Sans Meetei Mayek,Noto Sans Mono,Noto Sans Myanmar,Noto Sans NKo Unjoined,Noto Sans Nag Mundari,Noto Sans New Tai Lue,Noto Sans Ol Chiki,Noto Sans Oriya,Noto Sans SC,Noto Sans Sinhala,Noto Sans Sinhala UI,Noto Sans Sora Sompeng,Noto Sans Sundanese,Noto Sans Symbols,Noto Sans Syriac,Noto Sans Syriac Eastern,Noto Sans TC,Noto Sans Tai Tham,Noto Sans Tamil,Noto Sans Tamil UI,Noto Sans Tangsa,Noto Sans Telugu,Noto Sans Telugu UI,Noto Sans Thaana,Noto Sans Thai,Noto Sans Thai UI,Noto Sans Vithkuqi,Nunito,Nunito Sans,Open Sans,Open Sans Condensed,Oswald,Playfair Display,Plus Jakarta Sans,Raleway,Roboto,Roboto Condensed,Roboto Flex,Roboto Mono,Roboto Serif,Roboto Slab,Rubik,Source Sans 3,Ubuntu Sans,Ubuntu Sans Mono,Work Sans]
//Styling of selecte font. Note that not all fonts support all styles. 
Font_Style = "Regular"; // [Regular,Bold,Medium,SemiBold,Light,ExtraBold,Black,ExtraLight,Thin,Bold Italic,Italic,Light Italic,Medium Italic]
Text_size = 10;    // Font size
//Color of label text (color names found at https://en.wikipedia.org/wiki/Web_colors)
Text_Color = "Pink";
surname_font = str(Font , ":style=", Font_Style);

/*[Advanced Options]*/
//Units of measurement (in mm) for hole and length spacing. Multiboard is 25mm. Untested
Grid_Size = 25;
//Resolution of arcs. Higher results in finer detail in the turns.
Curve_Resolution = 25;
//Color of part (color names found at https://en.wikipedia.org/wiki/Web_colors)
Global_Color = "SlateBlue";

/*[Hidden]*/
channelWidth = Channel_Width_in_Units * Grid_Size;
baseHeight = 9.63;
topHeight = 10.968;
interlockOverlap = 3.09; //distance that the top and base overlap each other
interlockFromFloor = 6.533; //distance from the bottom of the base to the bottom of the top when interlocked
partSeparation = 10;

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

//Part Size Calculations
straight_channel_Y = Grid_Size * Channel_Length_Units;


if(Base_Top_or_Both != "Top")
color_this(Global_Color)
        left(Show_Attached ? 0 : channelWidth/2)
            straightChannelBase(lengthMM = Channel_Length_Units * Grid_Size, widthMM = channelWidth, anchor=BOT);
if(Base_Top_or_Both != "Base")
color_this(Global_Color)
        right(Show_Attached ? 0 : channelWidth/2 + 5)
        up(Show_Attached ? interlockFromFloor : Add_Label ? 0.01 : 0)
            diff("text")
            straightChannelTop(lengthMM = Channel_Length_Units * Grid_Size, widthMM = channelWidth, heightMM = Channel_Internal_Height, anchor=Show_Attached ? BOT : TOP, orient=Show_Attached ? TOP : BOT)
                if(Add_Label) tag("text") recolor(Text_Color) zrot(-90) attach(TOP) //linear_extrude(height = 0.02)
                right(Text_x_coordinate)text3d(Text, size = Text_size, h=0.05, font = surname_font, atype="ycenter", anchor=CENTER);

/*


***BEGIN MODULES***

*/

//STRAIGHT CHANNELS
module straightChannelBase(lengthMM, widthMM, anchor, spin, orient){
    attachable(anchor, spin, orient, size=[widthMM, lengthMM, baseHeight]){
        fwd(lengthMM/2) down(maxY(baseProfileHalf)/2)
        diff("holes")
        zrot(90) path_sweep(baseProfile(widthMM = widthMM), turtle(["xmove", lengthMM]))
        tag("holes")  right(lengthMM/2) grid_copies(spacing=Grid_Size, inside=rect([lengthMM-1,widthMM-1])) 
            if(Mounting_Method == "Direct Multiboard Screw") up(Base_Screw_Hole_Inner_Depth) cyl(h=8, d=Base_Screw_Hole_Inner_Diameter, $fn=25, anchor=TOP) attach(TOP, BOT, overlap=0.01) cyl(h=3.5-Base_Screw_Hole_Inner_Depth+0.02, d1=Base_Screw_Hole_Cone ? Base_Screw_Hole_Inner_Diameter : Base_Screw_Hole_Outer_Diameter, d2=Base_Screw_Hole_Outer_Diameter, $fn=25);
            else up(6.5) trapezoidal_threaded_rod(d=Outer_Diameter_Sm, l=9, pitch=Pitch_Sm, flank_angle = Flank_Angle_Sm, thread_depth = Thread_Depth_Sm, $fn=50, bevel2 = true, blunt_start=false, anchor=TOP);
    children();
    }
}

module straightChannelTop(lengthMM, widthMM, heightMM = 12, anchor, spin, orient){
    attachable(anchor, spin, orient, size=[widthMM, lengthMM, topHeight + (heightMM-12)]){
        fwd(lengthMM/2) down(10.968/2 + (heightMM - 12)/2)
        diff("Cable_Cutouts")
        zrot(90) path_sweep(topProfile(widthMM = widthMM, heightMM = heightMM), turtle(["xmove", lengthMM]))
            tag("Cable_Cutouts") down(5+0.01) up(10.968/2 + (heightMM - 12)/2) right(lengthMM/2)
                xcopies(n=Number_of_Cord_Cutouts, spacing= Distance_Between_Cutouts) 
                    up(2.49)
                    fwd(Cord_Side_Cutouts == "Left Side" ? channelWidth/2 :
                        Cord_Side_Cutouts == "Right Side" ? -channelWidth/2 : 
                        0)
                    left(-Shift_Cutouts_Forward_or_Back)
                        cuboid([Cord_Cutout_Width, Cord_Side_Cutouts == "Both Sides" ? channelWidth + 5 : channelWidth/2, Channel_Internal_Height-2], chamfer = 2, edges=[TOP+LEFT, TOP+RIGHT]);
    children();
    }
}

//BEGIN PROFILES - Must match across all files

//take the two halves of base and merge them
function baseProfile(widthMM = 25) = 
    union(
        left((widthMM-25)/2,baseProfileHalf), 
        right((widthMM-25)/2,mirror([1,0],baseProfileHalf)), //fill middle if widening from standard 25mm
        back(3.5/2,rect([widthMM-25+0.02,3.5]))
    );

//take the two halves of base and merge them
function topProfile(widthMM = 25, heightMM = 12) = 
    union(
        left((widthMM-25)/2,topProfileHalf(heightMM)), 
        right((widthMM-25)/2,mirror([1,0],topProfileHalf(heightMM))), //fill middle if widening from standard 25mm
        back(topHeight-1 + heightMM-12 , rect([widthMM-25+0.02,2])) 
    );

function baseDeleteProfile(widthMM = 25) = 
    union(
        left((widthMM-25)/2,baseDeleteProfileHalf), 
        right((widthMM-25)/2,mirror([1,0],baseDeleteProfileHalf)), //fill middle if widening from standard 25mm
        back(6.575,rect([widthMM-25+0.02,6.15]))
    );

function topDeleteProfile(widthMM, heightMM = 12) = 
    union(
        left((widthMM-25)/2,topDeleteProfileHalf(heightMM)), 
        right((widthMM-25)/2,mirror([1,0],topDeleteProfileHalf(heightMM))), //fill middle if widening from standard 25mm
        back(4.474 + (heightMM-12)/2,rect([widthMM-25+0.02,8.988 + heightMM - 12])) 
    );

baseProfileHalf = 
    fwd(-7.947, //take Katie's exact measurements for half the profile and use fwd to place flush on the Y axis
        //profile extracted from exact coordinates in Master Profile F360 sketch. Any additional modifications are added mathmatical functions. 
        [
            [0,-4.447],
            [-8.5,-4.447],
            [-9.5,-3.447],
            [-9.5,1.683],
            [-10.517,1.683],
            [-11.459,1.422],
            [-11.459,-0.297],
            [-11.166,-0.592],
            [-11.166,-1.414],
            [-11.666,-1.914],
            [-12.517,-1.914],
            [-12.517,-4.448],
            [-10.517,-6.448],
            [-10.517,-7.947],
            [0,-7.947]
        ]
);

function topProfileHalf(heightMM = 12) =
        back(1.414,//profile extracted from exact coordinates in Master Profile F360 sketch. Any additional modifications are added mathmatical functions. 
        [
            [0,7.554 + (heightMM - 12)],//-0.017 per Katie's diagram. Moved to zero
            [0,9.554 + (heightMM - 12)],
            [-8.517,9.554 + (heightMM - 12)],
            [-12.517,5.554 + (heightMM - 12)],
            [-12.517,-1.414],
            [-11.166,-1.414],
            [-11.166,-0.592],
            [-11.459,-0.297],
            [-11.459,1.422],
            [-10.517,1.683],
            [-10.517,4.725 + (heightMM - 12)],
            [-7.688,7.554 + (heightMM - 12)]
        ]
        );

baseDeleteProfileHalf = 
    fwd(-7.947, //take Katie's exact measurements for half the profile of the inside
        //profile extracted from exact coordinates in Master Profile F360 sketch. Any additional modifications are added mathmatical functions. 
        [
            [0,-4.447], //inner x axis point with width adjustment
            [0,1.683+0.02],
            [-9.5,1.683+0.02],
            [-9.5,-3.447],
            [-8.5,-4.447],
        ]
);

function topDeleteProfileHalf(heightMM = 12)=
        back(1.414,//profile extracted from exact coordinates in Master Profile F360 sketch. Any additional modifications are added mathmatical functions. 
        [
            [0,7.554 + (heightMM - 12)],
            [-7.688,7.554 + (heightMM - 12)],
            [-10.517,4.725 + (heightMM - 12)],
            [-10.517,1.683],
            [-11.459,1.422],
            [-11.459,-0.297],
            [-11.166,-0.592],
            [-11.166,-1.414-0.02],
            [0,-1.414-0.02]
        ]
        );


//calculate the max x and y points. Useful in calculating size of an object when the path are all positive variables originating from [0,0]
function maxX(path) = max([for (p = path) p[0]]) + abs(min([for (p = path) p[0]]));
function maxY(path) = max([for (p = path) p[1]]) + abs(min([for (p = path) p[1]]));


