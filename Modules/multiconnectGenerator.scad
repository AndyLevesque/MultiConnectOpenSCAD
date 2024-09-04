/*
Created by Andy Levesque
Credit to @David D on Printables and Jonathan at Keep Making for Multiconnect and Multiboard, respectively
Licensed Creative Commons 4.0 Attribution Non-Commercial - Sharable with Attribution

NOTE: This module may break if the child of another object subject to diff(), intersect(), or union(). 
    Instead, attach to an object 
    For example: 
        cuboid([1]){
            somthing else;
            attach() multiconnectGenerator()
        }
    NOT: 
        cuboid([1])
            attach() multiconnectGenerator()
    https://github.com/BelfrySCAD/BOSL2/issues/270
*/

include <BOSL2/std.scad>

/*[Standard Parameters]*/
//Profile
//Select_Profile = "Standard Multiconnect Rail"; //[Standard Multiconnect Rail, Standard Multiconnect Delete Tool, Jr Multiconnect Rail, Jr Multiconnect Delete Tool, Mini Multiconnect Rail, Mini Multiconnect Delete Tool, Custom Multiconnect Rail, Custom Multiconnect Delete Tool]
Select_Profile = "Standard"; //[Standard, Jr., Mini, Custom]
Select_Part_Type = "Connector Round"; //[Connector Round, Connector Rail, Connector Double sided Round, Connector Double-Sided Rail, Connector Rail Delete Tool, Receiver Open-Ended, Receiver Passthrough]
One_of_Each = false;
One_of_Everything = false;
//Generate one of each type of part
//Length of rail (in mm) (excluding rounded ends)
Length = 50; 
//Add dimples for position locking
Dimples = "Enabled";//[Enabled, Disabled]
//Change the scale (as a multiplier) of dimple size 
Dimple_Scale = 1; //[0.5: 0.25: 1.5]

/*[Rail Customization]*/
//Rounding of rail ends
Rounding = "Both Sides";//[None, One Side, Both Sides]

/*[Receiver Customization]*/
Receiver_Wall_Thickness = 2.5;
Receiver_Back_Thickness = 2;
OnRamps = "Enabled"; //[Enabled, Disabled]

/*[AdvancedParameters]*/
//Distance (in mm) between each grid (25 for Multiboard)
Grid_Size = 25;


/*[Custom MC Builder]*/
//Radius of connector
Radius = 10; //.1
//Depth of inside capture
Depth1 = 1; //.1
//Lateral depth of angle dovetail
Depth2 = 2.5; //.1
//Depth of stem
Depth3 = 0.5; //.1
//Offset/Tolerance of receiver part
Offset = 0.15; //.01
//Radius (in mm) of dimple
DimpleSize = 1.5; //.1

/* [Hidden] */
debug = false; 

//unadjusted cordinates, dimple size, default offset
customSpecs = [Radius, Depth1, Depth2, Depth3, Offset, DimpleSize];
standardSpecs = [10, 1, 2.5, 0.5, 0.15, 1.5];
jrSpecs = [5, 0.6, 1, 0.4, 0.15, 0.8];
miniSpecs = [2.5, 0.6, 1, 0.4, 0.15, 0.8];

profileList = ["Standard", "Jr.", "Mini", "Custom"];
partList = ["Connector Round", "Connector Rail", "Connector Double sided Round", "Connector Double-Sided Rail", "Connector Rail Delete Tool", "Receiver Open-Ended", "Receiver Passthrough"];

dimplesEnabled = 
    Dimples == "Enabled" ? true : 
    false;

onRampEnabled = 
    OnRamps == "Enabled" ? true : 
    false; 

if(One_of_Everything){
    for(n = [0 : 1 : len(profileList)-1]){
        for(i = [0 : 1 : len(partList)-1]){
            echo(str("Generating Profile: ", profileList[n], "; Part: ", partList[i]));
            fwd((n)*25) left((i+1)*27) GeneratePart(profileList[n], partList[i]);
        }
    }
}
else if(One_of_Each){
    for(i = [0 : 1 : len(partList)])
        left((i+1)*27) GeneratePart(Select_Profile, partList[i]);
}
else GeneratePart(Select_Profile, Select_Part_Type);


//Generate parts
module GeneratePart(Select_Profile, Select_Part_Type){
    
    isOffset = Select_Part_Type == "Receiver Open-Ended" ? true : 
        Select_Part_Type == "Receiver Passthrough" ? true :
        Select_Part_Type == "Connector Rail Delete Tool" ? true :
        false;

