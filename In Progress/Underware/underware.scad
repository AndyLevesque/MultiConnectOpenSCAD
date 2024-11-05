/*Created by Hands on Katie and BlackjackDuck (Andy)
Credit to 
    Katie (and her community) at Hands on Katie on Youtube and Patreon
    @David D on Printables for Multiconnect
    Jonathan at Keep Making for MulticonnMultiboard
    
Licensed Creative Commons 4.0 Attribution Non-Commercial Sharable with Attribution
*/

include <BOSL2/std.scad>
include <BOSL2/rounding.scad>

/*[Straight Channels]*/
//length of channel in units (default unit is 25mm)
Channel_Length_Units = 5; 
//width of channel in units (default unit is 25mm)
Channel_Width_in_Units = 1;

/*[Curved Channels]*/
Curve_Radius_in_Units = 2;

/*[Advanced Options]*/
//Units of measurement (in mm) for hole and length spacing. Multiboard is 25mm.
Grid_Size = 25;
Curve_Resolution = 25;

channelWidth = Channel_Width_in_Units * Grid_Size;

straightChannelBase(lengthMM = Channel_Length_Units * Grid_Size, widthMM = channelWidth);

straightChannelTop(lengthMM = Channel_Length_Units * Grid_Size, widthMM = channelWidth);

right(Curve_Radius_in_Units * Grid_Size + channelWidth + 5) 
    curvedChannelBase(radiusMM = Curve_Radius_in_Units*Grid_Size, widthMM = channelWidth);

right(Curve_Radius_in_Units * Grid_Size + channelWidth + 5) 
    curvedChannelTop(radiusMM = Curve_Radius_in_Units*Grid_Size, widthMM = channelWidth);

//cross intersection
left(channelWidth*2 + 5) crossIntersectionBase(widthMM = channelWidth);;

//BEGIN MODULES

module crossIntersectionBase(widthMM){
    union(){
        rot_copies(n=4, delta=[-widthMM/2+3,0,0]) zrot(90) straightChannelBase(lengthMM = Grid_Size+3, widthMM = Channel_Width_in_Units * Grid_Size);
        cuboid([widthMM - 6 + 0.02, widthMM - 6 + 0.02,3.5], anchor=BOT); //fill the middle
    }
}

module straightChannelBase(lengthMM, widthMM){
    zrot(90) path_sweep(baseProfile(widthMM), turtle(["xmove", lengthMM])); 
}
module straightChannelTop(lengthMM, widthMM){
    zrot(90) path_sweep(topProfile(widthMM), turtle(["xmove", lengthMM])); 
}

module curvedChannelBase(radiusMM, widthMM){
    zrot(90) path_sweep(baseProfile(widthMM), arc(r=radiusMM, angle = 90, n=Curve_Resolution)); 
}

module curvedChannelTop(radiusMM, widthMM){
    zrot(90) path_sweep(topProfile(widthMM), arc(r=radiusMM, angle = 90, n=Curve_Resolution)); 
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
        back(9.554+7.947-1,rect([widthMM-25+0.02,2]))
    );

baseProfileHalf = 
    fwd(-7.947, //take Katie's exact measurements for half the profile and use fwd to place flush on the Y axis
        //profile extracted from exact coordinates in Master Profile F360 sketch
        [
            [0,-4.447], //inner x axis point with width adjustment
            [0,-7.947],
            [-10.517,-7.947],
            [-10.517,-6.448],
            [-12.517,-4.448],
            [-12.517,-1.914],
            [-11.666,-1.914],
            [-11.166,-1.414],
            [-11.166,-0.592],
            [-11.459,-0.297],
            [-11.459,1.422],
            [-10.517,1.683],
            [-9.5,1.683],
            [-9.5,-3.447],
            [-8.5,-4.447]
        ]
);

topProfileHalf = 
    fwd(-7.947, //take Katie's exact measurements for half the profile and use fwd to place flush on the Y axis
        //profile extracted from exact coordinates in Master Profile F360 sketch
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