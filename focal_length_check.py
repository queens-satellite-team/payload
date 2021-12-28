import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import numpy as np
import math as m
import itertools

def getFOVtrue(feye, fobj, Sx, Sy, A):
    """
    Get true FOV in x and y from focal lengths, sensor size in x / y and altitude
    """
    M = fobj / feye

    #get apparent FOVs
    FOVapp_x = 2 * m.atan(Sx / (2*feye)) #radians
    FOVapp_y = 2 * m.atan(Sy / (2*feye)) #radians

    #get true FOVs
    FOVtrue_x = FOVapp_x / M
    FOVtrue_y = FOVapp_y / M
    return FOVtrue_x, FOVtrue_y

#ground area as function of fobj and feye (x and y)
def getGndA(FOVtrue_x, FOVtrue_y, A):
    """
    Get ground area in x and y from true FOV and altitude
    """

    #inputs to tan already in radians
    gndAx = 2 * A * m.tan(FOVtrue_x)
    gndAy = 2 * A * m.tan(FOVtrue_y)

    return gndAx, gndAy

def getRes(Gnd_Ax, Gnd_Ay, Sx, Sy):
    """
    Get ground resolution in x and y from true FOV and altitude
    """

    Rx = Gnd_Ax / Sx
    Ry = Gnd_Ay / Sy
    return Rx, Ry

def checkValid(fobj, feye, GndAx, GndAy, Resx, Resy):
    """
    Return True if the focal lengths, ground area, resolution satisfy the conditions:
    -ground area between 40x40 and 100x100km
    -resolution < 45m
    -telescope length < 1.5U (15cm)
    -telescope width < 8cm
    """

    #all in m
    AreaCond = (GndAx * GndAy > 40000*40000) and (GndAx * GndAy < 100000*100000)
    ResCond = Resx < 45 and Resy < 45
    lenCond = fobj + 2*feye < (15 / 100)
    widthCond = True #TODO add lens diameters

    return AreaCond and ResCond and lenCond and widthCond



#altitude
A = 400000 #from CSDC rules, assume 400km altitude

degToRad = m.pi / 180

#focal lengths in m (rounded to nearest mm)
feyes = np.round(np.arange(0.005, 0.05, 0.001), decimals=3) #m
fobjs = np.round(np.arange(0.005, 0.1, 0.001), decimals=3) #m

#single pixel sizes of the sensor (picam for now)
sx, sy = 0.00367, 0.00274 #m
pix_res_x, pix_res_y = 2592, 1944

#to save ground area values
GndAxs = np.empty((len(feyes), len(fobjs)))
GndAys = np.empty((len(feyes), len(fobjs)))

#to save ground resolution values
GndResx = np.empty((len(feyes), len(fobjs)))
GndResy = np.empty((len(feyes), len(fobjs)))

#to save bool of validity
valid = np.empty((len(feyes), len(fobjs)))

#iter possible objective and eyepiece focal lengths + sensor res and pixel size
for i, feye in enumerate(feyes):
    for j, fobj in enumerate(fobjs):
        #ground areas
        FOV_truex, FOV_truey = getFOVtrue(feye, fobj, sx, sy, A)

        GndAxs[i, j], GndAys[i, j] = getGndA(FOV_truex, FOV_truey, A)

        #ground resolutions
        GndResx[i, j], GndResy[i, j] = getRes(GndAxs[i, j], GndAys[i, j], pix_res_x, pix_res_y)

        #check if this combination is valid
        valid[i, j] = checkValid(fobj, feye, GndAxs[i, j], GndAys[i, j], GndResx[i, j], GndResy[i, j]) 

#grids of focal lengths
Fobjs, Feyes = np.meshgrid(fobjs, feyes)

###Plotting
#plot ground areas, resolutions for both altitude bounds
fig = plt.figure(figsize=plt.figaspect(0.5))
ax = fig.add_subplot(1, 2, 1, projection='3d')

#ground areas
ax.scatter3D(Feyes, Fobjs, GndAxs, 'gray', s=10)
ax.set_xlabel("eyepiece f (m)")
ax.set_ylabel("objective f (m)")
ax.set_zlabel("Gnd Ax (m)")

#for resolutions
ax = fig.add_subplot(1, 2, 2, projection='3d')
ax.scatter3D(Feyes, Fobjs, GndResx, s=10)
ax.set_xlabel("eyepiece f (m)")
ax.set_ylabel("objective f (m)")
ax.set_zlabel("Res x (m)")

plt.show()


#get just valid combinations
inds = np.argwhere(valid)
print(f"N valid combinations: {len(inds)}")

#map these indices to (feye, fobj) pairs
#valid_f_lengths = np.empty(inds.shape)
def get_flengths(ind):
    return feyes[ind[0]], fobjs[ind[1]]
valid_f_lengths = list(map(get_flengths, inds))

#check if any of the lenses we have will work
lenses = np.array([15, 22.5, 100, 13.5, 15]) #mm
lenses /= 1000 #mm to m

#all permutations of these lenses
lens_perms = list(itertools.permutations(lenses, 2))

#check which permutations are in the list of valid permutations
vs = [tup for tup in lens_perms if tup in valid_f_lengths]
print(f"N of lens combinations we have which are valid: {len(vs)}")




