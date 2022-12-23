directory = dir("1_pics/*.jpg");
directory1 = dir("1_binPics/*.jpg");
directory2 = dir("2_augPics.jpg");
a = 0;
while a < 360
    for i = 1:length(directory)
          image_path = strcat("1_pics/",directory(i).name);
          image_path1 = strcat("1_binPics/", directory1(i).name);
          name = convertCharsToStrings(erase(directory(i).name,".jpg"));
          name1 = convertCharsToStrings(erase(directory1(i).name,".jpg"));
          img = im2gray(imread(image_path));
          img1 = im2gray(imread(image_path1));
% Crop
          [x,y] = findCenterOfMass(img);
          [x1,y1] = findCenterOfMass(img1);
          img = imcrop(img,[x-200,y-200,400,400]);
          img1 = imcrop(img1,[x1-200,y1-200,400,400]);

          J = imrotate(img, a,'bilinear','crop');
          J1 = imrotate(img1, a,'bilinear','crop');
% Rotate
          num = int2str(int32(a));
          new_name = strcat(name,"rotated_pics_",num,".jpg");
          new_name1 = strcat(name,"rotated_pics_",num,".jpg");
          newpath = strcat("2_augPics/",new_name);
          newpath1 = strcat("2_augBinPics/",new_name1);
          imwrite(J,newpath);
          imwrite(J1,newpath1);
% Histogram Normalization
          img2 = histNormal(J,40,210);
          new_name2 = strcat(erase(new_name,".jpg"),"normalized_20",".jpg");
          new_name22 = strcat(erase(new_name1,".jpg"),"normalized_20",".jpg");
          newpath2 = strcat("3_normPics/",new_name2);
          newpath22 = strcat("3_normBinPics/",new_name22);
          imwrite(img2,newpath2);
          imwrite(J1,newpath22);
% Gaussian 
          img3 = imgaussfilt(J, 3);
          new_name3 = strcat(erase(new_name,".jpg"),"gauss_",".jpg");
          new_name33 = strcat(erase(new_name1,".jpg"),"gauss_",".jpg");
          newpath3 = strcat("4_gauss/",new_name3);
          newpath33 = strcat("4_binGauss/",new_name33);
          imwrite(img3,newpath3);
          imwrite(J1,newpath33);
% Noise
          img4 = imnoise(J,'gaussian');
          new_name4 = strcat(erase(new_name,".jpg"),"noise_",".jpg");
          new_name44 = strcat(erase(new_name1,".jpg"),"noise_",".jpg");
          newpath4 = strcat("5_noise/",new_name4);
          newpath44 = strcat("5_binNoise/",new_name44);
          imwrite(img4,newpath4);
          imwrite(J1,newpath44);
     end
    a = a+3;
end