    profile = 
        Select_Profile == "Standard" ? [dimensionsToCoords(standardSpecs[0], standardSpecs[1], standardSpecs[2], standardSpecs[3], isOffset ? standardSpecs[4] : 0), standardSpecs[5]] :
        Select_Profile == "Jr." ? [dimensionsToCoords(jrSpecs[0], jrSpecs[1], jrSpecs[2], jrSpecs[3], isOffset ? jrSpecs[4] : 0), jrSpecs[5]] :
        Select_Profile == "Mini" ? [dimensionsToCoords(miniSpecs[0], miniSpecs[1], miniSpecs[2], miniSpecs[3], isOffset ? miniSpecs[4] : 0), miniSpecs[5]] :
        Select_Profile == "Custom" ? [dimensionsToCoords(customSpecs[0], customSpecs[1], customSpecs[2], customSpecs[3], isOffset ? customSpecs[4] : 0), customSpecs[5]] :
        [];
    
    if(Select_Part_Type == "Connector Round"){
        //echo(str("Generating: ", Select_Part_Type));
        rail(0,profile[0], dimplesEnabled = dimplesEnabled, dimpleSize = profile[1], dimpleScale = Dimple_Scale, distanceBetweenDimples = Grid_Size, spin=[90,0,0], anchor=FRONT)
            attach([TOP, BOT], BOT, overlap=0.01)
                roundedEnd(profile[0], dimplesEnabled = dimplesEnabled, dimpleSize = profile[1], dimpleScale = Dimple_Scale);       
    }
    else if(Select_Part_Type == "Connector Rail" || Select_Part_Type == "Connector Rail Delete Tool"){
        //echo(str("Generating: ", Select_Part_Type));
        rail(Length, profile[0], onRampEnabled = onRampEnabled, dimpleSize = profile[1], dimplesEnabled = dimplesEnabled, dimpleScale = Dimple_Scale, distanceBetweenDimples = Grid_Size)
            if(Rounding != "None")
                attach(Rounding ==  "Both Sides" ? [TOP, BOT] : TOP, BOT, overlap=0.01)
                    roundedEnd(profile[0], dimplesEnabled = dimplesEnabled, dimpleSize = profile[1], dimpleScale = Dimple_Scale);
    }
    else if(Select_Part_Type == "Connector Double sided Round"){
        //echo(str("Generating: ", Select_Part_Type));
        rail(0,profile[0], dimplesEnabled = dimplesEnabled, dimpleSize = profile[1], dimpleScale = Dimple_Scale, distanceBetweenDimples = Grid_Size, spin=[90,0,0], anchor=FRONT)
                        attach([TOP, BOT], BOT, overlap=0.01)
                            roundedEnd(profile[0], dimplesEnabled = dimplesEnabled, dimpleSize = profile[1], dimpleScale = Dimple_Scale)
                            attach(FRONT, FRONT, overlap=0.01)
                                roundedEnd(profile[0], dimplesEnabled = dimplesEnabled, dimpleSize = profile[1], dimpleScale = Dimple_Scale);
    }
    else if(Select_Part_Type == "Connector Double-Sided Rail"){
        rail(Length,profile[0], dimplesEnabled = dimplesEnabled, dimpleSize = profile[1], dimpleScale = Dimple_Scale, distanceBetweenDimples = Grid_Size, spin=180){
            if(Rounding != "None")
                attach(Rounding ==  "Both Sides" ? [TOP, BOT] : TOP, BOT, overlap=0.01)
                    roundedEnd(profile[0], dimplesEnabled = dimplesEnabled, dimpleSize = profile[1], dimpleScale = Dimple_Scale);
                attach(FRONT, FRONT, overlap=0.01)
                    rail(Length,profile[0], dimplesEnabled = dimplesEnabled, dimpleSize = profile[1], dimpleScale = Dimple_Scale, distanceBetweenDimples = Grid_Size)
                    if(Rounding != "None")
                        attach(Rounding ==  "Both Sides" ? [TOP, BOT] : TOP, BOT, overlap=0.01)
                            roundedEnd(profile[0], dimplesEnabled = dimplesEnabled, dimpleSize = profile[1], dimpleScale = Dimple_Scale);
                }
    }
    else if(Select_Part_Type == "Receiver Open-Ended"){
        diff(){
            cuboid([maxX(profile[0])*2+Receiver_Wall_Thickness*2, maxY(profile[0])+Receiver_Back_Thickness, Length])
                attach(BACK, FRONT, inside=true, shiftout=0.01, align=TOP, inset=maxX(profile[0])+2.5) rail(Length+0.04, profile[0], dimplesEnabled = dimplesEnabled, dimpleSize = profile[1], dimpleScale = Dimple_Scale, distanceBetweenDimples = Grid_Size)
                    if(Rounding != "None")
                        attach(Rounding ==  "Both Sides" ? [TOP, BOT] : TOP, BOT, overlap=0.01)
                            roundedEnd(profile[0], dimplesEnabled = dimplesEnabled, dimpleSize = profile[1], dimpleScale = Dimple_Scale);
            }
    }
    else if(Select_Part_Type == "Receiver Passthrough"){
        diff(){
            cuboid([maxX(profile[0])*2+Receiver_Wall_Thickness*2, maxY(profile[0])+Receiver_Back_Thickness, Length])
                attach(BACK, FRONT, inside=true, shiftout=0.01) rail(Length+0.04, profile[0], dimplesEnabled = dimplesEnabled, dimpleSize = profile[1], dimpleScale = Dimple_Scale, distanceBetweenDimples = Grid_Size)
                    if(Rounding != "None")
                        attach(Rounding ==  "Both Sides" ? [TOP, BOT] : TOP, BOT, overlap=0.01)
                            roundedEnd(profile[0], dimplesEnabled = dimplesEnabled, dimpleSize = profile[1], dimpleScale = Dimple_Scale);
            }
    }
}

