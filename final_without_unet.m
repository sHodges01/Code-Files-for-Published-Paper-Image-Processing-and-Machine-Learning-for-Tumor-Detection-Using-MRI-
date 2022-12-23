     %%%%%%%%%%% data set 1 %%%%%%%%%%%%%%

% assign where images will be pulled from - manually cropped images
directory = dir("data_set_1/*.jpg");
  volume_dead = 0;
  % volume_whole = 0;
 for i = 1:length(directory)
 % Pre-Processing (including beforehand cropping)
      image_path = strcat("data_set_1/",directory(i).name);
      img = rgb2gray(imread(image_path));

 % Processing
      % increases the contrast between cutoffs (pixel values: 20-240) -
      % anything below 20 -> 0 above 240 -> 255  
      im1 = histNormal(img,20,240);
      % median filter - applied blur and reduces noise
      im2 = medfilt2(im1);
      % apply sobel edge. 
      % creates binary mask of regions with extreme contrast
      edged = im2uint8(edge(im2,"sobel"));
      % take binary values of binary mask and then apply morphological
      % closing to fill in the gaps between edges
      % creates general tumor region
      tumorMask = isolateTumor(edged);
      % superimpse mask on black background
      im1(tumorMask == 0) = 0;
      newpath = strcat("2_edge/",directory(i).name);
      imwrite(edged,newpath);
      % anything that is considered bright (above 80) is forced to 255
      % apply gauss filter to reduce noise and creates halo effect for
      % contouring
      im1 = imgaussfilt(histNormal(im1,0,80),5);
      newpath = strcat("3_gauss/",directory(i).name);
      im1 = imsharpen(im1,"Amount",2);
      % creates 2x2 border of black pixels for creating edges
      im1 = padarray(im1,[2 2],0,"both");
      img = padarray(img,[2 2],0,"both");
      imwrite(im1,newpath);
      % refining tumor mask by trimming the border using imclearborder and
      % morphological closing
      tumorMask = seggers(im1);
      % anywhere where tumorMask is 0(black), im1 will also be 0(black)
      im1(tumorMask == 0) = 0;
      % trims away at tumor to get the right tumor region
      finalTumorMask = finalcutt(im1);
      % change contrast to make bright pixels above 110 be 255 
      % everything below 40 becomes 0
      % clearly identifies living as white and dead as black
      img2 = histNormal(img, 40,110);
      img2(finalTumorMask == 0) = 0;
      newpath = strcat("4_normalized/",directory(i).name);
      imwrite(img2,newpath);
      newpath = strcat("5_binarized/",directory(i).name);
      imwrite(finalTumorMask,newpath);
      % image area identification
      img = histNormal(img,40,130);
      RGB = repmat(img, [1, 1, 3]);
      [R,G,B] = imsplit(RGB);
      B(finalTumorMask == 0) = 255;
      RGB = cat(3,R,G,B);
      newpath = strcat("6_colored/",directory(i).name);
      imwrite(RGB,newpath);
      segmask = imsegkmeans(RGB,4);
      image = labeloverlay(RGB,segmask);
      newpath = strcat("7_kmeans/",directory(i).name);
      imwrite(image,newpath);   

% Post-Processing
      % Otsus method to choose global threshold on pre-determined contrast
      BW2 = imbinarize(img2);
      % Sums all living tumor cells in image (white pixels)
      numWhitePixels = sum(sum(BW2));
      % Sums only tumor region
      numPixelsTum = sum(sum(finalTumorMask));
      % subtracts living tumor cells from entire tumor region to give dead
      % tumor volume
      dead_area = abs(numPixelsTum - numWhitePixels);
      volume_dead = volume_dead + dead_area;
      % volume_whole = volume_whole + numWhitePixels;
      % volume_percent = (volume_dead/volume_whole)*100;
 end
 
 volume_dead_with_gap_ratio = volume_dead*1;
 disp(strcat("dead tumor volume is ~ ",string(volume_dead)," pixel^3"))

         %%%%%%%%%%% data set 3 %%%%%%%%%%%%%%

 % assign where images will be pulled from - manually cropped images
