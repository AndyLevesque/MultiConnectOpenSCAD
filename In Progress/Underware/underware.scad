/*Created by Hands on Katie and BlackjackDuck (Andy)
Credit to 
    Katie (and her community) at Hands on Katie on Youtube and Patreon
    @David D on Printables for Multiconnect
    Jonathan at Keep Making for MulticonnMultiboard
    
Licensed Creative Commons 4.0 Attribution Non-Commercial Sharable with Attribution
*/

include <BOSL2/std.scad>
include <BOSL2/rounding.scad>

/*[Chose Parts]*/
Straight = true;
C_Curve = true;
Cross_Intersection = true;
T_Intersection = true;

/*[All Channels]*/
//width of channel in units (default unit is 25mm)
Channel_Width_in_Units = 1;

/*[Straight Channels]*/
Number_of_Straight_Channels = 2;
//length of channel in units (default unit is 25mm)
Channel_Length_Units = 5; 


/*[Curved Channels]*/
Curve_Radius_in_Units = 2;

/*[Advanced Options]*/
//Units of measurement (in mm) for hole and length spacing. Multiboard is 25mm.
Grid_Size = 25;
Curve_Resolution = 25;

/*[Hidden]*/
channelWidth = Channel_Width_in_Units * Grid_Size;
baseHeight = 9.63;
topHeight = 10.968;
interlockOverlap = 3.09;
interlockFromFloor = 6.533;

if(Straight){
xcopies(n=Number_of_Straight_Channels, spacing = channelWidth+5)
straightChannelBase(lengthMM = Channel_Length_Units * Grid_Size, widthMM = channelWidth, anchor=BOT);
up(interlockFromFloor) straightChannelTop(lengthMM = Channel_Length_Units * Grid_Size, widthMM = channelWidth, anchor=BOT);
}

//straightChannelTop(lengthMM = Channel_Length_Units * Grid_Size, widthMM = channelWidth);
//#straightChannelTopDeleteTool(lengthMM = Channel_Length_Units * Grid_Size, widthMM = channelWidth);

if(C_Curve){
right(Curve_Radius_in_Units * Grid_Size + channelWidth + 5) 
    curvedChannelBase(radiusMM = Curve_Radius_in_Units*Grid_Size, widthMM = channelWidth);

right(Curve_Radius_in_Units * Grid_Size + channelWidth + 5) 
    up(interlockFromFloor)
    curvedChannelTop(radiusMM = Curve_Radius_in_Units*Grid_Size, widthMM = channelWidth);
}

if(Cross_Intersection){
//cross intersection
left(55) crossIntersectionBase(widthMM = channelWidth, anchor=BOT);
left(55) up(interlockFromFloor) crossIntersectionTop(widthMM = channelWidth, anchor=BOT);
}

if(T_Intersection){
left(55) fwd(80)tIntersectionBase(widthMM = channelWidth, anchor=BOT);
left(55) fwd(80) up(interlockFromFloor)tIntersectionTop(widthMM = channelWidth, anchor=BOT);
}

//BEGIN MODULES

module straightChannelBase(lengthMM, widthMM, anchor, spin, orient){
    attachable(anchor, spin, orient, size=[widthMM, lengthMM, baseHeight]){
        fwd(lengthMM/2) down(maxY(baseProfileHalf)/2)
        zrot(90) path_sweep(baseProfile(widthMM), turtle(["xmove", lengthMM])); 
    children();
    }
}

module straightChannelBaseDeleteTool(lengthMM, widthMM, anchor, spin, orient){
    attachable(anchor, spin, orient, size=[widthMM, lengthMM, baseHeight]){
        fwd(lengthMM/2) down(maxY(baseProfileHalf)/2)
        zrot(90) path_sweep(baseDeleteProfile(widthMM), turtle(["xmove", lengthMM])); 
    children();
    }
}

module straightChannelTop(lengthMM, widthMM, anchor, spin, orient){
    attachable(anchor, spin, orient, size=[widthMM, lengthMM, topHeight]){
        fwd(lengthMM/2) down(10.968/2)
        zrot(90) path_sweep(topProfile(widthMM), turtle(["xmove", lengthMM])); 
    children();
    }
}

module straightChannelTopDeleteTool(lengthMM, widthMM, anchor, spin, orient){
    attachable(anchor, spin, orient, size=[widthMM, lengthMM, topHeight]){
        fwd(lengthMM/2) down(10.968/2)
        zrot(90) path_sweep(topDeleteProfile(widthMM), turtle(["xmove", lengthMM])); 
    children(); 
    }
}

module curvedChannelBase(radiusMM, widthMM){
    zrot(90) path_sweep(baseProfile(widthMM), arc(r=radiusMM, angle = 90, n=Curve_Resolution)); 
}

module curvedChannelTop(radiusMM, widthMM){
    zrot(90) path_sweep(topProfile(widthMM), arc(r=radiusMM, angle = 90, n=Curve_Resolution)); 
}




