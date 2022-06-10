from picamera import PiCamera
import time

def capture_img(imgpath):
    """
    Capture an image with attached Pi camera. 
    params: 
        imgpath: Path to location to store the image. End path name with ".png" or ".jpeg".
        Example: "./test_img.png"
    Returns: None
    """ 
    
    camera = PiCamera()
    camera.resolution = (2592,1944) # 4:3 aspect ratio
    camera.capture(imgpath)
    
    
#for testing
if __name__ == "__main__":
    print("Capturing image")
    t0 = time.time()
    capture_img('./test_img.png')
    print(f"Captured image in {time.time() - t0} s")
    
