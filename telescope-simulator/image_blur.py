import math
from math import sqrt
import numpy as np
import cv2
import matplotlib as mp

# Physical constants
GM = 3.986004418e14 # Standard Gravitational parameter of Earth (m^3/s^2)
earth_r = 6378.1e3 # m

# Satellite parameters
orbit_r = 400.0e3 # m
angular_x = 0.01; #arcsecond/sec
orbit_speed = sqrt(GM/(orbit_r+earth_r)) #m/s

# Camera specifications
sensor_size = np.array((11.3e-3, 7.1e-3)) # m
focal_length = 50.0e-3 # m
shutter_speed = 1e-3 # s
colour_mode = False
resolution = np.array((1936, 1216))

# Downlink
downlink_budget = 108e3*8 # bits per pass

# Test image
img_path = "test_images/kingston.png"

# M = f0/fe
# FoV = FoVe (eyepiece) / M (in angle of sky, multiply by orbit height)
# FoV = sensor_size * orbit_r / focal_length #km
pixel_size = FoV / resolution # 2D array, X,Y

def checkRules():
    max_img_size = np.prod(resolution) * 8
    max_img_size = max_img_size * 3 if colour_mode else max_img_size
    if max_img_size > downlink_budget:
        print("Uncompressed image {:.2f}% too big.".format(max_img_size/downlink_budget*100))

def motionBlur():
    lin_motion = orbit_speed * shutter_speed
    rot_motion = 2 * orbit_r * math.tan(angular_x * math.pi/(180 * 3600))
    print(rot_motion)
    motion = lin_motion + rot_motion
    blur_size = int(motion / pixel_size[0])
    if blur_size < 1:
        # can't average over less than 1 pixel
        return
    # generating the kernel
    kernel_motion_blur = np.zeros((blur_size, blur_size))
    kernel_motion_blur[int((blur_size-1)/2), :] = np.ones(blur_size)
    kernel_motion_blur = kernel_motion_blur / blur_size

    if img_path != None:
        img = cv2.imread(img_path)
        cv2.imshow('Original', img)
        # applying the kernel to the input image
        output = cv2.filter2D(img, -1, kernel_motion_blur)

        cv2.imshow('Motion Blur', output)
        cv2.waitKey(0)

if __name__ == '__main__':
    motionBlur()
    checkRules()
