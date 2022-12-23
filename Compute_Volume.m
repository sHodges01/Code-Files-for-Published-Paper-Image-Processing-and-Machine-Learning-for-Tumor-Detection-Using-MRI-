img_directory = dir("imgs/ready/*.jpg");
mask_directory = dir("imgs/masks/*.jpg");

total_volume = 0;
alive_volume = 0;

% crop
 for i = 1:length(img_directory)
      name = erase(img_directory(i).name,".jpg");
      image_path = strcat("imgs/ready/",name,".jpg");
      mask_path = strcat("imgs/masks/",name,".jpg");
      img = imread(image_path);

      img = histNormal(img,20,200);
      mask = imbinarize(imread(mask_path),.1);

      img(mask == 0) = 0;

      img2 = img;
      
      maskPerim = bwperim(mask);
      radius = 1;
      decomposition = 0;
      se = strel('disk', radius, decomposition);
      smallTumorMask = imerode(mask,se);
      maskPerim2 = bwperim(smallTumorMask);
      bothMasks = maskPerim2 + maskPerim;
      maskPerim = closeBorder(bothMasks);
      img(maskPerim == 1) = 255;
    
      img = imgaussfilt(img,1);
      img = histNormal(img,40,140);
      img = imbinarize(img);
      
      total_volume = total_volume + sum(sum(mask));
      alive_volume = alive_volume + sum(sum(img));

      newpath = strcat("imgs/post/",name,".tif");
      imwrite(img,newpath);

 end
 percent_dead = string(1 - alive_volume/total_volume);
 disp(strcat(percent_dead ," percent of the tumor is dead"))