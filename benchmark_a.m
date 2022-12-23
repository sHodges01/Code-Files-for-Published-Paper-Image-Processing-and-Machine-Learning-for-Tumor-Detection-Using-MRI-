
directory = dir("1_photos/*.jpg");

for i = 1:length(directory)
%Step 1: Preprocessing
    image_path = strcat("1_photos/",directory(i).name);
    img = rgb2gray(imread(image_path));
    m1 = double(min(min(img)));
    m2 = double(max(max(img)));
%"Gray level expanded to be from 0 to 255 if it occupies less than that?"
    im1 = histNormal(img,m1,m2);
    %imshow(im1);
    newpath = strcat("2_preprocessing/",directory(i).name);
    imwrite(im1,newpath);

%Step 2: Segmentation - Canny Edge Detection OR Adaptive Thresholding
    %Step 2 & 3? Canny Edge Detection
    C = edge(im1,'Canny');
    im1(C == 0) = 0;
    %imshow(C)
    newpath = strcat("3_CannyEdge/",directory(i).name);
    imwrite(C,newpath);

    newpath = strcat("3_CannyEdgeApplied/",directory(i).name);
    imwrite(im1,newpath);

%Step 4: Harris Method
    % Get the dimensions of the image.
    % numberOfColorBands should be = 1.
    [rows, columns, numberOfColorBands] = size(im1);
    if numberOfColorBands > 1
        % It's not really gray scale like we expected - it's color.
        % Convert it to gray scale by taking only the green channel.
        im1 = im1(:, :, 2); % Take green channel.
    end
        % Display the original gray scale image.
        subplot(2, 2, 1);
        imshow(im1, []);
        title('Original Grayscale Image');
        % Enlarge figure to full screen.
        set(gcf, 'units','normalized','outerposition',[0 0 1 1]);
        % Give a name to the title bar.
        set(gcf,'name','Laplace Transformation','numbertitle','off') 
    
        % Compute Laplacian
        laplacianKernel = [-1,-1,-1;-1,8,-1;-1,-1,-1]/8;
        laplacianImage = imfilter(double(im1), laplacianKernel);
        % Display the image.
        subplot(2, 2, 2);
%         imshow(laplacianImage, []);
        title('Laplacian Image');
         %h = laplace(cdf);
         newpath = strcat("4_HarrisLaplace/",directory(i).name);
         imwrite(laplacianImage,newpath);

end