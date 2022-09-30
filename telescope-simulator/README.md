# telescope-simulator
MATLAB code used to simulate and test the telescope performance and specifications

## Resources
* Optometrika library overview: https://www.mathworks.com/matlabcentral/fileexchange/45355-optometrika
* Optometrika library github: https://github.com/caiuspetronius/Optometrika
* Easy to understand, basic telescope optics: https://starizona.com/blogs/tutorials/imaging-with-a-refractor
* Everything and anything you wish to know about telescope optics: https://www.telescope-optics.net 


## How to set up the Optometrika MATLAB package
How to setup the package to run?
1. download MATLAB package here:
https://www.mathworks.com/matlabcentral/fileexchange/45355-optometrika

You need to make a Mathworks account, I think every queens student gets one by default

2. (optional) move the downloaded git repo copy to your preferred location (I moved mine
to the same directory as my clone of the payload github)
I also renamed mine from "github_repo" to "Optometrika" for clarity

3. Add Optometrika folder to path(in Matlab terminal):
addpath("[PATH TO OPTOMETRIKA DIR IN YOUR FILESYSTEM]")
Example: addpath("C:\Users\Ben\Projects\Optometrika")

Now you can use the classes in the Optometrika package!

To make sure you set it up correctly, try running one of the scripts in the telescope-simulator directory, eg. DoubleConvex_2.m, you should see some cool plots show up if it worked!


### Info on the scripts in this directory
Calculate_fe_M10: M is magnification, fe is focal length of the 2nd lens in a Keplerian setup. 
Goal was to get magnification of 10 with existing lenses

CustomLensDesign / CustomLensDesign2: Trying to create a custom lens for use with a ZWO camera

DoubleConvexLenses / DoubleConvex_2: Lens setup with 2 convex-convex lenses (doublet setup)

#### The following scripts implement Cassegrain lens setups:

telescopeModel: modelling Mak60 telescope

telescopeModelWithBolcks: I think this is the same as telescopeModel except it includes smaller lenses in the center of the corrector and back lenses, not exactly sure why...
