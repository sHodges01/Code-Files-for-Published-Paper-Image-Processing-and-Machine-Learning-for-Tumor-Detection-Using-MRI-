from tensorflow import keras as kr
import numpy as np
import cv2
import glob

def predict(set_path,mask_path):
    paths = glob.glob(set_path + "/*.jpg")
    model = kr.models.load_model("70segmodel5.h5")
    for path in paths:
        name = path.split("/")[-1]
        new_path = mask_path + name
        image = cv2.imread(path,0).astype(np.uint8)
        reshape = np.expand_dims([image],axis = 3)
        pred = model.predict(reshape)[0]
        _,pred = cv2.threshold(pred,.3,255,cv2.THRESH_BINARY)
        cv2.imwrite(new_path,pred)
    return

predict("imgs/ready","imgs/masks/")