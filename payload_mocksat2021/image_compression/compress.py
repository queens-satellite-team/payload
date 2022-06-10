from PIL import Image
import time

def compress_img(img: Path, outpath: Path):
    """ 
    params: 
        img: Path to the input image to compress (eg.'./image_capture/test_img.png')
        outpath: Path to the directory to save the compressed image (eg.'./image_capture/test_img.png')
        
    """
    
    outfile = outpath + '/compressed.png'
    imgObj = Image.open(img)
    
    time0 = time.time()
    imgObj = imgObj.resize((1944, 1458), Image.ANTIALIAS)
    imgObj.save(outfile, quality=75)
    compress_time = time.time() - time0
    print(f"Compressed the image in {compress_time}")

#for testing
if __name__ == "__main__":
    compress_img('../image_capture/test_img.png', '.')


