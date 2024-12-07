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

/*[Channel Size]*/
//width of channel in units (default unit is 25mm)
Channel_Width_in_Units = 1;
//height inside the channel (in mm)
Channel_Internal_Height = 12; //[12:6:72]
//Length (in mm) the longest edge of one top channel. This should be the distance of where the channel starts to the wall or corner.
Length_of_Longest_Edge_1 = 75;
Length_of_Longest_Edge_2 = 75;

/*[Advanced Options]*/
//Units of measurement (in mm) for hole and length spacing. Multiboard is 25mm. Untested
Grid_Size = 25;
//Color of part (color names found at https://en.wikipedia.org/wiki/Web_colors)
Global_Color = "SlateBlue";

/*[Hidden]*/
channelWidth = Channel_Width_in_Units * Grid_Size;

//length of channel in units (default unit is 25mm)
Channel_Length_Units = 6;

/*

***BEGIN DISPLAYS***

*/

color_this(Global_Color)
    left(3)
    half_of(UP+LEFT, s=Channel_Length_Units*Grid_Size*2+10)
        path_sweep(topProfile(widthMM = channelWidth, heightMM = Channel_Internal_Height), turtle(["xmove", Length_of_Longest_Edge_1*2-50+14.032*2- (Channel_Internal_Height-12)*2]), anchor=TOP, orient=BOT);

    color_this(Global_Color)
        down(3)yrot(-90) xrot(180)
            half_of(UP+LEFT, s=Channel_Length_Units*Grid_Size*2+10)
            path_sweep(topProfile(widthMM = channelWidth, heightMM = Channel_Internal_Height), turtle(["xmove", Length_of_Longest_Edge_2+14.032*2+14 - (Channel_Internal_Height-12)*2]), anchor=TOP, orient=BOT);
