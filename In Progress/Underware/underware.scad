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

straightChannelBase(lengthMM = Channel_Length_Units * Grid_Size, widthMM = Channel_Width_in_Units * Grid_Size);

right(Curve_Radius_in_Units * Grid_Size + Grid_Size + 10) 
    curvedChannelBase(radiusMM = Curve_Radius_in_Units*Grid_Size, widthMM = Channel_Width_in_Units * Grid_Size);


module straightChannelBase(lengthMM, widthMM){
    zrot(90) path_sweep(baseProfile(widthMM), turtle(["xmove", lengthMM])); 
}

module curvedChannelBase(radiusMM, widthMM){
    zrot(90) path_sweep(baseProfile(widthMM), arc(r=radiusMM, angle = 90, n=Curve_Resolution)); 
}


//BEGIN PROFILES

//take the two halves of base and merge them
function baseProfile(widthMM) = 
    union(
        left((widthMM-25)/2,halfBaseProfileWidthAdjusted(widthMM)), 
        left(-(widthMM-25)/2,mirror([1,0],halfBaseProfileWidthAdjusted(widthMM)))
    );

function halfBaseProfileWidthAdjusted(widthMM) = 
    fwd(-7.947, //take Katie's exact measurements for half the profile and use fwd to place flush on the Y axis
        //profile extracted from exact coordinates in Master Profile F360 sketch
        [
            [0+(widthMM-25)/2,-4.447], //inner x axis point with width adjustment
            [0+(widthMM-25)/2,-7.947],
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