directory1 = dir("data_set_3/*.jpg");
  volume_dead1 = 0;
  % volume_whole1 = 0;
 for i = 1:length(directory1)
 % Pre-Processing (including beforehand cropping)
      image_path1 = strcat("data_set_3/",directory1(i).name);
      img1 = rgb2gray(imread(image_path1));

 % Processing
      % increases the contrast between cutoffs (pixel values: 20-240) -
      % anything below 20 -> 0 above 240 -> 255  
      im11 = histNormal(img1,20,240);
      % median filter - applied blur and reduces noise
      im21 = medfilt2(im11);
      % apply sobel edge. 
      % creates binary mask of regions with extreme contrast
      edged1 = im2uint8(edge(im21,"sobel"));
      % take binary values of binary mask and then apply morphological
      % closing to fill in the gaps between edges
      % creates general tumor region
      tumorMask1 = isolateTumor(edged1);
      % superimpse mask on black background
      im11(tumorMask1 == 0) = 0;
      newpath1 = strcat("2_edge/",directory1(i).name);
      imwrite(edged1,newpath1);
      % anything that is considered bright (above 80) is forced to 255
      % apply gauss filter to reduce noise and creates halo effect for
      % contouring
      im11 = imgaussfilt(histNormal(im11,0,80),5);
      newpath1 = strcat("3_gauss/",directory1(i).name);
      im11 = imsharpen(im11,"Amount",2);
      % creates 2x2 border of black pixels for creating edges
      im11 = padarray(im11,[2 2],0,"both");
      img1 = padarray(img1,[2 2],0,"both");
      imwrite(im11,newpath1);
      % refining tumor mask by trimming the border using imclearborder and
      % morphological closing
      tumorMask1 = seggers(im11);
      % anywhere where tumorMask is 0(black), im1 will also be 0(black)
      im11(tumorMask1 == 0) = 0;
      % trims away at tumor to get the right tumor region
      finalTumorMask1 = finalcutt(im11);
      % change contrast to make bright pixels above 110 be 255 
      % everything below 40 becomes 0
      % clearly identifies living as white and dead as black
      img21 = histNormal(img1, 40,110);
      img21(finalTumorMask1 == 0) = 0;
      newpath1 = strcat("4_normalized/",directory1(i).name);
      imwrite(img21,newpath1);
      newpath1 = strcat("5_binarized/",directory1(i).name);
      imwrite(finalTumorMask1,newpath1);
      % image area identification
      img1 = histNormal(img1,40,130);
      RGB1 = repmat(img1, [1, 1, 3]);
      [R,G,B] = imsplit(RGB1);
      B(finalTumorMask1 == 0) = 255;
      RGB1 = cat(3,R,G,B);
      newpath1 = strcat("6_colored/",directory1(i).name);
      imwrite(RGB1,newpath1);
      segmask1 = imsegkmeans(RGB1,4);
      image1 = labeloverlay(RGB1,segmask1);
      newpath1 = strcat("7_kmeans/",directory1(i).name);
      imwrite(image1,newpath1);   

% Post-Processing
      % Otsus method to choose global threshold on pre-determined contrast
      BW21 = imbinarize(img21);
      % Sums all living tumor cells in image (white pixels)
      numWhitePixels1 = sum(sum(BW21));
      % Sums only tumor region
      numPixelsTum1 = sum(sum(finalTumorMask1));
      % subtracts living tumor cells from entire tumor region to give dead
      % tumor volume
      dead_area1 = abs(numPixelsTum1 - numWhitePixels1);
      volume_dead1 = volume_dead1 + dead_area1;
      % volume_whole = volume_whole + numWhitePixels;
      % volume_percent = (volume_dead/volume_whole)*100;
 end

 volume_dead1_with_gap_ratio = volume_dead1*1;
 disp(strcat("dead tumor volume is ~ ",string(volume_dead1)," pixel^3"))

        %%%%%%%%%%% data set 4 %%%%%%%%%%%%%%

 % assign where images will be pulled from - manually cropped images