//BEGIN MODULES
module roundedEnd(profile, dimplesEnabled = true, dimpleSize = 1.5, dimpleScale = 1, anchor=CENTER, spin=0, orient=UP){
    attachable(anchor, spin, orient, size=[maxX(profile)*2,maxY(profile),maxX(profile)]){
        //align to anchors
        down(maxX(profile)/2) back(maxY(profile)/2)
            top_half()
            rotate(a = [90,0,0]) 
                difference(){
                    //rail
                    rotate_extrude($fn=50) 
                        polygon(points = profile);
                    //dimples
                    if(dimplesEnabled == true) {
                        down(0.01) cylinder(h = dimpleSize*dimpleScale, r1 = dimpleSize*dimpleScale, r2 = 0, $fn = 50);
                    }                        
                }
        children();
    }
}

module rail(length, profile, dimplesEnabled = true, dimpleSize = 1.5, dimpleScale = 1, distanceBetweenDimples = 25, onRampEnabled = false, onRampDistanceBetween = 50, anchor=CENTER, spin=0, orient=UP){
    attachable(anchor, spin, orient, size=[maxX(profile)*2,maxY(profile),length]){
        up(length/2) back(maxY(profile)/2) 
        difference(){
            //rail
            rotate(a = [180,0,0]) 
                linear_extrude(height = length) 
                    union(){
                        polygon(points = profile);
                            mirror([1,0,0])
                                polygon(points = profile);
                    }
            //dimples
            if(dimplesEnabled) 
                zcopies(n = ceil(length/distanceBetweenDimples)+1, spacing = distanceBetweenDimples, sp=[0,0,-length+length%distanceBetweenDimples]) 
                    back(0.01)cylinder(h = dimpleSize*dimpleScale, r1 = dimpleSize*dimpleScale, r2 = 0, $fn = 50, orient=FWD);
        }
        children();
    }
}

//calculate the max x and y points. Useful in calculating size of an object when the path are all positive variables originating from [0,0]
function maxX(path) = max([for (p = path) p[0]]);
function maxY(path) = max([for (p = path) p[1]]);

//this function takes the measurements of a multiconnect-style dovetail and converts them to profile coordinates. 
//When generating the male connector, set offsetMM to zero. Otherwise standard is 0.15 offset for delete tool
function dimensionsToCoords(radius, depth1, depth2, depth3, offsetMM) = [
    [0,0],
    [radius+offsetMM, 0],
    [radius+offsetMM,offsetMM == 0 ? depth1 : depth1+sin(45)*offsetMM*2],
    [radius-depth2+offsetMM, offsetMM == 0 ? depth2+depth1 : depth2+depth1+sin(45)*offsetMM*2],
    [radius-depth2+offsetMM, depth2+depth1+depth3+offsetMM],
    [0,depth2+depth1+depth3+offsetMM]
    ];


