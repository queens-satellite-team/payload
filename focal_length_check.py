import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
import numpy as np
import math as m
import itertools
import argparse
import pandas as pd

A = 400000 #from CSDC rules, assume 400km altitude
degToRad = m.pi / 180


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
def getGndA(FOVtrue_x, FOVtrue_y, sx, sy, fobj, feye, A):
    """
    Get ground area in x and y from true FOV and altitude
    """

    #inputs to tan already in radians
    gndAx = 2 * A * m.tan(FOVtrue_x)
    gndAy = 2 * A * m.tan(FOVtrue_y)

    #using condition for sensor to contain enough ground area info
    M = fobj / feye
    gndAx_sensor = sx * M * gndAx
    gndAy_sensor = sx * M * gndAy

    return gndAx_sensor, gndAy_sensor

def getRes(FOVtrue_x, FOVtrue_y, Sx, Sy):
    """
    Get ground resolution in x and y from true FOV and altitude
    """

    #inputs to tan already in radians
    gndAx = 2 * A * m.tan(FOVtrue_x)
    gndAy = 2 * A * m.tan(FOVtrue_y)

    Rx = gndAx / Sx
    Ry = gndAy / Sy
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

def getTelescopeLength(fobj, feye):
    """ 
    Return the telescope length in m assuming Keplerian setup
    Takes fobj (m), feye (m)
    """ 

    return fobj + 2 * feye

def findCombInList(allCombs, setCombs):
    """
    Given a list of all valid lens combinations and a second list, find which
    tuples in the 2nd list are also in the 1st. 
    """

    return [tup for tup in setCombs if tup in allCombs]

def main(sx, sy, pix_res_x, pix_res_y, verbose, plot=False):

    #focal lengths in m (rounded to nearest mm)
    feyes = np.round(np.arange(0.005, 0.05, 0.001), decimals=3) #m
    fobjs = np.round(np.arange(0.01, 0.1, 0.001), decimals=3) #m

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

            GndAxs[i, j], GndAys[i, j] = getGndA(FOV_truex, FOV_truey, sx, sy, fobj, feye, A)

            #ground resolutions
            GndResx[i, j], GndResy[i, j] = getRes(FOV_truex, FOV_truey, pix_res_x, pix_res_y)

            #check if this combination is valid
            valid[i, j] = checkValid(fobj, feye, GndAxs[i, j], GndAys[i, j], GndResx[i, j], GndResy[i, j]) 

    #grids of focal lengths
    Fobjs, Feyes = np.meshgrid(fobjs, feyes)

    ###Plotting
    if plot:
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
    print(f"N valid combinations for this camera: {len(inds)}")

    if verbose > 0:
        for i in inds:
            print(valid[i])

    #map these indices to (feye, fobj) pairs
    #valid_f_lengths = np.empty(inds.shape)
    def get_flengths(ind):
        return feyes[ind[0]], fobjs[ind[1]]
    valid_f_lengths = list(map(get_flengths, inds))

    """
    #check if any of the lenses we have will work
    lenses = np.array([15, 22.5, 100, 13.5, 15]) #mm
    lenses /= 1000 #mm to m

    #all permutations of these lenses
    lens_perms = list(itertools.permutations(lenses, 2))

    #check which permutations are in the list of valid permutations
    vs = [tup for tup in lens_perms if tup in valid_f_lengths]
    print(f"N of lens combinations we own which are valid: {len(vs)}")

    print("All combinations in mm")
    for c in valid_f_lengths:
        print(f"{c[0] * 1000} mm, {c[1] * 1000} mm")
    """

    """
    #export to a spreadsheet
    df = pd.DataFrame(valid_f_lengths)
    filepath = 'lens_combs.xlsx'
    df.to_excel(filepath, index=False)
    """

    """
    ###Try to match valid combinations with standard lens sizes
    #From https://www.edmundoptics.ca/search/?criteria=convex&Tab=Products#28233=28233_s%3AUGxhbm8tQ29udmV4IExlbnM1&ProductFamilies_ii=ProductFamilies_ii%3AMTIwMDI1
    edmund_flengths = np.array([36.0, 27.0, 30.0, 22.5, 18.0, 13.5, 24.0, 75.0, 100.0, 
        9.0, 12.0, 18.0, 50.0, 72.0, 10.0, 25.0, 15.0, 6.0, 150.0, 48.0, 60.0, 
        84.0, 125.0, 175.0, 36.0, 80.0, 200.0, 400.0, 1.0, 1.5])
    edmund_flengths /= 1000 #mm to m
    #sort, uniques
    edmund_flengths = list(set(edmund_flengths))
    edmund_flengths.sort()

    edmundPerms = list(itertools.permutations(edmund_flengths, 2))
    edmundValid = findCombInList(valid_f_lengths, edmundPerms)


    print("Valid edmund combinations")
    for c in edmundValid:
        print(f"feye: {c[0] * 1000} mm, fobj: {c[1] * 1000} mm, telescope length: {getTelescopeLength(c[1], c[0]) * 100} cm")
    """


if __name__ == "__main__":
    
    parser = argparse.ArgumentParser()
    parser.add_argument("-s", "--size", default=(0.00363, 0.00272), 
        help="Size of the sensor in m (x, y)")
    parser.add_argument("-c", "--pix_count", default=(2592, 1944), 
        help="Pixel count of the sensor (x, y)")
    parser.add_argument('-p', '--plot', default=False, 
        help='Flag to generate plots of ground area and ground resolution vs focal lengths')
    parser.add_argument('-v', '--verbose', action='count', default=0, 
        help='Verbosity to print the valid lens combinations')
    args = parser.parse_args()


    main(*args.size, *args.pix_count, args.verbose)
