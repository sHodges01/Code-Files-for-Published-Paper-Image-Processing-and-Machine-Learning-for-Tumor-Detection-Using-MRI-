function image = histNormal(image,min,max)
      k2 = double(image);
      k3 = (k2-min)./(max-min);
      k4 = k3.*255;
      k5=uint8(k4);
      image = k5;
      return
 end