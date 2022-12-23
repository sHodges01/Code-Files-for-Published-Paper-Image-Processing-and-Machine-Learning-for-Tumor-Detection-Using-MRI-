% Use this to crop around the brighest region of the image???
function [centerX,centerY] = findCenterOfMass(matrix)
[row,col] = size(matrix);
totalMass = 0;
xmoment = 0;
ymoment = 0;
for r = 1:row
    for c = 1:col
        xmoment = double(xmoment) + c * double(matrix(r,c));
        ymoment = double(ymoment) + r * double(matrix(r,c));
        totalMass = double(totalMass) + double(matrix(r,c));
    end
end
centerX = xmoment/totalMass;
centerY = ymoment/totalMass;
return
end