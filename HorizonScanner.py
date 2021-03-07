import cv2 as cv #used to process images
import numpy as np
import math as m
import time

########### Main Program #############


#Load Vedio
vidcap=cv.VideoCapture('at_float.m4v')
count=0
success,image=vidcap.read()
iHigh,iWide,iChannel=image.shape

# Define Parameters
wide=int(iWide/4)
intensityB=np.zeros((iHigh,wide))
intensityR=np.zeros((iHigh,wide))
Mbr=np.zeros(wide)
wid=int(iWide/8)
pair=np.zeros((2,int(wid))) #0 is roll, 1 is pitch

#save files
trace=open("horizon trace.txt","w")
attitude=open("horizon attitudes.txt","w")

#process all frame
t0=time.time()
while success:


    # split has array of colors (B,G,R) with index 0,1,2
    b,g,r=np.array(cv.split(image))

    #####blur the image

    #Gaussian Blur
    b = cv.GaussianBlur(b,(13,13),0)
    r = cv.GaussianBlur(r,(13,13),0)

    ###### intensity profile

    #get average of the intensity of the 4 pixels
    t1=time.time()
    for x in range(wide):
        intensityB[:,x]=b[:,x*4:(x+1)*4].mean(axis=1)
        intensityR[:,x]=r[:,x*4:(x+1)*4].mean(axis=1)

    #######plot intensity profile and save to image
    br=abs(intensityB-intensityR)

    ####maximums####
    for w in range(wide):
        Mbr[w]=np.argmax(br[:,w],axis=0)
    traceTime=time.time()-t0


    #### Calculate attitudes####
    #calculate the roll:
    for i in range(wid):
        dy=Mbr[i]-Mbr[-(i+1)]
        pair[0,i]=180/3.1415926*np.arctan(dy/((wid-i)*4))
        pair[1,i]=(dy/2-iHigh/2)*63/iHigh

    #remove outliers
    cleanRoll= abs(pair[0]-np.mean(pair[0]))<np.std(pair[0])
    cleanPitch= abs(pair[1]-np.mean(pair[1]))<np.std(pair[1])

    roll=np.mean(cleanRoll)
    stdRoll=np.std(cleanRoll)/m.sqrt(len(cleanRoll))
    pitch=np.mean(cleanPitch)
    stdPitch=np.std(cleanPitch)/m.sqrt(len(cleanPitch))
    attitudeTime=time.time()-t0

    ####save files####

    attitude.write("roll= {}+-{},pitch={}+-{},time={}\n".format(roll,stdRoll,pitch,stdPitch,attitudeTime))
    trace.write("{}, time={} \n\n".format(Mbr,traceTime))

    #end of while loop
    count+=1
    success,image=vidcap.read()

#save to file
attitude.close()
trace.close()
