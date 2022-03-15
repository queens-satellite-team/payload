"""
Generate a valid test image. 
-pixel dimensions
-channels (RGB / greyscale)
-bit depth

Save tiff file
"""

import argparse
import numpy as np
from PIL import Image, ImageOps
from pathlib import Path
import imageio

def check(file_, pixcount, bit_depth, channels):
    im = Image.open(file_)
    size = list(im.size)
    size.reverse()
    print(size)
    print(np.asarray(im).dtype)
    

def main(outpath, pixcount, bit_depth, channels):

    #load source image
    img = Image.open('test-images/sample_5184×3456.jpeg')

    print(f"Using pixel count {pixcount}")
    fpath = Path(outpath, f'{pixcount}_{bit_depth}_{channels}.jpg')
    if channels == 'RGB':
        img = img.resize(pixcount, Image.ANTIALIAS)
    else:
        img = img.resize(pixcount, Image.ANTIALIAS)
        img = ImageOps.grayscale(img)
    
    imageio.imwrite(fpath, img, format='JPEG')
    return fpath


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("-o", "--outpath", default=Path(".").resolve(), 
        help="Name of file to load for modelling")
    parser.add_argument("-p", "--pix_count", nargs='+', default=(2592, 1944), type=int, 
        help="Pixel count of the sensor (x, y)")
    parser.add_argument("-d", "--bit_depth", default=16, type=float, 
        help="Bit depth of image")
    parser.add_argument("-c", "--channels", default='RGB', type=str, 
        help="Image channels. Options: 'RGB', 'greyscale'")
    args = parser.parse_args()

    fpath = main(args.outpath, args.pix_count, args.bit_depth, args.channels)

    #load, check it worked
    check(fpath, args.pix_count, args.bit_depth, args.channels)