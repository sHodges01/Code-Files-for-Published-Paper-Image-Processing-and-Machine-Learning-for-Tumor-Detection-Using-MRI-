directory = dir("1_photos/*.jpg");

for i = 1:length(directory)
%Step 1: Preprocessing
    image_path = strcat("1_photos/",directory(i).name);
    im1 = imread(image_path);
    %im2 = imgaussfilt(im1,3);
    im2 = medfilt3(im1);
    %imshow(im2)

    newpath = strcat("2_preprocessing/",directory(i).name);
    imwrite(im2,newpath);

% Step 2: Watershed
    % Tumor / Dead Space
    % Thresholding: set level 
    bw = imbinarize(im2,.6);
    %imshowpair(im2,bw,'montage')

    newpath1 = strcat("3_deadTumorSegSet/",directory(i).name);
    imwrite(bw,newpath1);
    % Brain Area / Tumor 
    % try improfile(); ?
    level = graythresh(im2);
    mask = imbinarize(im2, level);
    %mask1 = ~mask;
    dd = -bwdist(~ mask);
    dd = imhmin(dd, 6.2);
    ws1 = watershed(dd);
    l1 = rgb2gray(ws1);
    l = label2rgb(l1);
    mask(l == 0) = false;
    %imshow(mask);
    %imshowpair(im2,mask,'montage')
   
    newpath = strcat("3_TumorSeg/",directory(i).name);
    imwrite(mask,newpath);
% Step 3: Crop
    im2 = uint8(mask);
    im3 = graythresh(im2);
    BW = imbinarize(im2, im3);
    %background = labeloverlay(im2,BW);
    %imshow(background);

    %newpath = strcat("4_crop/",directory(i).name);
    %imwrite(background,newpath);

end