directory2 = dir("data_set_4/*.jpg");
  volume_dead2 = 0;
  % volume_whole2 = 0;
 for i = 1:length(directory2)
 % Pre-Processing (including beforehand cropping)
      image_path2 = strcat("data_set_4/",directory2(i).name);
      img2 = rgb2gray(imread(image_path2));

 % Processing
      % increases the contrast between cutoffs (pixel values: 20-240) -
      % anything below 20 -> 0 above 240 -> 255  
      im12 = histNormal(img2,20,240);
      % median filter - applied blur and reduces noise
      im22 = medfilt2(im12);
      % apply sobel edge. 
      % creates binary mask of regions with extreme contrast
      edged2 = im2uint8(edge(im22,"sobel"));
      % take binary values of binary mask and then apply morphological
      % closing to fill in the gaps between edges
      % creates general tumor region
      tumorMask2 = isolateTumor(edged2);
      % superimpse mask on black background
      im12(tumorMask2 == 0) = 0;
      newpath2 = strcat("2_edge/",directory2(i).name);
      imwrite(edged2,newpath2);
      % anything that is considered bright (above 80) is forced to 255
      % apply gauss filter to reduce noise and creates halo effect for
      % contouring
      im12 = imgaussfilt(histNormal(im12,0,80),5);
      newpath2 = strcat("3_gauss/",directory2(i).name);
      im12 = imsharpen(im12,"Amount",2);
      % creates 2x2 border of black pixels for creating edges
      im12 = padarray(im12,[2 2],0,"both");
      img2 = padarray(img2,[2 2],0,"both");
      imwrite(im12,newpath2);
      % refining tumor mask by trimming the border using imclearborder and
      % morphological closing
      tumorMask2 = seggers(im12);
      % anywhere where tumorMask is 0(black), im1 will also be 0(black)
      im12(tumorMask2 == 0) = 0;
      % trims away at tumor to get the right tumor region
      finalTumorMask2 = finalcutt(im12);
      % change contrast to make bright pixels above 110 be 255 
      % everything below 40 becomes 0
      % clearly identifies living as white and dead as black
      img22 = histNormal(img2, 40,110);
      img22(finalTumorMask2 == 0) = 0;
      newpath2 = strcat("4_normalized/",directory2(i).name);
      imwrite(img22,newpath2);
      newpath2 = strcat("5_binarized/",directory2(i).name);
      imwrite(finalTumorMask2,newpath2);
      % image area identification
      img2 = histNormal(img2,40,130);
      RGB2 = repmat(img2, [1, 1, 3]);
      [R,G,B] = imsplit(RGB2);
      B(finalTumorMask2 == 0) = 255;
      RGB2 = cat(3,R,G,B);
      newpath2 = strcat("6_colored/",directory2(i).name);
      imwrite(RGB2,newpath2);
      segmask2 = imsegkmeans(RGB2,4);
      image2 = labeloverlay(RGB2,segmask2);
      newpath2 = strcat("7_kmeans/",directory2(i).name);
      imwrite(image2,newpath2);   

% Post-Processing
      % Otsus method to choose global threshold on pre-determined contrast
      BW22 = imbinarize(img22);
      % Sums all living tumor cells in image (white pixels)
      numWhitePixels2 = sum(sum(BW22));
      % Sums only tumor region
      numPixelsTum2 = sum(sum(finalTumorMask2));
      % subtracts living tumor cells from entire tumor region to give dead
      % tumor volume
      dead_area2 = abs(numPixelsTum2 - numWhitePixels2);
      volume_dead2 = volume_dead2 + dead_area2;

 end

volume_dead2_with_gap_ratio = volume_dead2*1.3;
disp(strcat("dead tumor volume is ~ ",string(volume_dead2_with_gap_ratio)," pixel^3"))

% Plotting Results
volume_dead_data = [volume_dead_with_gap_ratio volume_dead1_with_gap_ratio volume_dead2_with_gap_ratio]; 
data_set_number = [4 9 13]; 

plot(data_set_number,volume_dead_data, '-*')
grid on
title('Dead Tumor Volume Over Course of BBCT') 
xlabel('Number of Days After Bacteria Injection')
ylabel('Dead Tumor Volume [pixel^3]')


