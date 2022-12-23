import pandas as pd
from tensorflow import keras as kr
import numpy as np
import cv2
import glob
def build_unet(input_shape,num_classes):
    inputs = kr.Input(input_shape)
    s1,p1 = encode_block(inputs,70)
    print(s1.shape)
    s2,p2 = encode_block(p1,140)
    print(s2.shape)
    s3,p3 = encode_block(p2,280)
    print(s3.shape)
    s4,p4 = encode_block(p3,540)
    t1 = conv_block(p4,1080)
    print(s4.shape)
    d1 = deconv_block(t1,s4,540)
    print(d1.shape)
    d2 = deconv_block(d1,s3,280)
    print(d2.shape)
    d3 = deconv_block(d2,s2,140)
    print(d3.shape)
    d4 = deconv_block(d3,s1,70)
    print(d4.shape)
    if num_classes == 1:
        activat = "sigmoid"
    else:
        activat = "softmax"    
    outputs = kr.layers.Conv2D(num_classes,1,padding = "same", activation = activat)(d4)
    model = kr.Model(inputs,outputs)
    return model

def conv_block(input,filters):
    conv1 = kr.layers.Conv2D(filters,3,padding = "same")(input)
    conv1 = kr.layers.BatchNormalization()(conv1)
    conv1 = kr.layers.ReLU()(conv1)
    conv2 = kr.layers.Conv2D(filters,3,padding = "same")(conv1)
    conv2 = kr.layers.BatchNormalization()(conv2)
    conv2 = kr.layers.ReLU()(conv2)
    return conv2

def encode_block(input,filters):
    conv = conv_block(input,filters)
    max_pool = kr.layers.MaxPool2D(2)(conv)
    return conv,max_pool
def deconv_block(input,conv,filters):
    deconv1 = kr.layers.Conv2DTranspose(filters,2,strides = 2, padding = "same")(input)
    deconv1 = kr.layers.Concatenate()([deconv1,conv])
    x1 = conv_block(deconv1,filters)
    return x1
tpu = tf.distribute.cluster_resolver.TPUClusterResolver.connect()
tf.config.experimental_connect_to_cluster(tpu)
tpu_strategy = tf.distribute.experimental.TPUStrategy(tpu)
with tpu_strategy.scope():
    print(1)
    train_img_names = glob.glob("../input/mmmmmmmmmm/sets2/set1/x/*.jpg")
    gc.collect()
    print(2)
    train_mask_names = glob.glob("../input/mmmmmmmmmm/sets2/set1/y/*.jpg")
    gc.collect()
    print(3)
    train_img_names.sort()
    gc.collect()
    train_mask_names.sort()
    gc.collect()
    print(4)
    val_img_names = glob.glob("../input/taylorsv/sets/set6/x/*.jpg")
    gc.collect()
    print(5)
    val_mask_names = glob.glob("../input/taylorsv/sets/set6/y/*.jpg")
    gc.collect()
    print(6)
    train_set = [cv2.imread(path,0) for path in train_img_names]
    gc.collect()
    print(7)
    train_vals = [np.floor_divide(cv2.imread(path,0).astype(np.uint8),255) for path in train_mask_names]
    gc.collect()
    print(8)
    val_set = [cv2.imread(path,0) for path in val_img_names]
    print(9)
    val_vals = [np.floor_divide(cv2.imread(path,0).astype(np.uint8),255) for path in val_mask_names]
    print(10)
    val_img = np.array(val_set)
    print(11)
    val_val = np.array(val_vals)
    print(12)
    val_img = np.expand_dims(val_img, axis= 3)
    print(val_img.shape)
    print(13)
    #val_val = kr.utils.to_categorical(val_val)
    print(14)
    images = np.array(train_set)
    print(15)
    images = np.expand_dims(images,axis = 3)
    print(images.shape)
    print(16)
    masks = np.array(train_vals)
    print(np.unique(masks))
    print(17)
    #train_masks = kr.utils.to_categorical(masks)
    print(masks.shape)
    print(val_val.shape)
    print(18)
    image_dims = (images.shape[1],images.shape[2],images.shape[3])
    print(19)
    model = build_unet(image_dims,1)
    callback = kr.callbacks.EarlyStopping(monitor='loss', patience=3)
    m = kr.models.load_model("./finalmodel.h5")
    weights = m.get_weights()
    model.set_weights(weights)
    model.compile(optimizer = 'adam', loss = "binary_crossentropy", metrics = ['accuracy'])
    model.summary()
    history = model.fit(images,masks,batch_size= 16, epochs= 10,validation_data=(val_img,val_val),callbacks = [callback])
    model.save("./finalmodel.h5")