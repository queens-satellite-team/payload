## Overview
This script is meant to determine which lens combinations work for a particular camera, given our imaging requirements (these being a ground area between 40km x 40km and 100km x 100km, and a ground resolution < 40m).

This is necessary since the lenses which will fit our imaging requirements depend on what CMOS sensor we use (specifically its size and pixel count).

The optics equations used to calculate the ground area and resolution are described here:

### Inputs
Size / s (x, y): The size of the camera's image sensor in metres (eg. 0.00363, 0.00272)
pix_count / p (x, y): The pixel count on the sensor (eg. 2592, 1944)

### Outputs
The number of valid lens combinations for the camera is printed. 
If the script is ran with verbosity (eg. Running 'python focal_length_check.py -v'), each valid focal length combination is also printed. 
If the script is ran with verbosity (eg. Running 'python focal_length_check.py -vv'), each invalid focal length is printed as well.

fobj: The focal length of the "objective lens", aka the 1st lens in a Keplerian setup
feye: The focal length of the "eyepiece lens", aka the 2nd lens in a Keplerian setup
See here for a better definition of these terms: http://electron9.phys.utk.edu/optics421/modules/m3/telescopes.htm

### Background
The optics equations used for the telescope are described on P28-29 of the QSAT primer: https://queensuca.sharepoint.com/teams/GROUP-QSET/Shared%20Documents/Forms/AllItems.aspx?FolderCTID=0x01200043C344A6B81F9F468658445F2EBDA20F&id=%2Fteams%2FGROUP%2DQSET%2FShared%20Documents%2FSatellite%2DGeneral%2FQSAT%5Fprimer%5Fv1%5F0%2Epdf&parent=%2Fteams%2FGROUP%2DQSET%2FShared%20Documents%2FSatellite%2DGeneral

The complete list of imaging requirements for a pair of lenses to be valid is:
-the imaged ground area is between 40km x 40km and 100km x 100km
-the ground resolution is < 45m in both x and y
-the length of the telescope is < 15cm (remember that the cubesat length is 30cm)
-the width of all lenses is < 8cm (the width of the cubesat is 10cm)