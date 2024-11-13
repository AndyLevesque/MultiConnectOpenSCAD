/*Created by Hands on Katie and BlackjackDuck (Andy)
Credit to 
    Katie (and her community) at Hands on Katie on Youtube and Patreon
    @David D on Printables for Multiconnect
    Jonathan at Keep Making for MulticonnMultiboard
    
Licensed Creative Commons 4.0 Attribution Non-Commercial Sharable with Attribution
*/

include <BOSL2/std.scad>
include <BOSL2/rounding.scad>
include <BOSL2/threading.scad>

/*[Chose Parts]*/
Straight = true;
L_Channel = true;
C_Curve = true;
X_Intersection = true;
T_Intersection = true;
//Threaded_Snap_Connector = true;
//Small_Screw = false;
//Large_Screw = false;

/*[Mounting Options]*/
Mounting_Method = "Threaded Snap Connector (Recommended)"; //[Direct Screw]

/*[All Channels]*/

//width of channel in units (default unit is 25mm)
Channel_Width_in_Units = 1;
//height inside the channel (in mm)
Channel_Internal_Height = 12; //[12:6:72]
//View the parts as they attach. Note that you must disable this before exporting for printing. 
Show_Attached = false;



/*[Straight Channels]*/
Straight_Copies = 1;
//length of channel in units (default unit is 25mm)
Channel_Length_Units = 5; 

/*[L Channels]*/
L_Channel_Length_in_Units = 1;

/*[Curved Channels]*/
Curve_Radius_in_Units = 2;

/*[Advanced Options]*/
//Units of measurement (in mm) for hole and length spacing. Multiboard is 25mm.
Grid_Size = 25;
Curve_Resolution = 25;
Global_Color = "SlateBlue"; //SlateBlue

/*[Label]*/
Add_Label = true;
Text = "Hands on Katie";  // Text to be displayed
Text_x_coordinate = 0;  // Adjusting the x position of the text
Font = "Noto Sans SC"; // [HarmonyOS Sans, Inter, Inter Tight, Lora, Merriweather Sans, Montserrat, Noto Sans, Noto Sans SC:Noto Sans China, Noto Sans KR, Noto Emoji, Nunito, Nunito Sans, Open Sans, Open Sans Condensed, Oswald, Playfair Display, Plus Jakarta Sans, Raleway, Roboto, Roboto Condensed, Roboto Flex, Roboto Mono, Roboto Serif, Roboto Slab, Rubik, Source Sans 3, Ubuntu Sans, Ubuntu Sans Mono, Work Sans]
Font_Style = "Regular"; // [Regular,Black,Bold,ExtraBol,ExtraLight,Light,Medium,SemiBold,Thin,Italic,Black Italic,Bold Italic,ExtraBold Italic,ExtraLight Italic,Light Italic,Medium Italic,SemiBold Italic,Thin Italic]
Text_size = 8;    // Font size

surname_font = str(Font , ":style=", Font_Style);

/*[Hidden]*/
channelWidth = Channel_Width_in_Units * Grid_Size;
baseHeight = 9.63;
topHeight = 10.968;
interlockOverlap = 3.09; //distance that the top and base overlap each other
interlockFromFloor = 6.533; //distance from the bottom of the base to the bottom of the top when interlocked
partSeparation = 10;
//mm that the snap protrudes from the board
Snap_Offset = 3;
Snap_Holding_Tolerance = 1; //[0.5:0.05:1.5]
Snap_Thread_Height = 3.6;



///*[Small Screw]*/
//Distance (in mm) between threads
Pitch_Sm = 3;
//Diameter (in mm) at the outer threads
Outer_Diameter_Sm = 6.747;
//Angle of the one side of the thread
Flank_Angle_Sm = 60;
//Depth (in mm) of the thread
Thread_Depth_Sm = 0.5;
//Diameter of the hole down the middle of the screw
Inner_Hole_Diameter_Sm = 3.3;
//length of the threaded portion of small screw
Thread_Length_Sm = 9;

///*[Large Screw]*/
//Distance (in mm) between threads
Pitch_Lg = 2.5;
//Diameter (in mm) at the outer threads
Outer_Diameter_Lg = 22.245;
//Angle of the one side of the thread
Flank_Angle_Lg = 45;
//Depth (in mm) of the thread
Thread_Depth_Lg = 0.75;
//Diameter of the hole down the middle of the bolt
Inner_Hole_Diameter_Lg = 10;

