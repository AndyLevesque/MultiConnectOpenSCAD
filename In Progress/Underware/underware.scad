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
Small_Screw = true;
Large_Screw = true;

/*[All Channels]*/
//width of channel in units (default unit is 25mm)
Channel_Width_in_Units = 1;
//height inside the channel (in mm)
Channel_Internal_Height = 12; //[12:6:72]
//View the parts as they attach. Note that you must disable this before exporting for printing. 
Show_Attached = false;

/*[Mounting Options]*/
Mount_Method = "Screw"; //[Screw]

/*[Straight Channels]*/
Straight_Copies = 1;
//length of channel in units (default unit is 25mm)
Channel_Length_Units = 5; 

/*[L Channels]*/
L_Channel_Length_in_Units = 2;

/*[Curved Channels]*/
Curve_Radius_in_Units = 2;

/*[Advanced Options]*/
//Units of measurement (in mm) for hole and length spacing. Multiboard is 25mm.
Grid_Size = 25;
Curve_Resolution = 25;
Global_Color = "SlateBlue";

/*[Small Screw]*/
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

/*[Large Screw]*/
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

/*[Hidden]*/
channelWidth = Channel_Width_in_Units * Grid_Size;
baseHeight = 9.63;
topHeight = 10.968;
interlockOverlap = 3.09; //distance that the top and base overlap each other
interlockFromFloor = 6.533; //distance from the bottom of the base to the bottom of the top when interlocked
partSeparation = 10;

//Part Size Calculations
straight_channel_Y = Grid_Size * Channel_Length_Units;
radius_channel_Y = Grid_Size + channelWidth + (Curve_Radius_in_Units*channelWidth/2 - channelWidth/2)/2 - channelWidth/2;
l_channel_Y = L_Channel_Length_in_Units*Grid_Size + Channel_Width_in_Units * Grid_Size / 2;
x_channel_X = channelWidth+Grid_Size*2;
x_channel_Y = channelWidth+Grid_Size*2;
/*

***BEGIN DISPLAYS***

*/

//Small MB Screw first Try
//cyl(d=12,h=2.5, $fn=6, anchor=BOT)
//    attach(TOP, BOT) trapezoidal_threaded_rod(d=6.75, l=10, pitch=3, flank_angle = 90-29.05, thread_depth = 0.5, $fn=50, bevel2 = true);

//!tIntersectionBase(widthMM = channelWidth) show_anchors();

//Small MB Screw based on step file
if(Small_Screw)
color(Global_Color)
diff()
right(channelWidth*2)
cyl(d=12,h=2.5, $fn=6, anchor=BOT, chamfer2=0.6){
    attach(TOP, BOT) trapezoidal_threaded_rod(d=Outer_Diameter_Sm, l=Thread_Length_Sm, pitch=Pitch_Sm, flank_angle = Flank_Angle_Sm, thread_depth = Thread_Depth_Sm, $fn=50, bevel2 = true, blunt_start=false);
    tag("remove")attach(BOT, BOT, inside=true, shiftout=0.01) cyl(h=16.01, d= Inner_Hole_Diameter_Sm, $fn=25, chamfer1=-1);
}

//Large MB Screw based on step file
if(Large_Screw)
color(Global_Color)
diff()
left(channelWidth*2)
cyl(d=30,h=2.5, $fn=6, anchor=BOT, chamfer2=0.6){
    attach(TOP, BOT) trapezoidal_threaded_rod(d=Outer_Diameter_Lg, l=10, pitch=Pitch_Lg, flank_angle = Flank_Angle_Lg, thread_depth = Thread_Depth_Lg, $fn=50, bevel2 = true, blunt_start=false);
    tag("remove")attach(BOT, BOT, inside=true, shiftout=0.01) cyl(h=16.01, d= Inner_Hole_Diameter_Lg, $fn=25 );
}

if(L_Channel){
color(Global_Color)
    back(straight_channel_Y/2 + l_channel_Y/2 + partSeparation)
    left(Show_Attached ? 0 : l_channel_Y / 2 + partSeparation/2)
        lChannelBase(lengthMM = L_Channel_Length_in_Units * Grid_Size, widthMM = Channel_Width_in_Units * Grid_Size, anchor=BOT);
color(Global_Color)
    up(Show_Attached ? interlockFromFloor : 0)
    back(straight_channel_Y/2 + l_channel_Y/2 + partSeparation)
    right(Show_Attached ? 0 : l_channel_Y / 2 + partSeparation/2)
        lChannelTop(lengthMM = L_Channel_Length_in_Units * Grid_Size, widthMM = Channel_Width_in_Units * Grid_Size, heightMM = Channel_Internal_Height, anchor=Show_Attached ? BOT : TOP, orient=Show_Attached ? TOP : BOT);
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
    fwd(Channel_Length_Units*Grid_Size/2 + Grid_Size * 3 / 2 + partSeparation) 
    left(Show_Attached ? 0 : x_channel_X / 2 + partSeparation/2)
        crossIntersectionBase(widthMM = channelWidth, anchor=BOT);
color(Global_Color)
    fwd(Channel_Length_Units*Grid_Size/2 + Grid_Size * 3 / 2 + partSeparation) 
    right(Show_Attached ? 0 : x_channel_X / 2 + partSeparation/2)
    up(Show_Attached ? interlockFromFloor : 0) 
        crossIntersectionTop(widthMM = channelWidth, heightMM = Channel_Internal_Height, anchor=Show_Attached ? BOT : TOP, orient= Show_Attached ? TOP : BOT);
}

