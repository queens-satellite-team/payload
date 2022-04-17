import matplotlib.pyplot as plt
import math as m
from itertools import product
import argparse
import pandas as pd
import numpy as np

A = 400000 #from CSDC rules, assume 400km altitude
degToRad = m.pi / 180

def getExitPupilPos(feye, fobj):
    """Get position of exit pupil from 2nd lens"""
    return feye*(feye + fobj) / fobj

def getFOVtrue(feye, fobj, Sx, Sy):
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
    Get ground area in x and y from true FOV and altitude (in m)
    """

    #inputs to tan already in radians
    gndAx = 2 * A * m.tan(FOVtrue_x)
    gndAy = 2 * A * m.tan(FOVtrue_y)

    return gndAx, gndAy
 
def getRes(FOVtrue_x, FOVtrue_y, px, py):
    """
    Get ground resolution in x and y from true FOV and altitude
    """

    #inputs to tan already in radians
    gndAx = 2 * A * m.tan(FOVtrue_x)
    gndAy = 2 * A * m.tan(FOVtrue_y)

    Rx = gndAx / px
    Ry = gndAy / py
    return Rx, Ry

def checkValid(fobj, feye, pupilPos, GndAx, GndAy, Resx, Resy, v, max_length=15, good_res=45):
    """
    Return True if the focal lengths, ground area, resolution satisfy the conditions:
    -ground area between 40x40 and 100x100km
    -resolution < 45m
    -telescope length < 1.5U (15cm)
    -telescope width < 8cm
    """

    #all in m
    AreaCond = (GndAx * GndAy > 40000*40000) and (GndAx * GndAy < 100000*100000)
    ResCond = Resx < good_res and Resy < good_res
    lenCond = fobj + feye + pupilPos < (max_length / 100)

    #assume 1:1 mapping from focal length to lens diameter
    widthCond = fobj < 0.08 and feye < 0.08 #max 8cm


    #print reasons why lens combinatinos don't work for each focal length pair
    if v > 2:
        if not ResCond:
            print(f"Bad ground resolution for lenses {fobj}, {feye}: {Resx} / {Resy}")
        if not AreaCond:
            print(f"Bad ground area for lenses {fobj}, {feye}: {GndAx} / {GndAy}")

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
    feyes = np.round(np.arange(0.01, 0.05, 0.002), decimals=3) #m
    fobjs = np.round(np.arange(0.01, 0.1, 0.002), decimals=3) #m

    #to save ground area values
    GndAxs = np.empty((len(feyes), len(fobjs)))
    GndAys = np.empty((len(feyes), len(fobjs)))

    #to save ground resolution values
    GndResx = np.empty((len(feyes), len(fobjs)))
    GndResy = np.empty((len(feyes), len(fobjs)))

    #to save bool of validity
    valid = np.empty((len(feyes), len(fobjs)))

    #to save valid diameters
    #diam_pairs = np.empty((len(feyes), len(fobjs)))

    #iter possible objective and eyepiece focal lengths + sensor res and pixel size
    for i, feye in enumerate(feyes):
        for j, fobj in enumerate(fobjs):
            #iter diameters (>1cm, <=FL)\
            print(fobj, feye)
            Dobjs = np.round(np.arange(0.001, fobj, 0.002), decimals=3) #m
            Deyes = np.round(np.arange(0.001, feye, 0.002), decimals=3) #m 
            for (Dobj, Deye) in product(Dobjs, Deyes):
                #exit pupil position
                pupilPos = getExitPupilPos(feye, fobj)

                #ground areas
                FOV_truex, FOV_truey = getFOVtrue(feye, fobj, sx, sy)

                GndAxs[i, j], GndAys[i, j] = getGndA(FOV_truex, FOV_truey, sx, sy, fobj, feye, A)

                #ground resolutions
                GndResx[i, j], GndResy[i, j] = getRes(FOV_truex, FOV_truey, pix_res_x, pix_res_y)

                #check if this combination is valid
                valid[i, j] = checkValid(fobj, feye, pupilPos, GndAxs[i, j], GndAys[i, j], GndResx[i, j], GndResy[i, j], 
                    verbose, max_length=10, good_res=50) 
                if verbose > 2:
                    if not valid[i, j]:
                        print(f"FOV for this combination: {FOV_truex} / {FOV_truey} degrees")

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


    #map these indices to (feye, fobj) pairs
    def get_flengths(ind):
        return feyes[ind[0]], fobjs[ind[1]]
    valid_f_lengths = list(map(get_flengths, inds))

    if verbose > 0:
        for fl in valid_f_lengths:
            pupilPos = getExitPupilPos(fl[0], fl[1])
            FOV_truex, FOV_truey = getFOVtrue(fl[0], fl[1], sx, sy)
            gndAx, gndAy = getGndA(FOV_truex, FOV_truey, sx, sy, fl[1], fl[0], A)
            rx, ry = getRes(FOV_truex, FOV_truey, pix_res_x, pix_res_y)
            print(f"The combination fobj: {fl[1] * 1000} mm, feye: {fl[0] * 1000} mm is valid")
            if verbose > 1:
                print(f"GNDA x = {gndAx}, y = {gndAy}, RES x = {rx}, y = {ry}, PUPILPOS: {pupilPos*1000} mm")

    def enumerated_product(*args):
        yield from zip(product(*(range(len(x)) for x in args)), product(*args))

    fobj, feye = 0.05, 0.02
    Dobjs = np.round(np.arange(0.001, fobj+0.001, 0.002), decimals=3) #m
    Deyes = np.round(np.arange(0.001, feye+0.001, 0.001), decimals=3) #m 
    GndAxs = np.empty((len(Dobjs), len(Deyes)))
    GndAys = np.empty((len(Dobjs), len(Deyes)))

    GndResx = np.empty((len(Dobjs), len(Deyes)))
    GndResy = np.empty((len(Dobjs), len(Deyes)))

    #check which diameters work for sensor
    for (i, j), (Dobj, Deye) in enumerated_product(Dobjs, Deyes):
        print((i, j), (Dobj, Deye))
        #exit pupil position
        pupilPos = getExitPupilPos(feye, fobj)

        #ground areas
        FOV_truex, FOV_truey = getFOVtrue(feye, fobj, sx, sy)

        GndAxs[i, j], GndAys[i, j] = getGndA(FOV_truex, FOV_truey, sx, sy, fobj, feye, A)

        #ground resolutions
        GndResx[i, j], GndResy[i, j] = getRes(FOV_truex, FOV_truey, pix_res_x, pix_res_y)

        #check if this combination is valid
        valid = checkValid(fobj, feye, pupilPos, GndAxs[i, j], GndAys[i, j], GndResx[i, j], GndResy[i, j], 
            verbose, max_length=10, good_res=50) 

        if valid:
            print(f"Diameters obj: {Dobj}, eye: {Deye} are valid for 50mm, 20mm focal lengths, pupil pos: {pupilPos}")
            print(f"FOV: {GndAxs[i, j]} / {GndAys[i, j]}, ground res: {GndResx[i, j]} / {GndResy[i, j]}")


if __name__ == "__main__":
    
    parser = argparse.ArgumentParser()
    parser.add_argument("-s", "--sensor_size", nargs='+', default=(0.00363, 0.00272), type=float, 
        help="Size of the sensor in m (x, y)")
    parser.add_argument("-ps", "--pixel_size", nargs='+', default=None, type=float, 
        help="Size of a single pixel in micro meters (x, y)")
    parser.add_argument("-c", "--pix_count", nargs='+', default=(2592, 1944), type=float, 
        help="Pixel count of the sensor (x, y)")
    parser.add_argument('-p', '--plot', default=False, 
        help='Flag to generate plots of ground area and ground resolution vs focal lengths')
    parser.add_argument('-v', '--verbose', action='count', default=0, 
        help='Verbosity to print the valid lens combinations')
    args = parser.parse_args()

    if args.pixel_size is not None:
        args.pixel_size = np.array(args.pixel_size)
        args.pixel_size *= 10e-7
        args.sensor_size = args.pixel_size * np.array(args.pix_count)
    main(*args.sensor_size, *args.pix_count, args.verbose)
