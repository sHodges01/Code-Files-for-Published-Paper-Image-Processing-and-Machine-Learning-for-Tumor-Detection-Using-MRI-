directory = dir("e/*.jpg");
mkdir("ready");
% Crop
    for i = 1:length(directory)
          image_path = strcat("e/",directory(i).name);
          img = im2gray(imread(image_path));
          [x,y] = findCenterOfMass(img);
          img = imcrop(img,[x-200,y-200,400,400]);
          img = imresize(img,[224 224]);
          new_path = strcat("ready/",directory(i).name);
          imwrite(img,new_path)
    end
    