//Part Size Calculations
straight_channel_Y = Grid_Size * Channel_Length_Units;
radius_channel_Y = Grid_Size + channelWidth + (Curve_Radius_in_Units*channelWidth/2 - channelWidth/2)/2 - channelWidth/2;
l_channel_Y = channelWidth*1.5 + Grid_Size * L_Channel_Length_in_Units;
x_channel_X = channelWidth+Grid_Size*2;
x_channel_Y = channelWidth+Grid_Size*2;
/*

***BEGIN DISPLAYS***

*/
!straightChannelTop(lengthMM = 150, widthMM = 25);

/*

MOUNTING PARTS

*/

if(Mounting_Method == "Threaded Snap Connector (Recommended)")
    color(Global_Color)
    right(channelWidth+ 25)
    make_ThreadedSnap();

//Small MB Screw based on step file
if(Mounting_Method == "Direct Screw")
color(Global_Color)
diff()
right(channelWidth+25) fwd(30)
cyl(d=12,h=2.5, $fn=6, anchor=BOT, chamfer2=0.6){
    attach(TOP, BOT) trapezoidal_threaded_rod(d=Outer_Diameter_Sm, l=Thread_Length_Sm, pitch=Pitch_Sm, flank_angle = Flank_Angle_Sm, thread_depth = Thread_Depth_Sm, $fn=50, bevel2 = true, blunt_start=false);
    tag("remove")attach(BOT, BOT, inside=true, shiftout=0.01) cyl(h=16.01, d= Inner_Hole_Diameter_Sm, $fn=25, chamfer1=-1);
}

//Large MB Screw based on step file (not used yet)
if(Mounting_Method == "Large Bolt")
color(Global_Color)
diff()
right(channelWidth+25) back(30)
cyl(d=30,h=2.5, $fn=6, anchor=BOT, chamfer2=0.6){
    attach(TOP, BOT) trapezoidal_threaded_rod(d=Outer_Diameter_Lg, l=10, pitch=Pitch_Lg, flank_angle = Flank_Angle_Lg, thread_depth = Thread_Depth_Lg, $fn=50, bevel2 = true, blunt_start=false);
    tag("remove")attach(BOT, BOT, inside=true, shiftout=0.01) cyl(h=16.01, d= Inner_Hole_Diameter_Lg, $fn=25 );
}

/*

CHANNELS

*/

if(L_Channel){
color(Global_Color)
    back(straight_channel_Y/2 + l_channel_Y/2 + partSeparation)
    left(Show_Attached ? 0 : partSeparation)
        lChannelBase(lengthMM = L_Channel_Length_in_Units * Grid_Size, widthMM = Channel_Width_in_Units * Grid_Size, anchor=Show_Attached ? BOT : BOT+RIGHT);
color(Global_Color)
    up(Show_Attached ? interlockFromFloor : 0)
    back(straight_channel_Y/2 + l_channel_Y/2 + partSeparation)
    right(Show_Attached ? 0 : partSeparation)
        lChannelTop(lengthMM = L_Channel_Length_in_Units * Grid_Size, widthMM = Channel_Width_in_Units * Grid_Size, heightMM = Channel_Internal_Height, anchor= Show_Attached ? BOT : TOP+RIGHT, orient=Show_Attached ? TOP : BOT);
}


if(Straight){
color(Global_Color)
    xcopies(n=Straight_Copies, spacing = Show_Attached ? channelWidth+5 : channelWidth*2 + partSeparation){
        left(Show_Attached ? 0 : channelWidth/2)
            straightChannelBase(lengthMM = Channel_Length_Units * Grid_Size, widthMM = channelWidth, anchor=BOT);
color(Global_Color)
        right(Show_Attached ? 0 : channelWidth/2 + 5)
        up(Show_Attached ? interlockFromFloor : 0)
            straightChannelTop(lengthMM = Channel_Length_Units * Grid_Size, widthMM = channelWidth, heightMM = Channel_Internal_Height, anchor=Show_Attached ? BOT : TOP, orient=Show_Attached ? TOP : BOT);
    }
}

