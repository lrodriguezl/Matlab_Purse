function [newX, newY] = transformCoordinates(x,y,theta,origin)
% Description:
% This function performs two coordinate transformations: Axis Rotation and
% Translation
% The direction of vector rotation is clockwise if theta is positive 
% (e.g. 90°), and counter-clockwise if theta is negative (e.g. -90°).
% Input:
% x- [n x 1] vector of x values
% y- [n x 1] vector of x values
% theta - double indicating rotation angle in radians 
% origin - (x,y) pair indicating origin
% Ouput:
% newX - [n x 1] vector of transformed x values
% newY - [n x 1] vector of transformed y values

% force input to be vertical vector
x=x(:); y=y(:);

% rotation and translation matrix
% The direction of vector rotation is counterclockwise if theta is positive 
% (e.g. 90°), and clockwise if theta is negative (e.g. -90°).
R = [cos(theta) sin(theta); -sin(theta) cos(theta)];
T = [1 0 -origin(1); 0 1 -origin(2)];

new_xy = R * T*[x'; y'; ones(1,length(x))];
newX = new_xy(1,:);
newY = new_xy(2,:);

end