/*NOTE: old sections of code needing review to either be removed or with features needing to be worked back in


if(debug) echo(str("Desired Standard Coords:        [[0,0], [10, 0], [10, 1], [7.5, 3.5], [7.5, 4], [0, 4]]"));
if(debug) echo(str("Calculated Standard Coords: "), dimensionsToCoords(10, 1, 2.5, 0.5, 0));
if(debug) echo(str("Desired Standard Offset Coords:        [[0,0], [10.15,0], [10.15,1.2121], [7.65,3.712], [7.65,4.15], [0,4.15]]"));
if(debug) echo(str("Calculated Standard Offset Coords: "), dimensionsToCoords(10, 1, 2.5, 0.5, 0.15));
if(debug) echo(str("Desired Jr Offset Coords:        [[0,0], [5.15, 0], [5.15, 0.8121], [4.15, 1.8121], [4.15, 2.15], [0, 2.15]]"));
if(debug) echo(str("Calculated Jr Offset Coords: "), dimensionsToCoords(5, 0.6, 1, 0.4, 0.15));



//multiconnectStandardProfile= [[0,0], [10, 0], [10, 1], [7.5, 3.5], [7.5, 4], [0, 4]];
//multiconnectStandardDeleteProfile = [[0,0],[10.15,0],[10.15,1.2121],[7.65,3.712],[7.65,4.15],[0,4.15]];
//multiconnectJrProfile = [[0,0], [5, 0], [5, 0.6], [4, 1.6], [4, 2.0], [0, 2.0]];
//multiconnectJrDeleteProfile = [[0,0], [5.15, 0], [5.15, 0.8121], [4.15, 1.8121], [4.15, 2.15], [0, 2.15]];


module multiconnectGenerator(width, height, multiconnectPartType = "Backer", distanceBetweenSlots = 25, onRampEnabled = true, onRampEveryNSlots = 1, onRampOffsetNSlots = 0, slotTolerance = 1, slotVerticalOffset = 2.85, backerThickness = 6.5, slotOrientation = "Vertical", slotDimple = true, dimpleScale = 1, dimpleEveryNSlots = 1, dimpleOffset = 0, dimpleCount = 999, centerMulticonnect=centerMulticonnect, onRampPassthruEnabled = onRampPassthruEnabled, anchor=CENTER, spin=0, orient=UP){

    attachable(anchor, spin, orient, size=[width, backerThickness, height]*slotTolerance){ 
    
        
        
        multiconnectSlot(width, profile = connectorStandardPath, onRampEnabled = false, spin=[90,0,0])
            attach([TOP, BOT], BOT) roundedEndEnd(profile = connectorStandardPath);
        children();  
    }



    module multiconnectSlot(length, profile, multiconnectPartType = "Backer", distanceBetweenSlots = 25, onRampEnabled = true, onRampEveryNSlots = 1, onRampOffsetNSlots = 0, slotDimple = true, dimpleScale = 1, dimpleEveryNSlots = 1, dimpleOffset = 0, dimpleCount = 999, onRampPassthruEnabled = false, anchor=CENTER, spin=0, orient=UP){
        attachable(anchor, spin, orient, size=[maxX(profile)*2,maxY(profile),length]){
            diff("slotDimple"){
                multiconnectLinear(length = length, profile = profile, multiconnectPartType = multiconnectPartType, distanceBetweenSlots = distanceBetweenSlots, onRampEnabled = onRampEnabled, onRampEveryNSlots = onRampEveryNSlots, onRampOffsetNSlots = onRampOffsetNSlots, onRampPassthruEnabled = onRampPassthruEnabled);
                if(slotDimple && dimpleEveryNSlots != 0 && multiconnectPartType == "Backer") {
                    //calculate the dimples. Dimplecount can override if less than calculated slots
                    if(debug) echo("Dimples for Backer");
                    tag("slotDimple") attach(BACK, BOT, align=TOP, inside=true, shiftout=0.01) back(1.5*dimpleScale) 
                            cylinder(h = 1.5*dimpleScale, r1 = 1.5*dimpleScale, r2 = 0, $fn = 50);
                    zcopies(n = min(length/distanceBetweenSlots/dimpleEveryNSlots+1, dimpleCount), spacing = -distanceBetweenSlots*dimpleEveryNSlots, sp=[0,0,dimpleOffset*distanceBetweenSlots]) 
                        tag("slotDimple") attach(BACK, BOT, align=TOP, inside=true, shiftout=0.01) back(1.5*dimpleScale) 
                            cylinder(h = 1.5*dimpleScale, r1 = 1.5*dimpleScale, r2 = 0, $fn = 50);
                }
                if(slotDimple && dimpleEveryNSlots != 0 && multiconnectPartType == "Passthru"){ //passthru
                    //calculate the dimples. Dimplecount can override if less than calculated slots
                    if(debug) echo(str("Dimples for Passthru: ", min(length/distanceBetweenSlots/dimpleEveryNSlots+2, dimpleCount), ". Distance between: ", -distanceBetweenSlots*dimpleEveryNSlots));
                    zcopies(n = min(length/distanceBetweenSlots/dimpleEveryNSlots+2, dimpleCount), spacing = -distanceBetweenSlots*dimpleEveryNSlots, sp=[0,0,centerMulticonnect ? -length/2+25*3/2-12.5+25+dimpleOffset*distanceBetweenSlots: -length/2+25*3/2+25+dimpleOffset*distanceBetweenSlots]) 
                        tag("slotDimple") attach(BACK, BOT, align=TOP, inside=true, shiftout=0.01) back(1.5*dimpleScale) 
                            cylinder(h = 1.5*dimpleScale, r1 = 1.5*dimpleScale, r2 = 0, $fn = 50);

                }
            
            }
            children();
        }
        //long slot
    }
}
*/