if(T_Intersection){
color(Global_Color)
    fwd(Channel_Length_Units*Grid_Size/2 + Grid_Size * 5 + partSeparation)  
    left(Show_Attached ? 0 : Grid_Size * 3 / 2+5)
        tIntersectionBase(widthMM = channelWidth, anchor=BOT);
color(Global_Color)
    fwd(Channel_Length_Units*Grid_Size/2 + Grid_Size * 5 + partSeparation)  
    right(Show_Attached ? 0 : Grid_Size * 3 / 2+5)
    up(Show_Attached ? interlockFromFloor : 0) 
        tIntersectionTop(widthMM = channelWidth, heightMM = Channel_Internal_Height, anchor=Show_Attached ? BOT : TOP, orient= Show_Attached ? TOP : BOT);
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
        tag("holes")  xcopies(n = lengthMM / Grid_Size, spacing = Grid_Size, sp = [Grid_Size/2,0]) 
            cyl(h=8, d=7, $fn=25);
    children();
    }
}



module straightChannelTop(lengthMM, widthMM, heightMM = 12, anchor, spin, orient){
    attachable(anchor, spin, orient, size=[widthMM, lengthMM, topHeight + (heightMM-12)]){
        fwd(lengthMM/2) down(10.968/2 + (heightMM - 12)/2)
        zrot(90) path_sweep(topProfile(widthMM = widthMM, heightMM = heightMM), turtle(["xmove", lengthMM])); 
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
    attachable(anchor, spin, orient, size=[lengthMM + widthMM/2, lengthMM + widthMM/2, baseHeight]){
        left(lengthMM/2 + widthMM/4) fwd(lengthMM/2 - widthMM/4) down(baseHeight/2)
        path_sweep2d(baseProfile(widthMM = widthMM), [[0,0],[lengthMM,0],[lengthMM,lengthMM]]); 
    children();
    }
}
module lChannelTop(lengthMM = 50, widthMM = 25, heightMM = 12, anchor, spin, orient){
    attachable(anchor, spin, orient, size=[lengthMM + widthMM/2, lengthMM + widthMM/2, topHeight + (heightMM-12)]){
        left(lengthMM/2 + widthMM/4) fwd(lengthMM/2 - widthMM/4) down(topHeight/2 + (heightMM - 12)/2)
        path_sweep2d(topProfile(widthMM = widthMM, heightMM = heightMM), [[0,0],[lengthMM,0],[lengthMM,lengthMM]]); 
    children();
    }
}

//CURVED CHANNELS
module curvedChannelBase(radiusMM, widthMM, anchor, spin, orient){
    attachable(anchor, spin, orient, size=[Grid_Size + channelWidth + (radiusMM - channelWidth/2), Grid_Size + channelWidth + (radiusMM - channelWidth/2), baseHeight]){ //Curve_Radius_in_Units*channelWidth/2
        fwd((Grid_Size + channelWidth + (radiusMM - channelWidth/2))/2 - channelWidth/2) 
        left((Grid_Size + channelWidth + (radiusMM - channelWidth/2))/2) 
        down(baseHeight/2)
            path_sweep(baseProfile(widthMM = widthMM), turtle(["move", Grid_Size, "arcleft", radiusMM, 90, "move", Grid_Size])); 
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
        tag("holes") down(4)grid_copies(spacing=Grid_Size, inside=rect([x_channel_X-1,x_channel_Y-1])) cyl(h=8, d=7, $fn=25);
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
        down(baseHeight/2) left(channelWidth/2)
        union(){
        diff("channelClear holes")
        //side channel
        path_sweep(baseProfile(widthMM = widthMM), turtle(["move", channelWidth/2 + Grid_Size])){
            tag("channelClear") zrot(90) fwd(channelWidth/2) straightChannelBaseDeleteTool(widthMM = channelWidth+0.02, lengthMM = channelWidth/2 + Grid_Size, anchor=BOT);
        //long channel
        zrot(90) left(channelWidth/2+Grid_Size)path_sweep(baseProfile(widthMM = widthMM), turtle(["move", channelWidth+Grid_Size*2]));
        tag("channelClear") straightChannelBaseDeleteTool(widthMM = channelWidth+0.02, lengthMM = channelWidth+Grid_Size*2, anchor=BOT);
        tag("holes") grid_copies(n=2+Channel_Width_in_Units, spacing=Grid_Size) cyl(h=8, d=7, $fn=25);
        }
        }
        children();
    }
}

module tIntersectionTop(widthMM, heightMM, anchor, spin, orient){
    attachable(anchor, spin, orient, size=[Grid_Size*2, Grid_Size*3, topHeight + (heightMM-12)]){
        right(Grid_Size/2)
        diff()
        straightChannelTop(lengthMM = Grid_Size*3, widthMM = channelWidth, heightMM = heightMM){
            attach(BOT, BOT, inside=true, overlap=0.01) straightChannelTopDeleteTool(widthMM = channelWidth+0.02, lengthMM = Grid_Size+channelWidth, heightMM = heightMM);
            attach(LEFT,FRONT, overlap=5) straightChannelTop(lengthMM = Grid_Size+5, widthMM = channelWidth, heightMM = heightMM)
                attach(BOT, BOT, inside=true, overlap=0.01) straightChannelTopDeleteTool(widthMM = channelWidth+0.02, lengthMM = Grid_Size+channelWidth, heightMM = heightMM);;
        }
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