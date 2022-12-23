% Benchmarking resource paper d
% Minimum_Time_Delay_and_More_Efficient_Image_Filtering_Brain_Tumour_Detection_with_the_help_of_MATLAB.pdf

% photo directory
directory = dir("1_photos/*.jpg");

 for i = 1:length(directory)
 % Pre-Processing (including beforehand cropping)
    image_path = strcat("1_photos/",directory(i).name);
    img = rgb2gray(imread(image_path));

 % Gaussian Filter  
    gauss = imgaussfilt(img,2);
    newpath = strcat("2_GaussianHPF_d/",directory(i).name);
    imwrite(gauss,newpath);

 % Median Filter w/o gauss
    median = medfilt2(img);
    newpath = strcat("3_Median_No_Gauss_d/",directory(i).name);
    imwrite(median,newpath);

 % Median Filter w/ gauss
    medGauss = medfilt2(gauss);
    newpath = strcat("3_Median_Gauss_d/",directory(i).name);
    imwrite(medGauss,newpath);

%   % watershed
%     W = -img;
%     WS = watershed(W);
% %     bw = imbinarize(img);
% %     W(~bw) = 0;
% %     rgb = label2rgb(WS,'jet',[.5 .5 .5]);
%     BW = imbinarize(img); 
%     CC = bwconncomp(BW);
%     L = labelmatrix(CC);
%     newpath = strcat("4_Watershed_d/",directory(i).name);
%     imwrite(L,newpath);

  % Entropy
    E = entropyfilt(img,true(9));
    newpath = strcat("5_Entropy_d/",directory(i).name);
    imwrite(E,newpath);

  % Weiner Filter
    WF = imnoise(medGauss,'gaussian',0,0.025);
    newpath = strcat("6_Weiner_d/",directory(i).name);
    imwrite(WF,newpath);

  % Gradient Magnitude
    grad_mag = imgradient(img, 'sobel');
    newpath = strcat("8_GradMag_d/",directory(i).name);
    imwrite(grad_mag,newpath);

  % Regional Maxima
    regmax = imregionalmax(img);
    newpath = strcat("9_RegMax_d/",directory(i).name);
    imwrite(regmax,newpath);

 end