if(C_Curve){
color(Global_Color)
    back(straight_channel_Y / 2 + radius_channel_Y + l_channel_Y + partSeparation)
    left(Show_Attached ? 0 : radius_channel_Y + partSeparation / 2)
        curvedChannelBase(radiusMM = Curve_Radius_in_Units*channelWidth/2, widthMM = channelWidth, anchor=BOT);
color(Global_Color)
    back(straight_channel_Y / 2 + radius_channel_Y + l_channel_Y + partSeparation)
    right(Show_Attached ? 0 : radius_channel_Y + partSeparation / 2)
    up(Show_Attached ? interlockFromFloor : 0)
        curvedChannelTop(radiusMM = Curve_Radius_in_Units*channelWidth/2, widthMM = channelWidth, heightMM = Channel_Internal_Height, anchor = Show_Attached ? BOT : TOP, orient= Show_Attached ? TOP : BOT);
}

if(X_Intersection){
    //cross intersection
color(Global_Color)
    fwd(straight_channel_Y / 2 + x_channel_Y/2 + partSeparation) 
    left(Show_Attached ? 0 : x_channel_X / 2 + partSeparation/2)
        crossIntersectionBase(widthMM = channelWidth, anchor=BOT);
color(Global_Color)
    fwd(straight_channel_Y / 2 + x_channel_Y/2 + partSeparation) 
    right(Show_Attached ? 0 : x_channel_X / 2 + partSeparation/2)
    up(Show_Attached ? interlockFromFloor : 0) 
        crossIntersectionTop(widthMM = channelWidth, heightMM = Channel_Internal_Height, anchor=Show_Attached ? BOT : TOP, orient= Show_Attached ? TOP : BOT);
}

if(T_Intersection){
color(Global_Color)
    fwd(straight_channel_Y / 2 + x_channel_Y*1.75 + partSeparation)  
    left(Show_Attached ? 0 : partSeparation)
        tIntersectionBase(widthMM = channelWidth, anchor=Show_Attached ? BOT : BOT+RIGHT);
color(Global_Color)
    fwd(straight_channel_Y / 2 + x_channel_Y*1.75 + partSeparation)  
    right(Show_Attached ? 0 : partSeparation)
    up(Show_Attached ? interlockFromFloor : 0) 
        tIntersectionTop(widthMM = channelWidth, heightMM = Channel_Internal_Height, anchor=Show_Attached ? BOT : TOP+RIGHT, orient= Show_Attached ? TOP : BOT);
}

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
            if(Mounting_Method == "Direct Screw") cyl(h=8, d=7, $fn=25);
            else up(6.5) trapezoidal_threaded_rod(d=Outer_Diameter_Sm, l=9, pitch=Pitch_Sm, flank_angle = Flank_Angle_Sm, thread_depth = Thread_Depth_Sm, $fn=50, bevel2 = true, blunt_start=false, anchor=TOP);
    children();
    }
}



module straightChannelTop(lengthMM, widthMM, heightMM = 12, anchor, spin, orient){
    attachable(anchor, spin, orient, size=[widthMM, lengthMM, topHeight + (heightMM-12)]){
        fwd(lengthMM/2) down(10.968/2 + (heightMM - 12)/2)
        zrot(90) path_sweep(topProfile(widthMM = widthMM, heightMM = heightMM), turtle(["xmove", lengthMM])) 
        if(Add_Label) 
            color("Pink")
            fwd(Text_size/2)attach(TOP, BOT)linear_extrude(height = 0.01)
                text(Text, size = Text_size, font = surname_font, halign = "center", valign = "center");
    children();
    }
}

module straightChannelBaseDeleteTool(lengthMM, widthMM, anchor, spin, orient){
    attachable(anchor, spin, orient, size=[widthMM, lengthMM, baseHeight]){
        fwd(lengthMM/2) down(maxY(baseProfileHalf)/2)
        zrot(90) path_sweep(baseDeleteProfile(widthMM = widthMM), turtle(["xmove", lengthMM])); 
    children();
    }
}

module straightChannelTopDeleteTool(lengthMM, widthMM, heightMM = 12, anchor, spin, orient){
    attachable(anchor, spin, orient, size=[widthMM, lengthMM, topHeight + (heightMM-12)]){
        fwd(lengthMM/2) down(topHeight/2 + (heightMM - 12)/2)
        zrot(90) path_sweep(topDeleteProfile(widthMM = widthMM, heightMM = heightMM), turtle(["xmove", lengthMM])); 
    children(); 
    }
}