module crossIntersectionBase(widthMM, anchor, spin, orient){
    attachable(anchor, spin, orient, size=[Grid_Size*3, Grid_Size*3, baseHeight]){
        diff()
        zrot_copies(n=4) straightChannelBase(lengthMM = Grid_Size*3, widthMM = channelWidth)
            attach(BOT, BOT, inside=true, overlap=0.01) straightChannelBaseDeleteTool(widthMM = channelWidth+0.02, lengthMM = Grid_Size+channelWidth);
        children();
    }
}

module crossIntersectionTop(widthMM, anchor, spin, orient){
    attachable(anchor, spin, orient, size=[Grid_Size*3, Grid_Size*3, topHeight]){
    diff()
    zrot_copies(n=4) straightChannelTop(lengthMM = Grid_Size*3, widthMM = channelWidth)
        attach(BOT, BOT, inside=true, overlap=0.01) straightChannelTopDeleteTool(widthMM = channelWidth+0.02, lengthMM = Grid_Size+channelWidth);
    children();
    }
}

module tIntersectionBase(widthMM, anchor, spin, orient){
    attachable(anchor, spin, orient, size=[Grid_Size*2, Grid_Size*3, baseHeight]){
        right(Grid_Size/2)
        diff()
        straightChannelBase(lengthMM = Grid_Size*3, widthMM = channelWidth){
            attach(BOT, BOT, inside=true, overlap=0.01) straightChannelBaseDeleteTool(widthMM = channelWidth+0.02, lengthMM = Grid_Size+channelWidth);
            attach(LEFT,FRONT, overlap=5) straightChannelBase(lengthMM = Grid_Size+5, widthMM = channelWidth)
                attach(BOT, BOT, inside=true, overlap=0.01) straightChannelBaseDeleteTool(widthMM = channelWidth+0.02, lengthMM = Grid_Size+channelWidth);;
        }
        children();
    }
}

module tIntersectionTop(widthMM, anchor, spin, orient){
    attachable(anchor, spin, orient, size=[Grid_Size*2, Grid_Size*3, topHeight]){
        right(Grid_Size/2)
        diff()
        straightChannelTop(lengthMM = Grid_Size*3, widthMM = channelWidth){
            attach(BOT, BOT, inside=true, overlap=0.01) straightChannelTopDeleteTool(widthMM = channelWidth+0.02, lengthMM = Grid_Size+channelWidth);
            attach(LEFT,FRONT, overlap=5) straightChannelTop(lengthMM = Grid_Size+5, widthMM = channelWidth)
                attach(BOT, BOT, inside=true, overlap=0.01) straightChannelTopDeleteTool(widthMM = channelWidth+0.02, lengthMM = Grid_Size+channelWidth);;
        }
        children();
    }
}

//BEGIN PROFILES

//take the two halves of base and merge them
function baseProfile(widthMM) = 
    union(
        left((widthMM-25)/2,baseProfileHalf), 
        right((widthMM-25)/2,mirror([1,0],baseProfileHalf)), //fill middle if widening from standard 25mm
        back(3.5/2,rect([widthMM-25+0.02,3.5]))
    );

//take the two halves of base and merge them
function topProfile(widthMM) = 
    union(
        left((widthMM-25)/2,topProfileHalf), 
        right((widthMM-25)/2,mirror([1,0],topProfileHalf)), //fill middle if widening from standard 25mm
        back(topHeight-1,rect([widthMM-25+0.02,2])) 
    );

function baseDeleteProfile(widthMM) = 
    union(
        left((widthMM-25)/2,baseDeleteProfileHalf), 
        right((widthMM-25)/2,mirror([1,0],baseDeleteProfileHalf)), //fill middle if widening from standard 25mm
        back(6.575,rect([widthMM-25+0.02,6.15]))
    );

function topDeleteProfile(widthMM) = 
    union(
        left((widthMM-25)/2,topDeleteProfileHalf), 
        right((widthMM-25)/2,mirror([1,0],topDeleteProfileHalf)), //fill middle if widening from standard 25mm
        back(4.474,rect([widthMM-25+0.02,8.988])) 
    );

baseProfileHalf = 
    fwd(-7.947, //take Katie's exact measurements for half the profile and use fwd to place flush on the Y axis
        //profile extracted from exact coordinates in Master Profile F360 sketch
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

topProfileHalf =
        back(1.414,//profile extracted from exact coordinates in Master Profile F360 sketch
        [
            [0,7.554],//-0.017 per Katie's diagram. Moved to zero
            [0,9.554],
            [-8.517,9.554],
            [-12.517,5.554],
            [-12.517,-1.414],
            [-11.166,-1.414],
            [-11.166,-0.592],
            [-11.459,-0.297],
            [-11.459,1.422],
            [-10.517,1.683],
            [-10.517,4.725],
            [-7.688,7.554]
        ]
        );

baseDeleteProfileHalf = 
    fwd(-7.947, //take Katie's exact measurements for half the profile of the inside
        //profile extracted from exact coordinates in Master Profile F360 sketch
        [
            [0,-4.447], //inner x axis point with width adjustment
            [0,1.683+0.02],
            [-9.5,1.683+0.02],
            [-9.5,-3.447],
            [-8.5,-4.447],
        ]
);

topDeleteProfileHalf =
        back(1.414,//profile extracted from exact coordinates in Master Profile F360 sketch
        [
            [0,7.554],
            [-7.688,7.554],
            [-10.517,4.725],
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