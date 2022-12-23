format long g;
format compact;
fontSize = 20;
I= imread('MRI-9.jpg');
I=double(I);
I=I(:,:,1);
p3=0.05; %default
p4=0.95;
b = I;
x2 = rand(size(b));
d = find(x2 < p3/2);
b(d) = 0; % Minimum value
d = find(x2 >= p4);
b(d) = 1; % Maximum (saturated) value
originalImage=b+I;
windowWidth= 9;
halfWidth = floor(windowWidth/2);
middleIndex = ceil(windowWidth^2/2);
filteredImage= zeros(size(originalImage));
originalImage=double(originalImage);
[nrows, ncols] = size(originalImage);
threshold = 5; % graylevels - whatever.
for rows= windowWidth:nrows-windowWidth
  for cols= windowWidth:ncols-windowWidth
    thisWindow= originalImage(rows-halfWidth : rows + halfWidth, cols-halfWidth : cols + halfWidth);
    sortedValuesInWindow = sort(thisWindow(:), 'Ascend');
    minValue = sortedValuesInWindow(1);
    maxValue = sortedValuesInWindow(end);
    medianValue = sortedValuesInWindow(middleIndex);
    diffFromMin = abs(medianValue - minValue);
    diffFromMax = abs(medianValue - maxValue);
    if diffFromMin> threshold || diffFromMax > threshold
      % It's noise.  Replace by the median.
      newValue = medianValue;
    else
      % It's not noise.  Use the original value.
      newValue = originalImage(rows,cols);
    end
    filteredImage(rows,cols)=newValue;
  end
end
%filtered = imbinarize(filteredImage,.08);
subplot(1,2,1);
imshow (uint8(originalImage))
title('Original Image', 'FontSize', fontSize);
subplot(1, 2, 2);
imshow (uint8(filteredImage))
title('Filtered Image', 'FontSize', fontSize);
% Set up figure properties:
% Enlarge figure to full screen.
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
% Get rid of tool bar and pulldown menus that are along top of figure.
set(gcf, 'Toolbar', 'none', 'Menu', 'none');
% Give a name to the title bar.
set(gcf, 'Name', 'Demo by ImageAnalyst', 'NumberTitle', 'Off')