//L CHANNELS
module lChannelBase(lengthMM = 50, widthMM = 25, anchor, spin, orient){
    attachable(anchor, spin, orient, size=[widthMM+lengthMM, widthMM+lengthMM, baseHeight]){
        let(calculatedPath = widthMM/2+lengthMM)
        left(widthMM/2+lengthMM/2) fwd(lengthMM/2)
        down(baseHeight/2)
        diff("holes"){
            path_sweep2d(baseProfile(widthMM = widthMM), turtle(["move", calculatedPath, "turn", 90, "move",calculatedPath] )); 
            tag("holes") right(widthMM/2+lengthMM/2) back(lengthMM/2) grid_copies(spacing=Grid_Size, inside=rect([widthMM+lengthMM-1,widthMM+lengthMM-1])) 
                if(Mounting_Method == "Direct Screw") cyl(h=8, d=7, $fn=25);
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

//CURVED CHANNELS
module curvedChannelBase(radiusMM, widthMM, anchor, spin, orient){
    attachable(anchor, spin, orient, size=[Grid_Size + channelWidth + (radiusMM - channelWidth/2), Grid_Size + channelWidth + (radiusMM - channelWidth/2), baseHeight]){ //Curve_Radius_in_Units*channelWidth/2
        let(adjustedWidth = Grid_Size + channelWidth + (radiusMM - channelWidth/2))
        fwd((Grid_Size + channelWidth + (radiusMM - channelWidth/2))/2 - channelWidth/2) 
        left((Grid_Size + channelWidth + (radiusMM - channelWidth/2))/2) 
        down(baseHeight/2)
            diff("holes"){
                path_sweep(baseProfile(widthMM = widthMM), turtle(["move", Grid_Size, "arcleft", radiusMM, 90, "move", Grid_Size])) {
                    tag("holes") ycopies(spacing = Grid_Size, n = Channel_Width_in_Units) right(Grid_Size/2) down(0.01) 
                        if(Mounting_Method == "Direct Screw") cyl(h=8, d=7, $fn=25);
                        else up(6.5) trapezoidal_threaded_rod(d=Outer_Diameter_Sm, l=9, pitch=Pitch_Sm, flank_angle = Flank_Angle_Sm, thread_depth = Thread_Depth_Sm, $fn=50, bevel2 = true, blunt_start=false, anchor=TOP);
                    tag("holes") xcopies(spacing = Grid_Size, n = Channel_Width_in_Units) right(Grid_Size + channelWidth/2 + (radiusMM - channelWidth/2)) back(channelWidth/2 + Grid_Size/2 + (radiusMM - channelWidth/2)) down(0.01) 
                        if(Mounting_Method == "Direct Screw") cyl(h=8, d=7, $fn=25);
                        else up(6.5) trapezoidal_threaded_rod(d=Outer_Diameter_Sm, l=9, pitch=Pitch_Sm, flank_angle = Flank_Angle_Sm, thread_depth = Thread_Depth_Sm, $fn=50, bevel2 = true, blunt_start=false, anchor=TOP);
                }
            }
        children();
    }
}

module curvedChannelTop(radiusMM, widthMM, heightMM = 12, anchor, spin, orient){
    attachable(anchor, spin, orient, size=[Grid_Size + channelWidth + (radiusMM - channelWidth/2), Grid_Size + channelWidth + (radiusMM - channelWidth/2), topHeight]){
        fwd((Grid_Size + channelWidth + (radiusMM - channelWidth/2))/2 - channelWidth/2) 
        left((Grid_Size + channelWidth + (radiusMM - channelWidth/2))/2)  
        down(topHeight/2 + (heightMM - 12)/2)
        path_sweep(topProfile(widthMM = widthMM, heightMM = heightMM), turtle(["move", Grid_Size, "arcleft", radiusMM, 90, "move", Grid_Size])); 
        children();
    }
}

//X CHANNELS
module crossIntersectionBase(widthMM, anchor, spin, orient){
    attachable(anchor, spin, orient, size=[channelWidth+Grid_Size*2, channelWidth+Grid_Size*2, baseHeight]){
        diff("channelClear holes"){
        down(baseHeight/2)left((channelWidth/2+Grid_Size)) path_sweep(baseProfile(widthMM = widthMM), turtle(["xmove", channelWidth+Grid_Size*2]));
        down(baseHeight/2)fwd(channelWidth/2+Grid_Size) zrot(90)path_sweep(baseProfile(widthMM = widthMM), turtle(["xmove", channelWidth+Grid_Size*2]));
        //zrot_copies(n=4) straightChannelBase(lengthMM = Grid_Size*3, widthMM = channelWidth) //old approach with unwanted straight channel inheritance
        tag("channelClear") zrot_copies(n=4) straightChannelBaseDeleteTool(widthMM = channelWidth+0.02, lengthMM = Grid_Size+channelWidth); 
        tag("holes") down(4)grid_copies(spacing=Grid_Size, inside=rect([x_channel_X-1,x_channel_Y-1])) 
            if(Mounting_Method == "Direct Screw") cyl(h=8, d=7, $fn=25);
            else up(6.5) trapezoidal_threaded_rod(d=Outer_Diameter_Sm, l=9, pitch=Pitch_Sm, flank_angle = Flank_Angle_Sm, thread_depth = Thread_Depth_Sm, $fn=50, bevel2 = true, blunt_start=false, anchor=TOP);
        }
        children();
    }
}

module crossIntersectionTop(widthMM, heightMM = 12, anchor, spin, orient){
    attachable(anchor, spin, orient, size=[Grid_Size*3, Grid_Size*3, topHeight + (heightMM-12)]){
    down((topHeight + (heightMM-12))/2)
    diff("channelClear"){
        left((channelWidth/2+Grid_Size)) path_sweep(topProfile(widthMM = widthMM, heightMM = heightMM), turtle(["xmove", channelWidth+Grid_Size*2]));
        fwd(channelWidth/2+Grid_Size) zrot(90) path_sweep(topProfile(widthMM = widthMM, heightMM = heightMM), turtle(["xmove", channelWidth+Grid_Size*2]));
        tag("channelClear") zrot_copies(n=4) straightChannelTopDeleteTool(widthMM = channelWidth+0.02, lengthMM = Grid_Size+channelWidth, heightMM = heightMM, anchor=BOT); 
    }
    children();
    }
}

//T CHANNELS
module tIntersectionBase(widthMM, anchor, spin, orient){
    attachable(anchor, spin, orient, size=[channelWidth+Grid_Size, channelWidth+Grid_Size*2, baseHeight]){
        down(baseHeight/2) 
        left(Grid_Size/2)
        union(){
        diff("channelClear holes")
        //side channel
        path_sweep(baseProfile(widthMM = widthMM), turtle(["move", channelWidth/2 + Grid_Size])){
            tag("channelClear") zrot(90) fwd(channelWidth/2) straightChannelBaseDeleteTool(widthMM = channelWidth+0.02, lengthMM = channelWidth/2 + Grid_Size, anchor=BOT);
        //long channel
        zrot(90) left(channelWidth/2+Grid_Size)path_sweep(baseProfile(widthMM = widthMM), turtle(["move", channelWidth+Grid_Size*2]));
        tag("channelClear") straightChannelBaseDeleteTool(widthMM = channelWidth+0.02, lengthMM = channelWidth+Grid_Size*2, anchor=BOT);
        tag("holes") grid_copies(n=2+Channel_Width_in_Units, spacing=Grid_Size) 
            if(Mounting_Method == "Direct Screw") cyl(h=8, d=7, $fn=25);
            else up(6.5) trapezoidal_threaded_rod(d=Outer_Diameter_Sm, l=9, pitch=Pitch_Sm, flank_angle = Flank_Angle_Sm, thread_depth = Thread_Depth_Sm, $fn=50, bevel2 = true, blunt_start=false, anchor=TOP);
        }
        }
        children();
    }
}

module tIntersectionTop(widthMM, heightMM, anchor, spin, orient){
    attachable(anchor, spin, orient, size=[channelWidth+Grid_Size, channelWidth+Grid_Size*2, topHeight + (heightMM-12)]){
        down((topHeight + (heightMM-12))/2) left(Grid_Size/2)
        diff("channelClear")
        //side channel
        path_sweep(topProfile(widthMM = widthMM, heightMM = heightMM), turtle(["move", channelWidth/2 + Grid_Size])){
            tag("channelClear") zrot(90) fwd(channelWidth/2) straightChannelTopDeleteTool(widthMM = channelWidth+0.02, lengthMM = channelWidth/2 + Grid_Size, heightMM = heightMM, anchor=BOT);
        //long channel
        zrot(90) left(channelWidth/2+Grid_Size)path_sweep(topProfile(widthMM = widthMM, heightMM = heightMM), turtle(["move", channelWidth+Grid_Size*2]));
            tag("channelClear") straightChannelTopDeleteTool(widthMM = channelWidth+0.02, lengthMM = channelWidth+Grid_Size*2, heightMM = heightMM, anchor=BOT);

        }
        children();
    }
}

module make_ThreadedSnap (anchor=CENTER,spin=0,orient=UP){
    snapConnectBacker(offset = 3, holdingTolerance = Snap_Holding_Tolerance) {
        attach(TOP, BOT, overlap=0.01) trapezoidal_threaded_rod(d=Outer_Diameter_Sm, l=Snap_Thread_Height, pitch=Pitch_Sm, flank_angle = Flank_Angle_Sm, thread_depth = Thread_Depth_Sm, $fn=50, bevel2 = true, blunt_start=false, anchor=anchor,spin=spin,orient=orient);
        children();
    }
}

//BEGIN PROFILES

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


/*

BEGIN SNAP CONNECTOR

*/

module snapConnectBacker(offset = 0, holdingTolerance=1, anchor=CENTER, spin=0, orient=UP){
    attachable(anchor, spin, orient, size=[11.4465*2, 11.4465*2, 6.17+offset]){ 
    //bumpout profile
    bumpout = turtle([
        "ymove", -2.237,
        "turn", 40,
        "move", 0.557,
        "arcleft", 0.5, 50,
        "ymove", 0.252
        ]   );

    down(6.2/2+offset/2)
    union(){
    diff("remove")
        //base
            oct_prism(h = 4.23, r = 11.4465, anchor=BOT) {
                //first bevel
                attach(TOP, BOT, shiftout=-0.01) oct_prism(h = 1.97, r1 = 11.4465, r2 = 12.5125, $fn =8, anchor=BOT)
                    //top - used as offset. Independen snap height is 2.2
                    attach(TOP, BOT, shiftout=-0.01) oct_prism(h = offset, r = 12.9885, anchor=BOTTOM);
                        //top bevel - not used when applied as backer
                        //position(TOP) oct_prism(h = 0.4, r1 = 12.9985, r2 = 12.555, anchor=BOTTOM);
            
            //end base
            //bumpouts
            attach([RIGHT, LEFT, FWD, BACK],LEFT, shiftout=-0.01)  color("green") down(0.87) fwd(1)scale([1,1,holdingTolerance])offset_sweep(path = bumpout, height=3, spin=[0,270,0]);
            //delete tools
            //Bottom and side cutout - 2 cubes that form an L (cut from bottom and from outside) and then rotated around the side
            tag("remove") 
                 align(BOTTOM, [RIGHT, BACK, LEFT, FWD], inside=true, shiftout=0.01, inset = 1.6) 
                    color("lightblue") cuboid([0.8,7.161,3.4], spin=90*$idx)
                        align(RIGHT, [TOP]) cuboid([0.8,7.161,1], anchor=BACK);
            }
    }
    children();
    }

    //octo_prism - module that creates an oct_prism with anchors positioned on the faces instead of the edges (as per cyl default for 8 sides)
    module oct_prism(h, r=0, r1=0, r2=0, anchor=CENTER, spin=0, orient=UP) {
        attachable(anchor, spin, orient, size=[max(r*2, r1*2, r2*2), max(r*2, r1*2, r2*2), h]){ 
            down(h/2)
            if (r != 0) {
                // If r is provided, create a regular octagonal prism with radius r
                rotate (22.5) cylinder(h=h, r1=r, r2=r, $fn=8) rotate (-22.5);
            } else if (r1 != 0 && r2 != 0) {
                // If r1 and r2 are provided, create an octagonal prism with different top and bottom radii
                rotate (22.5) cylinder(h=h, r1=r1, r2=r2, $fn=8) rotate (-22.5);
            } else {
                echo("Error: You must provide either r or both r1 and r2.");
            }  
            children(); 
        }
    }
    
}