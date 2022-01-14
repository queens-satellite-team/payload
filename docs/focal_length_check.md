## Overview
This script is meant to determine which lens combinations work for a particular camera, given our imaging requirements (these being a ground area between 40km x 40km and 100km x 100km, and a ground resolution < 40m).

The optics equations used to calculate the ground area and resolution are described here:

### Inputs
Size / s (x, y): The size of the camera's image sensor in metres (eg. 0.00363, 0.00272)
pix_count / p (x, y): The pixel count on the sensor (eg. 2592, 1944)

### Outputs
The number of valid lens combinations for the camera is printed. 
If the script is ran with verbosity (eg. Running 'python focal_length_check.py -v'), each valid focal length combination is also printed. 